conf = require 'conf'
_ = require 'lodash'

require 'watcher'

_.forEach conf.module, (config, name) ->
  require name if config.enable
