--[[    Load all resources needed to play the intro and the loading screen
]]
function startup_load()
    vfx_intro = love.graphics.newVideo("gui/intro.ogv")

    vfx_intro:play()

    font_size = {s3 = screen.hei/20}
    font_type = {edosz3 = love.graphics.newFont("gui/edosz.ttf", font_size.s3)}

    require "src/language"

    --settings table
    settings = {
        --audio
        volMaster = 1, volMusic = 1, volGame = 1,
        --general
        language = 1, 
        --gameplay
        roundTime = 90, roundsToWin = 2, backAsStart = false
    }
    if love.filesystem.exists("settings.kpf") then
        file_loadSettings()
    else
        file_saveSettings()
    end

    if lang_list[settings.language] ~= nil then
        lang = lang_list[settings.language]
    else
        settings.language = 1
        lang = lang_list[settings.language]
    end
end

--[[    Update the variables that controls the intro execution
]]
function startup_update(dt)
    if not vfx_intro:isPlaying() then
        loading = true
        screen_setState(0.5)
    else
        loading = false
    end
end

--[[    Handle when some key has released
    (key: key code)
]]
function startup_keyreleased(key)
    if key == "return" or key == "escape" or key == "space" then
        vfx_intro:pause()
    end
end

--[[    Handle when some gamepad button has released
    (gamepad: gamepad object, key: button code)
]]
function startup_gamepadreleased(gamepad, key)
    if key == "a" or key == "start" then
        vfx_intro:pause()
    end
end

--[[    Draw the video intro and calls the loading screen
]]
function startup_draw()
    love.graphics.draw(vfx_intro, 0, 0, _, scale.wid, scale.hei)
    if loading then
        startup_draw_loading()
    end
end

--[[    Draw the loading screen
]]
function startup_draw_loading()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font_type.edosz3)
    love.graphics.printf(lang.s0_loading, 0, screen.hei*0.9, screen.wid, "center")
end

--[[    Change the state of the screen controller
]]
function screen_setState (newState)
    screen.state = newState
    chrono.reset = true
end

--[[    Save the settings to a file
]]
function file_saveSettings()
    love.filesystem.write("settings.kpf", bitser.dumps(settings))
end

--[[    Load the settings from a file
]]
function file_loadSettings()
    settings = bitser.loads(love.filesystem.read("settings.kpf"))
end