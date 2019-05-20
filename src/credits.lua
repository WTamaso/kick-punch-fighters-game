--[[    Load all resources needed to play the credits video
]]
function credits_load()
    vfx_credits = love.graphics.newVideo("gui/credits.ogv")
    played = false

    --credits variables
    input = {back = false}
end

--[[    Update the variables that controls the credits video and calls back the menu
    (dt: delta-time from "love.update(dt)")
]]
function credits_update(dt)
    if not vfx_credits:isPlaying() and not played then
        vfx_credits:play()
        played = true
    end
    if not vfx_credits:isPlaying() and played then
        screen_setState(1)
    end

    if input.back then
        input.back = false
        vfx_credits:pause()
        screen_setState(1)
    end
end

--[[    Handle when some key has released
    (key: key code)
]]
function credits_keyreleased(key)
    if key == "escape" or key == "backspace" then
        input.back = true
    end
end

--[[    Handle when some gamepad button has released
    (gamepad: gamepad object, key: button code)
]]
function credits_gamepadreleased(gamepad, key)
    if key == "back" or key == "b" then
        input.back = true
    end
end

--[[    Draw the video credits
]]
function credits_draw()
    love.graphics.draw(vfx_credits, 0, 0, _, scale.wid, scale.hei)
end