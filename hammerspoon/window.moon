conf = require 'conf'
utils = require 'utils'

hs.window.animationDuration = conf.module.window.animationDuration

window =
  frameCache: {}

  saveSnapshot: (cwin) => {
    unless @frameCache[cwin\id!]
      @frameCache[cwin\id!] = { cwin\frame! }
    else
      lastFrame = table.remove(@frameCache[cwin\id!])
      if lastFrame != cwin\frame!
        table.insert(@frameCache[cwin\id!], lastFrame)
      table.insert(@frameCache[cwin\id!], cwin\frame!)
  }

  moveLeft: (cwin) =>
    screenFrame = cwin\screen!\frame!
    newFrame = hs.geometry.rect(0, 0, screenFrame.w / 2, screenFrame.h)
    cwin\setFrame(newFrame)

  moveRight: (cwin) =>
    screenFrame = cwin\screen!\frame!
    newFrame = hs.geometry.rect(screenFrame.w / 2, 0, screenFrame.w / 2, screenFrame.h)
    cwin\setFrame(newFrame)

  moveTop: (cwin) =>
    screenFrame = cwin\screen!\frame!
    newFrame = hs.geometry.rect(0, 0, screenFrame.w, screenFrame.h / 2)
    cwin\setFrame(newFrame)

  moveTop: (cwin) =>
    screenFrame = cwin\screen!\frame!
    newFrame = hs.geometry.rect(0, 0, screenFrame.w, screenFrame.h / 2)
    cwin\setFrame(newFrame)

  moveBottom: (cwin) =>
    screenFrame = cwin\screen!\frame!
    newFrame = hs.geometry.rect(0, screenFrame.h / 2, screenFrame.w, screenFrame.h / 2)
    cwin\setFrame(newFrame)

  moveCenter: (cwin) =>
    windowFrame = cwin\frame!
    screenFrame = cwin\screen!\frame!
    newFrame = hs.geometry.rect(
      (screenFrame.w - windowFrame.w) / 2,
      (screenFrame.h - windowFrame.h) / 2,
      windowFrame.w,
      windowFrame.h
    )
    cwin\setFrame(newFrame)

  resize: (cmd) =>
    cwin = hs.window.focusedWindow!
    if cwin
      unless cwin\isFullScreen!
        @saveSnapshot(cwin)
        switch cmd
          when 'Left' then @moveLeft(cwin)
          when 'Bottom' then @moveBottom(cwin)
          when 'Top' then @moveTop(cwin)
          when 'Right' then @moveRight(cwin)
          when 'Center' then @moveCenter(cwin)
    else
      utils\alert('No Focused Window!')

  maximize: =>
    cwin = hs.window.focusedWindow!
    if cwin
      unless cwin\isFullScreen!
        @saveSnapshot(cwin)
        cwin\maximize!
    else
      utils\alert('No Focused Window!')

  fullScreen: =>
    cwin = hs.window.focusedWindow!
    if cwin
      cwin\toggleFullScreen!
    else
      utils\alert('No Focused Window!')

  undo: =>
    cwin = hs.window.focusedWindow!
    if @frameCache[cwin\id!]
      frame = table.remove(@frameCache[cwin\id!])
      if frame == cwin\frame!
        @undo!
      else
        cwin\setFrame(frame)
window

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'h', -> window\resize('Left'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'j', -> window\resize('Bottom'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'k', -> window\resize('Top'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'l', -> window\resize('Right'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'c', -> window\resize('Center'))

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'm', -> window\maximize!)
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'f', -> window\fullScreen!)

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'u', -> window\undo!)
