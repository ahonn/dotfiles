-- Window Switcher

local choices = {}
local width = 30

local screenshot = nil
local content = nil
local timer = hs.timer.new(0.1, function ()
  local selectedContent = switcher:selectedRowContents()

  if content == nil or content.wid ~= selectedContent.wid then
    if screenshot ~= nil then
      screenshot:hide()
    end
    print('drawing')

    local switcherFrame = hs.window.focusedWindow():frame()

    local snapshot = hs.window.snapshotForID(selectedContent.wid)
    local w = 300;
    local h = 300;
    local x = switcherFrame.x + switcherFrame.w + 5
    local y = switcherFrame.y - 60
    screenshot = hs.drawing.image({x = x, y = y, w = w, h = 300}, snapshot)
    screenshot:setBehavior(hs.drawing.windowBehaviors.moveToActiveSpace)
    screenshot:show()
    content = selectedContent
  end
end)

switcher = hs.chooser.new(function (choice)
  if choice ~= nil then
    local app = hs.application.applicationForPID(choice.pid)
    local wins = app:allWindows()

    app:activate()
    if #wins > 1 then
      local win = app:getWindow(choice.wid)
      win:focus()
    end
  end
  -- clear switcher query string
  if switcher:query() ~= "" then
    switcher:query("")
  end

  screenshot:hide()
  timer:stop()
end)

switcher:queryChangedCallback(function (query)
  local result = hs.fnutils.filter(choices, function (item)
    function isMatch(text)
      return string.match(string.lower(text), string.lower(query))
    end
    return isMatch(item.text) or isMatch(item.subText)
  end)
  switcher:choices(result)
end)

function showSwitcher()
  local windows = hs.window.filter.new(true):getWindows()
  choices = hs.fnutils.map(windows, function (window)
    local app = window:application()

    if window:title() ~= "" then
      return {
        wid = window:id(),
        pid = app:pid(),
        text = window:title(),
        subText = app:name(),
        image = hs.image.imageFromAppBundle(app:bundleID())
      }
    end
  end)

  switcher:width(width)
  switcher:choices(choices)
  switcher:show()
  timer:start()
end

switchBind = hs.hotkey.bind({ "alt" }, "tab", showSwitcher)

