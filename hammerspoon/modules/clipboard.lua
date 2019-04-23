-- Clipboard

local history = {}
local maxSize = 100
local cachePath = os.getenv("HOME") .. "/.clipboard"

-- load clipboard cache if exists
local cache = io.open(cachePath, "r")
if cache then
  history = hs.json.decode(cache:read("*a"))
end

clipboard = hs.chooser.new(function (choice)
  -- paste if choice text
  if choice then
    hs.pasteboard.setContents(choice.raw)
    hs.eventtap.keyStroke({ "cmd" }, "v")
  end
  -- clear clipboard query string
  if clipboard:query() ~= "" then
    clipboard:query("")
  end
end)

function addHistory(content)
  -- limit history length
  while (#history >= maxSize) do
    table.remove(history, #history)
  end

  if #history < 1 or history[1].text ~= content then
    local text = string.gsub(content, "[\r\n]+", " ")

    local appname = hs.window.focusedWindow():application():name()
    local subText = appname .. " / " .. os.date("%Y-%m-%d %H:%M", os.time())

    table.insert(history, 1, {text = text, subText = subText, raw = content})

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
    local content = hs.pasteboard.getContents()
    addHistory(content)
    keybinds.copy:enable()
  end)
end

function showClipboard()
  clipboard:width(30);
  clipboard:choices(history);
  clipboard:show()
end

----------------------- pasteboard watch ---------------------------

preCount = hs.pasteboard.changeCount()
hs.timer.doEvery(0.5, function()
  local count = hs.pasteboard.changeCount()

  if (count ~= preCount) then
    preCount = count;
    local content = hs.pasteboard.getContents()
    addHistory(content)
  end
end)

----------------------- hotkey bindings ----------------------------

keybinds = {}
-- binding shift + cmd + v as show clipboard
keybinds.paste = hs.hotkey.bind({ "shift", "cmd" }, "v", showClipboard);
-- hook cmd + c to add clipboard hostory
keybinds.copy = hs.hotkey.bind({ "cmd" }, "c", copy2Clipboard)

