-- Clipboard History

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
  local endIndex = startIndex + 5;
  local filename = imagePath .. "/" .. string.sub(imageBase64, startIndex, endIndex) .. ".png"
  image:saveToFile(filename)
  return filename
end

function reduceHistorySize()
  while #history >= maxSize do
    table.remove(history, #history)
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

  if item.text then
    for index, el in ipairs(history) do
      if item.content == el.content then
        table.remove(history, index)
      end
    end

    local appname = hs.window.focusedWindow():application():name()
    item.subText = appname .. " / " .. os.date("%Y-%m-%d %H:%M", os.time())

    table.insert(history, 1, item)
    saveHistoryIntoCache(history)
  end
end

function showClipboard()
  local choices = hs.fnutils.map(history, function(item)
    local choice = hs.fnutils.copy(item)
    choice.text = " " .. choice.text
    choice.subText = " " .. choice.subText
    if choice.type == HISTORY_TYPE.IMAGE then
      choice.image = hs.image.imageFromPath(item.content)
    end
    return choice
  end)

  chooser:width(width);
  chooser:choices(choices);
  chooser:show()
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
  if chooser:query() ~= "" then
    chooser:query("")
  end
end

history = readHistoryFromCache()
chooser = hs.chooser.new(choiceClipboard)
preChangeCount = hs.pasteboard.changeCount()
watcher = hs.timer.new(0.5, function()
  local changeCount = hs.pasteboard.changeCount()
  if changeCount ~= preChangeCount then
    addHistoryFromPasteboard()
    preChangeCount = changeCount
  end
end)
watcher:start()

hs.hotkey.bind({ "cmd", "shift" }, "v", showClipboard)

