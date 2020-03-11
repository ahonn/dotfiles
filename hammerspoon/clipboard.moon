conf = require 'conf'
utils = require 'utils'

path = conf.module.clipboard.path
width = conf.module.clipboard.width
limit = conf.module.clipboard.limit

hs.fs.mkdir(path)

db = hs.sqlite3.open("#{path}/db.sqlite3")
db\exec('CREATE TABLE clipboard(
  created_at NUMERIC PRIMARY KEY NOT NULL,
  app TEXT NOT NULL,
  uti_type TEXT NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL
);')

isTextUtiType = (uti_type) ->
  return uti_type == 'public.utf8-plain-text'

isImageUtiType = (uti_type) ->
  return uti_type == 'public.tiff' or uti_type == 'public.png'

clipboard = {
  save: =>
    contentTypes = hs.pasteboard.contentTypes!
    if conf.debug
      utils\logger(contentTypes)
    for uti_type in *contentTypes
      if isTextUtiType(uti_type)
        @saveText(uti_type)
      elseif isImageUtiType(uti_type)
        @saveImage(uti_type)

  saveText: (uti_type) =>
    appname = hs.window.focusedWindow!\application!\name!
    text = hs.pasteboard.readString!
    if text == nil or utf8.len(text) < 4
      return
    title = string.gsub(text, "[\r\n]+", " ")
    db\exec("DELETE FROM clipboard WHERE uti_type = '#{uti_type}' AND content = '#{text}';")
    db\exec("INSERT INTO clipboard VALUES(#{os.time!}, '#{appname}', '#{uti_type}', '#{title}', '#{text}')")

  saveImage: (uti_type, image) =>
    appname = hs.window.focusedWindow!\application!\name!
    image = hs.pasteboard.readImage!
    content = image\encodeAsURLString!
    db\exec("DELETE FROM clipboard WHERE uti_type = '#{uti_type}' AND content = '#{content}';")
    db\exec("INSERT INTO clipboard VALUES(#{os.time!}, '#{appname}', '#{uti_type}', '@IMAGE', '#{content}')")

  read: =>
    sql = "SELECT * FROM clipboard ORDER BY created_at DESC LIMIT #{limit}"
    choices = {}
    for created_at, appname, uti_type, title, content in db\urows(sql)
      item = {
        text: title
        uti_type: uti_type,
        subText: appname .. " / " .. os.date("%Y-%m-%d %H:%M", created_at)
        content: content
      }
      if isImageUtiType(uti_type)
        item.image = hs.image.imageFromURL(content)
      table.insert(choices, item)

  query: (query, chooser) =>
    sql = "SELECT * FROM clipboard WHERE title LIKE '%#{query}%' ORDER BY created_at DESC LIMIT #{limit}"
    choices = {}
    for created_at, appname, uti_type, title, content in db\urows(sql)
      item = {
        text: title
        uti_type: uti_type,
        subText: appname .. " / " .. os.date("%Y-%m-%d %H:%M", created_at)
        content: content
      }
      if isImageUtiType(uti_type)
        item.image = hs.image.imageFromURL(content)
      table.insert(choices, item)
    chooser\choices(choices)

  completion: (choice) =>
    if choice
      if isImageUtiType(choice.uti_type)
        image = hs.image.imageFromURL(choice.content)
        hs.pasteboard.writeObjects(image)
      elseif isTextUtiType(choice.uti_type)
        hs.pasteboard.setContents(choice.content)
      hs.eventtap.keyStroke({ 'cmd' }, 'v')

  show: =>
    chooser = hs.chooser.new((choice) -> @completion(choice))
    chooser\queryChangedCallback((query) -> @query(query, chooser))

    choices = @read!
    chooser\choices(choices)

    chooser\width(width)
    chooser\show!
}

preChangeCount = hs.pasteboard.changeCount!
watcher = hs.timer.new(0.5, ->
  changeCount = hs.pasteboard.changeCount!
  if changeCount != preChangeCount
    pcall(clipboard\save)
    preChangeCount = changeCount
)
watcher\start!

hs.hotkey.bind({ 'cmd', 'shift' }, 'v', clipboard\show)
