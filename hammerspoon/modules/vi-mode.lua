-- Navigation

function tapperCallback(evt)
  local flags = evt:getFlags()
  local keyCode = evt:getKeyCode()
  local char = evt:getCharacters()

  local holdAlt = not flags['ctrl'] and not flags['shift'] and flags['alt']
  if holdAlt then
    if char == "h" then
      -- bind alt + h as left
      return true, {hs.eventtap.event.newKeyEvent({}, "left", true)}
    elseif char == "j" then
      -- bind alt + j as down
      return true, {hs.eventtap.event.newKeyEvent({}, "down", true)}
    elseif char == "k" then
       -- bind alt + k as up
      return true, {hs.eventtap.event.newKeyEvent({}, "up", true)}
    elseif char == 'l' then
       -- bind alt + l as right
      return true, {hs.eventtap.event.newKeyEvent({}, "right", true)}
    elseif char == '∫' then
       -- bind alt + b as before world
      return true, {hs.eventtap.event.newKeyEvent({ "alt" }, "left", true)}
    elseif char == '∑' then
       -- bind alt + w as after world
      return true, {hs.eventtap.event.newKeyEvent({ "alt" }, "right", true)}
    end
  end

  local holdAltAndShift = not flags['ctrl'] and flags['shift'] and flags['alt']
  if holdAltAndShift then
    if char == "Ó" then
      -- bind alt + shift + h as start of line
      return true, {hs.eventtap.event.newKeyEvent({ "ctrl" }, "a", true)}
    elseif char == "Ò" then
      -- bind alt + shift + l as end of line
      return true, {hs.eventtap.event.newKeyEvent({ "ctrl" }, "e", true)}
    end
  end
end

viTapper = hs.eventtap.new({hs.eventtap.event.types.keyDown}, tapperCallback)
viTapper:start()
