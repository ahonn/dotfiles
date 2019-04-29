-- Clipboard History

local module = {}

-- metadata
module.name = "Clipboard"
module.version = "1.0.0"
module.author = "Yuexun Jiang <yuexunjiang@gmail.com>"
module.license = "MIT - https://opensource.org/licenses/MIT"

-- settings
local width = 30
local maxSize = 100

local storePath = os.getenv("HOME") .. "/.clipboard"
local cachePath = storePath .. "/cache.json"
local imagePath = storePath .. "/images"

local UTI_TYPE = {
  IMAGE_TIFF = "public.tiff",
  IMAGE_PNG = "public.png",
  PLAIN_TEXT = "public.utf8-plain-text",
}

local HISTORY_TYPE = {
  IMAGE = "IMAGE",
  TEXT = "TEXT",
}

function readHistoryFromCache()
  hs.fs.mkdir(storePath)
  local cacheFile = io.open(cachePath, "r")
  if cacheFile then
    local content = cacheFile:read("*a")
    if content ~= "" then
      return hs.json.decode(content)
    end
  end

  return {}
end

function saveHistoryIntoCache(history)
  local cacheFile = io.open(cachePath, "w")
  cacheFile:write(hs.json.encode(history))
  cacheFile:close()
end

function saveTemporaryImage(image)
  hs.fs.mkdir(imagePath)
  local imageBase64 = hs.base64.encode(image:encodeAsURLString())
  local startIndex = string.len(imageBase64) / 2
  local endIndex = startIndex + 20;
  local filename = imagePath .. "/" .. string.sub(imageBase64, startIndex, endIndex) .. ".png"
  image:saveToFile(filename)
  return filename
end

function reduceHistorySize()
  while #module.history >= maxSize do
    table.remove(history, #module.history)
  end
end

function addHistoryFromPasteboard()
  local contentTypes = hs.pasteboard.contentTypes()

  local item = {}
  for index, uti in ipairs(contentTypes) do
    if uti == UTI_TYPE.IMAGE_TIFF or uti == UTI_TYPE.IMAGE_PNG then
      local image = hs.pasteboard.readImage()
      item.text = "_IMAGE_"
      item.type = HISTORY_TYPE.IMAGE
      item.content = saveTemporaryImage(image)
      break
    elseif uti == UTI_TYPE.PLAIN_TEXT then
      local text = hs.pasteboard.readString()
      if text == nil or utf8.len(text) < 3 then
        return
      end

      item.text = string.gsub(text, "[\r\n]+", " ")
      item.type = HISTORY_TYPE.TEXT;
      item.content = text;
      break
    end
  end

  for index, el in ipairs(module.history) do
    if item.content == el.content then
      table.remove(module.history, index)
    end
  end

  local appname = hs.window.focusedWindow():application():name()
  item.subText = appname .. " / " .. os.date("%Y-%m-%d %H:%M", os.time())

  table.insert(module.history, 1, item)
  saveHistoryIntoCache(module.history)
end

function showClipboard()
  local choices = hs.fnutils.map(module.history, function(item)
    local choice = hs.fnutils.copy(item)
    choice.text = " " .. choice.text
    choice.subText = " " .. choice.subText
    if choice.type == HISTORY_TYPE.IMAGE then
      choice.image = hs.image.imageFromPath(item.content)
    end
    return choice
  end)

  module.chooser:width(width);
  module.chooser:choices(choices);
  module.chooser:show()
end

function choiceClipboard(choice)
  if choice then
    if choice.type == HISTORY_TYPE.IMAGE then
      local image = hs.image.imageFromPath(choice.content)
      hs.pasteboard.writeObjects(image)
    else
      hs.pasteboard.setContents(choice.content)
    end
    hs.eventtap.keyStroke({ "cmd" }, "v")
  end
  if module.chooser:query() ~= "" then
    module.chooser:query("")
  end
end

function module:start()
  module.history = readHistoryFromCache()
  module.chooser = hs.chooser.new(choiceClipboard)
  module.preChangeCount = hs.pasteboard.changeCount()
  module.watcher = hs.timer.new(0.5, function()
    local changeCount = hs.pasteboard.changeCount()
    if changeCount ~= module.preChangeCount then
      addHistoryFromPasteboard()
      module.preChangeCount = changeCount
    end
  end)
  module.watcher:start()
end

function module:stop()
  module.watcher:stop()
end

function module:bindHotkeys(mapping)
  local def = {
    showClipboard = showClipboard
  }
  hs.spoons.bindHotkeysToSpec(def, mapping)
  module.mapping = mapping
end

return module
