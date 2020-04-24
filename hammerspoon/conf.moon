conf =
  debug: true
  module:
    reload:
      enable: true
    window:
      enable: true
      animationDuration: 0
    clipboard:
      enable: false
      path: os.getenv('HOME') .. '/.clipboard'
      width: 30
      limit: 50
conf
