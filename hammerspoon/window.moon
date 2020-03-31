conf = require 'conf'
utils = require 'utils'

hs.window.animationDuration = conf.module.window.animationDuration

class Window
  new: =>
    @frameCache = {}

  saveSnapshot: (cwin) =>
    unless @frameCache[cwin\id!]
      @frameCache[cwin\id!] = { cwin\frame! }
    else
      lastFrame = table.remove(@frameCache[cwin\id!])
      if lastFrame != cwin\frame!
        table.insert(@frameCache[cwin\id!], lastFrame)
      table.insert(@frameCache[cwin\id!], cwin\frame!)

  left: (cwin) =>
    cwin\move(hs.layout.left50)

  right: (cwin) =>
    cwin\move(hs.layout.right50)

  top: (cwin) =>
    cwin\move('[0, 0, 100, 50]')

  bottom: (cwin) =>
    cwin\move('[0, 50, 100, 100]')

  center: (cwin) =>
    cwin\move('[25, 25, 75, 75]')

  resize: (cmd) =>
    cwin = hs.window.focusedWindow!
    if cwin
      unless cwin\isFullScreen!
        @saveSnapshot(cwin)
        utils\inspect self
        switch cmd
          when 'left' then @left(cwin)
          when 'bottom' then @bottom(cwin)
          when 'top' then @top(cwin)
          when 'right' then @right(cwin)
          when 'center' then @center(cwin)
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

  screen: (cmd) =>
    cwin = hs.window.focusedWindow!
    @saveSnapshot(cwin)
    if cmd == 'previous' then
      cwin\moveToScreen(cwin\screen!\previous!, true, true)\maximize!
    else
      cwin\moveToScreen(cwin\screen!\next!, true, true)\maximize!

  undo: =>
    cwin = hs.window.focusedWindow!
    if @frameCache[cwin\id!]
      frame = table.remove(@frameCache[cwin\id!])
      if frame == cwin\frame!
        @undo!
      else
        cwin\setFrame(frame)

export window = Window!

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'h', -> window\resize('left'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'j', -> window\resize('bottom'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'k', -> window\resize('top'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'l', -> window\resize('right'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'c', -> window\resize('center'))

hs.hotkey.bind({ 'ctrl', 'cmd' }, '.', -> window\screen('next'))
hs.hotkey.bind({ 'ctrl', 'cmd' }, ',', -> window\screen('previous'))

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'm', -> window\maximize!)
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'f', -> window\fullScreen!)

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'u', -> window\undo!)
