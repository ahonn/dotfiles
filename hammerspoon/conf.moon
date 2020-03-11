conf =
  debug: true
  module:
    reload:
      enable: true
    clipboard:
      enable: true
      path: os.getenv('HOME') .. '/.clipboard'
      width: 30
      limit: 50
conf
