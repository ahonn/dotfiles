conf = require 'conf'
utils = require 'utils'

tiddlywiki = conf.watcher.tiddlywiki

watcher =
  syncTiddlyWiki: =>
    utils\notify 'Tiddly Wiki', 'Upload To Dropbox'
    os.remove(tiddlywiki.target)
    hs.fs.link(tiddlywiki.source, tiddlywiki.target)
watcher

if tiddlywiki.enable
  target_dir = tiddlywiki.target\match("(.*[/\\])")
  if hs.fs.dir(target_dir) != nil
    hs.pathwatcher.new(tiddlywiki.source, ->
      watcher\syncTiddlyWiki!
    )\start!
    hs.hotkey.bind({ 'ctrl', 'shift' }, 'w', watcher\syncTiddlyWiki)

