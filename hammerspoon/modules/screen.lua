-- Screen enhancement

function focusScreen(option)
  local current = hs.window:focusedWindow():screen()

  -- get target screen's windows
  local target = options == "Left" and current:previous() or current:next()
  local wins = fnutils.filter(hs.window.orderedWindows(), function(win)
    return win:screen() == target;
  end)

  -- focus target screen window
  local winToFocus = #wins > 0 and wins[1] or hs.window.desktop()
  winToFocus:focus()

  -- move cursor to target screen center
  local point = hs.geometry.rectMidPoint(target:fullFrame())
  hs.mouse.setAbsolutePosition(point)
  -- move cursor to current screen edge
  hs.mouse.setRelativePosition(hs.geometry.point(0, point.y))
end

local ctrl_cmd = { "cmd" }

----------------------- hotkey bindings ----------------------------

-- binding ctrl + cmd + left as focus left screen
hs.hotkey.bind(ctrl_cmd, "Left", hs.fnutils.partial(focusScreen, "Left"))
-- binding ctrl + cmd + right as focus right screen
hs.hotkey.bind(ctrl_cmd, "Right", hs.fnutils.partial(focusScreen, "Right"))
