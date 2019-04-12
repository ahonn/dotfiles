local audiodevice = require "hs.audiodevice"
local application = require "hs.application"
local itunes = require "hs.itunes"

local builtInOutput = audiodevice.findDeviceByName('Built-in Output')

function headphoneWatcherCallback(uid, event, scope)
  if event == 'jack' then
    if builtInOutput:jackConnected() then
      builtInOutput:setDefaultOutputDevice()
      if itunes.isRunning() then
        itunes.play()
      end
    else
      if itunes.isPlaying() then
        itunes.pause()
      end
    end
  end
end

if not builtInOutput:watcherIsRunning() then
  builtInOutput:watcherCallback(headphoneWatcherCallback)
  builtInOutput:watcherStart()
end
