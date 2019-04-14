-- Navigation

local eventtap = require "hs.eventtap"

function tapperCallback(evt)
  local flags = evt:getFlags()
  local keyCode = evt:getKeyCode()

  function modsEquals(keys)
    for i, key in ipairs(keys) do
      if not flags[key] then
        return false
      end
    end
    return true
  end

  if modsEquals({ "alt" }) then
    if keyCode == 4 then
      -- ctrl + h as left
      return true, {hs.eventtap.event.newKeyEvent({}, "left", true)}
    elseif keyCode == 38 then
      -- ctrl + j as bottom
      return true, {hs.eventtap.event.newKeyEvent({}, "down", true)}
    elseif keyCode == 40 then
      -- ctrl + k as up
      return true, {hs.eventtap.event.newKeyEvent({}, "up", true)}
    elseif keyCode == 37 then
      -- ctrl + l as right
      return true, {hs.eventtap.event.newKeyEvent({}, "right", true)}
    end
  end
end

tapper = eventtap.new({eventtap.event.types.keyDown}, tapperCallback)
tapper:start()
