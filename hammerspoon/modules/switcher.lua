-- Window Switcher

local choices = {}
local width = 30

local screenshot = nil
local preChoice = nil
local timer = hs.timer.new(0.1, function ()
  local currentChoice = switcher:selectedRowContents()

  if preChoice == nil or preChoice.wid ~= currentChoice.wid then
    if screenshot ~= nil then
      screenshot:hide()
    end

    local app = hs.application.applicationForPID(currentChoice.pid)
    local window = app:getWindow(currentChoice.wid) or app:mainWindow()
    local windowFrame = window:frame()

    local switcherFrame = hs.window.focusedWindow():frame()

    local snapshot = hs.window.snapshotForID(currentChoice.wid)
    local w = switcherFrame.w
    local h = w * (windowFrame.h / windowFrame.w)
    local x = switcherFrame.x + switcherFrame.w + 5
    local y = switcherFrame.y
    screenshot = hs.drawing.image({x = x, y = y, w = w, h = h}, snapshot)
    screenshot:setBehavior(hs.drawing.windowBehaviors.moveToActiveSpace)
    screenshot:show()
    preChoice = currentChoice
  end
end)

switcher = hs.chooser.new(function (choice)
  if choice ~= nil then
    local app = hs.application.applicationForPID(choice.pid)
    local windows = app:allWindows()

    print(hs.inspect.inspect(app))
    app:activate()
    if #windows > 0 then
      local window = app:getWindow(choice.wid)
      print(hs.inspect.inspect(window))
      print(window:isMinimized())
      if window:isMinimized() then
        window:unminimize()
      end
      window:focus()
    end
  end
  -- clear switcher query string
  if switcher:query() ~= "" then
    switcher:query("")
  end

  screenshot:hide()
  timer:stop()
  preChoice = nil
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

