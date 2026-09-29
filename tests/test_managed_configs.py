"""一時ディレクトリで設定の保持とステータス表示の回帰を検証する。"""

import json
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
BEGIN = "# chezmoi: zshrc begin"
END = "# chezmoi: zshrc end"


class ManagedConfigTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.destination = self.directory / "destination"
        self.destination.mkdir()
        self.config = self.directory / "chezmoi.toml"
        self.config.write_text("")

    def apply(self, name):
        return subprocess.run(
            [
                "chezmoi", "--source", str(ROOT),
                "--destination", str(self.destination),
                "--config", str(self.config),
                "--cache", str(self.directory / "cache"),
                "--persistent-state", str(self.directory / "state.boltdb"),
                "--no-tty", "apply", str(self.destination / name),
            ],
            text=True, capture_output=True,
        )

    def assert_applies_twice(self, name):
        result = self.apply(name)
        self.assertEqual(result.returncode, 0, result.stderr)
        first = (self.destination / name).read_text()
        result = self.apply(name)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.destination / name).read_text(), first)
        return first

    def test_zsh_initial_settings_survive(self):
        path = self.destination / ".zshrc"
        # 末尾改行がなくても既存のコマンドと管理ブロックを分離する。
        path.write_text('export KEEP_SETTING="設定を保持"')
        output = self.assert_applies_twice(".zshrc")
        self.assertTrue(output.startswith('export KEEP_SETTING="設定を保持"\n'))
        self.assertEqual(output.count(BEGIN), 1)
        self.assertEqual(output.count(END), 1)
        result = subprocess.run(["zsh", "-n", str(path)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_zsh_new_file(self):
        output = self.assert_applies_twice(".zshrc")
        self.assertTrue(output.startswith(BEGIN))

    def test_zsh_keeps_both_sides_of_managed_block(self):
        (self.destination / ".zshrc").write_text(
            f"# 個人設定（前）\n{BEGIN}\n# 旧管理設定\n{END}\n# 個人設定（後）\n"
        )
        output = self.assert_applies_twice(".zshrc")
        self.assertTrue(output.startswith("# 個人設定（前）\n"))
        self.assertTrue(output.endswith("# 個人設定（後）\n"))
        self.assertNotIn("# 旧管理設定", output)

    def test_zsh_rejects_incomplete_duplicate_and_reversed_markers(self):
        path = self.destination / ".zshrc"
        for content in [
            f"{BEGIN}\n# 個人設定\n", f"# 個人設定\n{END}\n",
            f"{BEGIN}\n{END}\n{BEGIN}\n{END}\n", f"{END}\n{BEGIN}\n",
        ]:
            with self.subTest(content=content):
                path.write_text(content)
                result = self.apply(".zshrc")
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(path.read_text(), content)

    def test_git_keeps_identity_aliases_and_includes(self):
        path = self.destination / ".gitconfig"
        path.write_text(
            '# 個人設定\n[user]\n name = 設定テスト\n email = test@example.invalid\n'
            '[alias]\n st = status --short\n[include]\n path = ~/.gitconfig.local\n'
            '[init]\n defaultBranch = master\n defaultBranch = old\n'
        )
        output = self.assert_applies_twice(".gitconfig")
        for key, expected in {
            "user.name": "設定テスト", "user.email": "test@example.invalid",
            "alias.st": "status --short", "include.path": "~/.gitconfig.local",
            "init.defaultBranch": "main",
        }.items():
            value = subprocess.check_output(
                ["git", "config", "--file", str(path), "--get-all", key], text=True
            ).strip()
            self.assertEqual(value, expected)
        self.assertIn("# 個人設定", output)

    def test_git_new_file(self):
        output = self.assert_applies_twice(".gitconfig")
        self.assertIn("defaultBranch = main", output)

    def statusline(self, data):
        result = subprocess.run(
            ["/bin/bash", str(ROOT / "home/dot_claude/executable_statusline-command.sh")],
            input=json.dumps(data), text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        return re.sub(r"\x1b\[[0-9;]*m", "", result.stdout)

    def test_statusline_missing_context_does_not_shift_limits(self):
        output = self.statusline({
            "cwd": str(self.directory), "model": {"display_name": "検証モデル"},
            "context_window": {"used_percentage": None},
            "rate_limits": {
                "five_hour": {"used_percentage": 25, "resets_at": 2000000000},
                "seven_day": {"used_percentage": 50, "resets_at": 2000000000},
            },
        })
        self.assertNotIn("ctx:", output)
        self.assertIn("5h: 25%", output)
        self.assertIn("7d: 50%", output)
        self.assertNotIn("2000000000%", output)

    def test_statusline_empty_limits_keep_worktree_and_special_path(self):
        cwd = self.directory / "空白 タブ\t改行\nパス"
        cwd.mkdir()
        output = self.statusline({
            "cwd": str(cwd), "model": {"id": "検証モデル"},
            "context_window": {"used_percentage": 0},
            "worktree": {"name": "作業ツリー"},
        })
        self.assertIn(str(cwd), output)
        self.assertIn("ctx:0%", output)
        self.assertIn("[wt:作業ツリー]", output)
        self.assertNotIn("5h:", output)
        self.assertNotIn("7d:", output)


if __name__ == "__main__":
    unittest.main()
