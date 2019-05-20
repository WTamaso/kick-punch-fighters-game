require "src/startup"
bitser = require 'bitser'

screen = {state = 0}
lagDt = 0

function love.load()

    local _, _, flags = love.window.getMode()
    screen.wid, screen.hei = love.window.getDesktopDimensions(flags.display)
    scale = {wid = screen.wid/1920, hei = screen.hei/1080}
    love.mouse.setVisible(false)

    chrono = {start = love.timer.getTime(), actual, passed, reset = false}

    local joysticks = love.joystick.getJoysticks()
    controller = {p1 = joysticks[1], p2 = joysticks[2]}

    startup_load()
end

function love.update(dt)
    if dt > 1 then
        dt = 0 
    end
    chrono.actual = love.timer.getTime()
    chrono.passed = chrono.actual - chrono.start
    if screen.state == 0 then --intro video
        startup_update(dt)
    elseif screen.state == 0.5 then --loading game resources
        --require section
        require "src/audio"
        require "src/menu"
        require "src/contsel"
        require "src/options"
        require "src/credits"
        require "src/charsel"
        require "src/arenasel"
        require "src/game"

        --calling load functions
        menu_load()
        options_load()

        --starting variables
        screen_setState(1)
    elseif screen.state == 1 then --main menu
        menu_update(dt)
    elseif screen.state == 2 then --credits
        credits_update(dt)
    elseif screen.state == 3 then --options
        options_update(dt)
    elseif screen.state == 4 then --controller selection
        contsel_update(dt)
    elseif screen.state == 5 then --character selection
        charsel_update(dt)
    elseif screen.state == 6 then --arena selection
        arenasel_update(dt)
    elseif screen.state == 6.5 then --game loading
        gameloading_update(dt)
    elseif screen.state == 7 then --game
        game_update(dt)
    end
    
end

function love.keypressed(key)
    if screen.state == 7 then --game
        game_keypressed(key)
    end
end

function love.keyreleased(key)
    if screen.state == 0 then --main menu
        startup_keyreleased(key)
    elseif screen.state == 1 then --main menu
        menu_keyreleased(key)
    elseif screen.state == 2 then --credits
        credits_keyreleased(key)
    elseif screen.state == 3 then --options
        options_keyreleased(key)
    elseif screen.state == 4 then --controller selection
        contsel_keyreleased(key)
    elseif screen.state == 5 then --character selection
        charsel_keyreleased(key)
    elseif screen.state == 6 then --arena selection
        arenasel_keyreleased(key)
    elseif screen.state == 7 then --game
        game_keyreleased(key)
    end
end

function love.gamepadpressed(gamepad, key)
    if screen.state == 7 then --game
        game_gamepadpressed(gamepad, key)
    end
end

function love.gamepadreleased(gamepad, key)
    if screen.state == 0 then --main menu
        startup_gamepadreleased(gamepad, key)
    elseif screen.state == 1 then --main menu
        menu_gamepadreleased(gamepad, key)
    elseif screen.state == 2 then --credits
        credits_gamepadreleased(gamepad, key)
    elseif screen.state == 3 then --options
        options_gamepadreleased(gamepad, key)
    elseif screen.state == 4 then --controller selection
        contsel_gamepadreleased(gamepad, key)
    elseif screen.state == 5 then --character selection
        charsel_gamepadreleased(gamepad, key)
    elseif screen.state == 6 then --arena selection
        arenasel_gamepadreleased(gamepad, key)
    elseif screen.state == 7 then --game
        game_gamepadreleased(gamepad, key)
    end
end

function love.draw()

    if screen.state == 0 then --intro video
        startup_draw()
    elseif screen.state == 0.5 then --loading game resources
        startup_draw_loading()
    elseif screen.state == 1 then --main menu
        menu_draw()
    elseif screen.state == 2 then --credits
        credits_draw()
    elseif screen.state == 3 then --options
        options_draw()
    elseif screen.state == 4 then --controller selection
        contsel_draw()
    elseif screen.state == 5 then --character selection
        charsel_draw()
    elseif screen.state == 6 then --arena selection
        arenasel_draw()
    elseif screen.state == 6.5 then --game loading
        gameloading_draw()
    elseif screen.state == 7 then --game
        game_draw()
    end
end

function love.focus(f)
    if screen.state == 7 then
        game_focus(f)
    end
end