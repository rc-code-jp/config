local EN = "com.apple.keylayout.Australian"
local JA = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"

local enApps = {
  Terminal = true,
  Ghostty  = true,
}

hs.application.watcher.new(function(appName, eventType)
  if eventType ~= hs.application.watcher.activated then return end
  local target = enApps[appName] and EN or JA
  if hs.keycodes.currentSourceID() ~= target then
    hs.keycodes.currentSourceID(target)
  end
end):start()

