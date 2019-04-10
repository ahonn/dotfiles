-- Application management

local window = require "hs.window"
local application = require "hs.application"
local appfinder = require "hs.appfinder"
local hotkey = require "hs.hotkey"
local fnutils = require "hs.fnutils"

function toggleApplication(name)
  local cwin = window.focusedWindow()
  -- hide application if current window is target
  if (cwin:application():name() == name) then
    cwin:application():hide()
  else
    application.launchOrFocus(name)
    if name == 'Finder' then
      appfinder.appFromName(name):activate()
    end
  end
end

hotkey.bind({"alt"}, "B", fnutils.partial(toggleApplication, "Finder"))
hotkey.bind({"alt"}, "A", fnutils.partial(toggleApplication, "Alacritty"))
hotkey.bind({"alt"}, "C", fnutils.partial(toggleApplication, "Google Chrome"))
hotkey.bind({"alt"}, "T", fnutils.partial(toggleApplication, "Trello"))
hotkey.bind({"alt"}, "W", fnutils.partial(toggleApplication, "WeChat"))
