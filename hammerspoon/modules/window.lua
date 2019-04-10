-- Window management

local math = require "math"

local hotkey = require "hs.hotkey"
local window = require "hs.window"
local geometry = require "hs.geometry"
local alert = require "hs.alert"
local fnutils = require "hs.fnutils"

-- disable animationDuration
window.animationDuration = 0

local gridparts = 30

function windowResize(option)
  local cwin = window.focusedWindow()

  if cwin then
    if not cwin:isFullScreen() then
      local screenFrame = cwin:screen():fullFrame()
      local windowFrame = cwin:frame();
      local step = {
        w = screenFrame.w / gridparts,
        h = screenFrame.h / gridparts
      }

      local newrect;
      if option == "Left" then
        newrect = geometry.rect(0, 0, screenFrame.w / 2, screenFrame.h)
      elseif option == "Right" then
        newrect = geometry.rect(screenFrame.w / 2, 0, screenFrame.w / 2, screenFrame.h)
      elseif option == "Top" then
        newrect = geometry.rect(0, 0, screenFrame.w, screenFrame.h / 2)
      elseif option == "Bottom" then
        newrect = geometry.rect(0, screenFrame.h / 2, screenFrame.w, screenFrame.h / 2)
      elseif option == "Center" then
        newrect = geometry.rect(
          (screenFrame.w - windowFrame.w) / 2,
          (screenFrame.h - windowFrame.h) / 2,
          windowFrame.w,
          windowFrame.h
        )
      elseif option == "ZoomIn" then
        newrect = geometry.rect(
          windowFrame.x - step.w,
          windowFrame.y - step.h,
          windowFrame.w + step.w * 2,
          windowFrame.h + step.h * 2
        )
      elseif option == "ZoomOut" then
        newrect = geometry.rect(
          windowFrame.x + step.w,
          windowFrame.y + step.h,
          windowFrame.w - step.w * 2,
          windowFrame.h - step.h * 2
        )
      end
      cwin:setFrame(newrect);
    end
  else
    alert.show('No focused window!')
  end
end

function isMaximize(win)
  -- win:screen():fullFrame() return 0.0, 0.0, 1920.0, 1080.0
  -- win:screen():frame() frame return 0.0, 23.0, 1920.0, 1057.0
  local screenFrame = win:screen():frame()
  local windowFrame = win:frame()

  return (
    math.abs(windowFrame.x) == screenFrame.x
    and windowFrame.y == screenFrame.y
    and windowFrame.w == screenFrame.w
    and windowFrame.h == screenFrame.h
  )
end

local frameCache = {}
function windowMaximize()
  local cwin = window.focusedWindow()

  if cwin then
    if not cwin:isFullScreen() then
      local cache = frameCache[cwin:id()]
      if isMaximize(cwin) and cache then
        cwin:setFrame(cache)
        frameCache[cwin:id()] = nil
      else
        frameCache[cwin:id()] = cwin:frame()
        cwin:maximize()
      end
    end
  else
    alert.show('No focused window!')
  end
end

local hyper = { "ctrl", "cmd" }

-- binding ctrl + cmd H/J/K/L to resize window Left/Bottom/Top/Right
hotkey.bind(hyper, "H", hs.fnutils.partial(windowResize, "Left"))
hotkey.bind(hyper, "K", hs.fnutils.partial(windowResize, "Top"))
hotkey.bind(hyper, "J", hs.fnutils.partial(windowResize, "Bottom"))
hotkey.bind(hyper, "L", hs.fnutils.partial(windowResize, "Right"))

-- binding ctrl + cmd C to center window
hotkey.bind(hyper, "C", hs.fnutils.partial(windowResize, "Center"))

-- binding ctrl + cmd =/- to zoom in/out window
hotkey.bind(hyper, "=", hs.fnutils.partial(windowResize, "ZoomIn"))
hotkey.bind(hyper, "-", hs.fnutils.partial(windowResize, "ZoomOut"))

-- binding ctrl + cmd m to maximize window
hotkey.bind(hyper, "M", windowMaximize)
