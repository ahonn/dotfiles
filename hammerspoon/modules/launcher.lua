-- Application management

local window = require "hs.window"
local application = require "hs.application"
local appfinder = require "hs.appfinder"
local hotkey = require "hs.hotkey"
local fnutils = require "hs.fnutils"

local applist = {
  {key="b", name="Finder"},
  {key="a", name="Alacritty"},
  {key="c", name="Google Chrome"},
  {key="t", name="iTunes"},
  {key="w", name="WeChat"},
}

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

fnutils.each(applist, function (app)
  hotkey.bind({"alt"}, app.key, fnutils.partial(toggleApplication, app.name))
end)

