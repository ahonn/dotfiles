-- Clipboard History

local history = {}
local width = 30
local maxSize = 100
local cachePath = os.getenv("HOME") .. "/.clipboard"

local UTI = {
  IMAGE = "public.tiff",
  TEXT = "public.utf8-plain-text",
}

-- load clipboard cache if exists
local cache = io.open(cachePath, "r")
if cache then
  local str = cache:read("*a")
  if str ~= "" then
    history = hs.json.decode(str)
  end
end

clipboard = hs.chooser.new(function (choice)
  -- paste if choice text
  if choice then
    if choice.uti == UTI.IMAGE then
      local image = hs.image.imageFromURL(choice.raw)
      hs.pasteboard.writeObjects(image)
    else
      hs.pasteboard.setContents(choice.raw)
    end
    hs.eventtap.keyStroke({ "cmd" }, "v")
  end
  -- clear clipboard query string
  if clipboard:query() ~= "" then
    clipboard:query("")
  end
end)

function addClipboardHistory()
  -- local content = hs.pasteboard.getContents()
  local contentTypes = hs.pasteboard.contentTypes()

  local imageType = false;
  for index, uti in ipairs(contentTypes) do
    if uti == UTI.IMAGE then
      imageType = true
    end
  end

  local item = {}
  if imageType then
    local image = hs.pasteboard.readImage()
    item.text = "[[Image]]";
    item.uti = UTI.IMAGE;
    item.raw = image:encodeAsURLString("TIFF")
  else
    local text = hs.pasteboard.readString()
    if text == nil or utf8.len(text) < 3 then
      return
    end

    item.text = string.gsub(text, "[\r\n]+", " ")
    item.uti = UTI.TEXT;
    item.raw = text;
  end

  -- limit history length
  while (#history >= maxSize) do
    table.remove(history, #history)
  end

  if #history < 1 or history[1].raw ~= item.raw then
    local appname = hs.window.focusedWindow():application():name()
    item.subText = appname .. " / " .. os.date("%Y-%m-%d %H:%M", os.time())

    table.insert(history, 1, item)

    -- save to clipboard cache (will load when restart)
    local cache = io.open(cachePath, "w")
    cache:write(hs.json.encode(history))
    cache:close()
  end
end

function copy2Clipboard()
  keybinds.copy:disable()
  hs.eventtap.keyStroke({ "cmd" }, "c")

  -- add copy content into clipboard history
  hs.timer.doAfter(0.1, function()
    addClipboardHistory()
    keybinds.copy:enable()
  end)
end

function showClipboard()
  local choices = hs.fnutils.map(history, function(item)
    local choice = hs.fnutils.copy(item)
    choice.text = " " .. choice.text
    choice.subText = " " .. choice.subText
    if choice.uti == UTI.IMAGE then
      choice.image = hs.image.imageFromURL(item.raw)
    end
    return choice
  end)

  clipboard:width(width);
  clipboard:choices(choices);
  clipboard:show()
end

----------------------- pasteboard watch ---------------------------

preCount = hs.pasteboard.changeCount()
hs.timer.doEvery(0.5, function()
  local count = hs.pasteboard.changeCount()

  if (count ~= preCount) then
    preCount = count;
    addClipboardHistory()
  end
end)

----------------------- hotkey bindings ----------------------------

keybinds = {}
-- binding shift + cmd + v as show clipboard
keybinds.paste = hs.hotkey.bind({ "shift", "cmd" }, "v", showClipboard);
-- hook cmd + c to add clipboard hostory
keybinds.copy = hs.hotkey.bind({ "cmd" }, "c", copy2Clipboard)

