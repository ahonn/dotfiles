conf = require 'conf'
utils = require 'utils'

tiddlywiki = conf.watcher.tiddlywiki

if tiddlywiki.enable
  target_dir = tiddlywiki.target\match("(.*[/\\])")
  if hs.fs.dir(target_dir) != nil
    hs.pathwatcher.new(tiddlywiki.source, (paths) ->
      hs.fs.link(tiddlywiki.source, tiddlywiki.target)
    )\start!
