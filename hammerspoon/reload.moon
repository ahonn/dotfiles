_ = require 'lodash'
utils = require 'utils'

hs.pathwatcher.new(hs.configdir, (files) ->
  _.some files, (v) ->
    if v\sub(-5) == '.moon'
      utils\notify 'Hammerspoon', 'Config Reload Success'
      hs.reload!
      return true
)\start!
