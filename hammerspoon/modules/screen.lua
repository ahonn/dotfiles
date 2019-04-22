-- Screen enhancement

local window = require "hs.window"
local mouse = require "hs.mouse"
local geometry = require "hs.geometry"
local hotkey = require "hs.hotkey"
local fnutils = require "hs.fnutils"

function focusScreen(option)
  local current = window:focusedWindow():screen()

  -- get target screen's windows
  local target = options == "Left" and current:previous() or current:next()
  local wins = fnutils.filter(window.orderedWindows(), function(win)
    return win:screen() == target;
  end)

  -- focus target screen window
  local winToFocus = #wins > 0 and wins[1] or window.desktop()
  winToFocus:focus()

  -- move cursor to target screen center
  local point = geometry.rectMidPoint(target:fullFrame())
  mouse.setAbsolutePosition(point)
  -- move cursor to current screen edge
  mouse.setRelativePosition(geometry.point(0, point.y))
end

local ctrl_cmd = { "cmd" }

hotkey.bind(ctrl_cmd, "Left", fnutils.partial(focusScreen, "Left"))
hotkey.bind(ctrl_cmd, "Right", fnutils.partial(focusScreen, "Right"))
