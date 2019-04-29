require("modules.window")
require("modules.screen")
require("modules.headphone")
require("modules.vi-mode")
require("modules.switcher")

local clipboard = require("modules.clipboard")

-- disable animationDuration
hs.window.animationDuration = 0

clipboard:bindHotkeys({
  showClipboard = {{"cmd", "shift"}, "v"}
})
clipboard:start()

function reloadConfigCallback(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    clipboard:stop()
    hs.reload()
  end
end

local configPath = os.getenv("HOME") .. "/.hammerspoon/"
reloadWatcher = hs.pathwatcher.new(configPath, reloadConfigCallback):start()

hs.notify.new({
  title="Hammerspoon",
  informativeText="Config Reload Success",
  withdrawAfter=1,
}):send()

