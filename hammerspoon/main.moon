conf = require 'conf'
_ = require 'lodash'

_.forEach conf.module, (config, name) ->
  require name if config.enable
