--[[    Play some audio
    (sound: sound File, vol: volume[0~1], pit: pitch[0~1], loop: should Loop[true,false])
]]
function audio_play(sound, vol, pit, loop, stop)
    if sound ~= nil then
        if stop then
            sound:stop()
        end
        sound:setVolume(vol)
        sound:setPitch(pit)
        sound:setLooping(loop)
        sound:play()
    end
end

--[[    Stop some audio
    (sound: sound File)
]]
function audio_stop(sound)
    if sound ~= nil then
        sound:stop()
    end
end

--[[    Update audio functions
    (sound: sound File, vol: volume[0~1], pit: pitch[0~1], loop: should Loop[true,false])
]]
function audio_update(sound, vol, pit, loop)
    if sound ~= nil then
        sound:setVolume(vol)
        sound:setPitch(pit)
        sound:setLooping(loop)
    end
end