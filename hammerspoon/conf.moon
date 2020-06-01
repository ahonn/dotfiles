HOME = os.getenv('HOME')

conf =
  debug: true
  watcher:
    tiddlywiki:
      enable: true
      source: HOME .. '/Library/Mobile Documents/com~apple~CloudDocs/TiddlyWiki/index.html'
      target: HOME .. '/Desktop/TiddlyWiki/index.html'
  module:
    reload:
      enable: true
    window:
      enable: true
      animationDuration: 0
    clipboard:
      enable: false
      path: HOME .. '/.clipboard'
      width: 30
      limit: 50
conf
