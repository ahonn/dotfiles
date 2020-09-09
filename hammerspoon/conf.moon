HOME = os.getenv('HOME')

conf =
  debug: true
  module:
    reload:
      enable: true
    window:
      enable: true
      animationDuration: 0
    clipboard:
      enable: true
      path: HOME .. '/.clipboard'
      width: 30
      limit: 50
    keyboard:
      enable: true
conf
