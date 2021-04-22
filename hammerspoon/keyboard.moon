-- Arrow keys
hs.hotkey.bind({ 'alt' }, 'h', -> hs.eventtap.keyStroke({}, 'left'))
hs.hotkey.bind({ 'alt' }, 'j', -> hs.eventtap.keyStroke({}, 'down'))
hs.hotkey.bind({ 'alt' }, 'k', -> hs.eventtap.keyStroke({}, 'up'))
hs.hotkey.bind({ 'alt' }, 'l', -> hs.eventtap.keyStroke({}, 'right'))

hs.hotkey.bind({ 'cmd' }, 'escape', -> hs.eventtap.keyStroke({}, '`'))
hs.hotkey.bind({ 'shift' }, 'escape', -> hs.eventtap.keyStroke({ 'shift' }, '`'))
