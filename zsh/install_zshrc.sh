#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_source="${script_dir}/zshrc.sh"
zshrc_path="${HOME}/.zshrc"
start_marker='^# Config-Start'
end_marker='^# Config-End'

tmp_template="$(mktemp)"
tmp_out=""

cleanup() {
  if [ -n "${tmp_out}" ]; then
    rm -f "${tmp_out}"
  fi
  rm -f "${tmp_template}"
}
trap cleanup EXIT

awk -v start="${start_marker}" -v end="${end_marker}" '
  $0 ~ start { in_block = 1 }
  in_block { print }
  $0 ~ end { in_block = 0 }
' "${template_source}" > "${tmp_template}"

if [ ! -s "${tmp_template}" ]; then
  echo "Template block not found in ${template_source}" >&2
  exit 1
fi

if [ ! -f "${zshrc_path}" ]; then
  cat "${tmp_template}" > "${zshrc_path}"
  echo "Created ${zshrc_path} with template block."
  exit 0
fi

if grep -qE "${start_marker}" "${zshrc_path}" && grep -qE "${end_marker}" "${zshrc_path}"; then
  tmp_out="$(mktemp)"
  awk -v start="${start_marker}" -v end="${end_marker}" -v tpl="${tmp_template}" '
    BEGIN {
      while ((getline line < tpl) > 0) {
        template = template line ORS
      }
      close(tpl)
    }
    $0 ~ start {
      printf "%s", template
      in_block = 1
      next
    }
    in_block {
      if ($0 ~ end) {
        in_block = 0
      }
      next
    }
    { print }
  ' "${zshrc_path}" > "${tmp_out}"
  mv "${tmp_out}" "${zshrc_path}"
  echo "Replaced Config block in ${zshrc_path}."
else
  if [ -s "${zshrc_path}" ]; then
    if [ "$(tail -c 1 "${zshrc_path}")" != $'\n' ]; then
      printf '\n' >> "${zshrc_path}"
    fi
    printf '\n' >> "${zshrc_path}"
  fi
  cat "${tmp_template}" >> "${zshrc_path}"
  echo "Appended template block to ${zshrc_path}."
fi

echo "Run: source ~/.zshrc"
