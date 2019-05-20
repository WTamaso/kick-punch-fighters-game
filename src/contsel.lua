--[[    Load all the resources needed to pre-Game screens
    (num_players: the quantity of players who will play)
]]
function contsel_load()
    --contsel variables
    input = {abort = false}
    kb_keys = {id = "keyboard", ok = false, back = false}
    ct_butt = {id, ok = false, back = false}
    contsel_confirmation = false


    --gui variables
    gui_controller = love.graphics.newImage("gui/controller/controller.png")
    gui_keyboard = love.graphics.newImage("gui/keyboard/keyboard.png")

end

--[[    Update the pre-Game screens variables
    (dt: delta-time from "love.update(dt)")
]]
function contsel_update(dt)
    --logo animation
    logo.anim = logo.anim + (dt/50 * logo.mod)
    logo.bgi = logo.bgi + (dt/50 * -logo.mod)
    if logo.anim > 1.02 then
        logo.mod = -1
    elseif logo.anim < 0.98 then
        logo.mod = 1
    end

    --background audio
    if not sfx_bgm:isPlaying() then
        audio_play(sfx_bgm, bgm.vol, bgm.pit, bgm.loop, true)
    end

    if game.playerCount == 1 then
        if player[1].controller ~= nil then
            contsel_confirmation = true 
        else
            contsel_confirmation = false
        end
    elseif game.playerCount == 2 then
        if player[1].controller ~= nil and player[2].controller ~= nil and player[1].controller ~= player[2].controller then
            contsel_confirmation = true 
        else
            contsel_confirmation = false
        end
    end

    if game.playerCount == 1 then
        if kb_keys.ok then
            kb_keys.ok = false
            if player[1].controller == nil then
                player[1].controller = kb_keys.id
                audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            end
            if contsel_confirmation then
                charsel_load()
                screen_setState(5)
            end
        elseif ct_butt.ok then
            ct_butt.ok = false
            if player[1].controller == nil then
                player[1].controller = ct_butt.id
                audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            end
            if contsel_confirmation then
                charsel_load()
                screen_setState(5)
            end
        end
        if kb_keys.back or ct_butt.back then
            kb_keys.back = false
            ct_butt.back = false
            if player[1].controller ~= nil then
                player[1].controller = nil
                audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            else
                input.abort = true
            end
        end
    elseif game.playerCount == 2 then
        if kb_keys.ok then
            kb_keys.ok = false
            if player[1].controller == nil then
                player[1].controller = kb_keys.id
                audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            elseif player[1].controller ~= nil and player[2].controller == nil and player[1].controller ~= "keyboard" then
                player[2].controller = kb_keys.id
                audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            end
            if contsel_confirmation then
                charsel_load()
                screen_setState(5)
            end
        else
            if ct_butt.ok then
                ct_butt.ok = false
                if player[1].controller == nil then
                    player[1].controller = ct_butt.id
                    audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
                elseif player[1].controller ~= nil and player[2].controller == nil and player[1].controller ~= ct_butt.id then
                    player[2].controller = ct_butt.id
                    audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
                end
                if contsel_confirmation then
                    charsel_load()
                    screen_setState(5)
                end
            end
            if kb_keys.back or ct_butt.back then
                kb_keys.back = false
                ct_butt.back = false
                if player[1].controller ~= nil and player[2].controller ~= nil then
                    player[2].controller = nil
                    audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
                elseif player[1].controller ~= nil and player[2].controller == nil then
                    player[1].controller = nil
                    audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
                else
                    input.abort = true
                end
            end
        end
    end

    if input.abort then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        screen_setState(1)
        player[2].controller = nil
        player[1].controller = nil
        input.abort = false
    end
end

--[[    Handle when some key has released
    (key: key code)
]]
function contsel_keyreleased(key)
    if key == "escape" then
        input.abort = true
    end
    if key == "return" then
        kb_keys.ok = true
    end
    if key == "backspace" then
        kb_keys.back = true
    end
end

--[[    Handle when some gamepad button has released
(gamepad: gamepad object, key: button code)
]]
function contsel_gamepadreleased(gamepad, key)
    if key == "back" then
        input.abort = true
    end
    if key == "a" or key == "start" then
        ct_butt.ok = true
        ct_butt.id = gamepad
    end
    if key == "b" then
        ct_butt.back = true
    end
end

--[[    Draw the pre-Game screens in the screen
]]
function contsel_draw()

    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_background, screen.wid / 2, screen.hei / 2, _, scale.wid * logo.bgi * 1.1, scale.hei * logo.bgi * 1.1, gui_background:getWidth() / 2, gui_background:getHeight() / 2)

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.1), (screen.wid * 0.8), (screen. hei * 0.085))
    love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.7), (screen.wid * 0.8), (screen. hei * 0.085))
    if game.playerCount == 1 then
        love.graphics.rectangle("fill", (screen.wid * 0.35), (screen.hei * 0.25), (screen.wid * 0.3), (screen. hei * 0.4))
        love.graphics.setColor(255,255,255)
        love.graphics.setFont(font_type.edosz3)
        love.graphics.printf("- "..lang.s4_player1.." -", screen.wid * 0.35, screen.hei * 0.25, screen.wid * 0.3, "center")
        if player[1].controller ~= nil and player[1].controller ~= "keyboard" then
            love.graphics.draw(gui_controller, screen.wid / 2, screen.hei / 2, _, scale.wid, scale.hei, gui_controller:getWidth() / 2, gui_controller: getHeight() / 2)
        elseif player[1].controller == "keyboard" then
            love.graphics.draw(gui_keyboard, screen.wid / 2, screen.hei / 2, _, scale.wid, scale.hei, gui_keyboard:getWidth() / 2, gui_keyboard: getHeight() / 2)
        else
            love.graphics.draw(gui_enter, screen.wid * 0.475, screen.hei / 2, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
            love.graphics.draw(gui_butA, screen.wid * 0.525, screen.hei / 2, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
        end
    elseif game.playerCount == 2 then
        --love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.785), (screen.wid * 0.8), (screen. hei * 0.085))
        love.graphics.rectangle("fill", (screen.wid * 0.15), (screen.hei * 0.25), (screen.wid * 0.3), (screen. hei * 0.4))
        love.graphics.rectangle("fill", (screen.wid * 0.55), (screen.hei * 0.25), (screen.wid * 0.3), (screen. hei * 0.4))
        love.graphics.setColor(255,255,255)
        love.graphics.setFont(font_type.edosz3)
        love.graphics.printf("- "..lang.s4_player1.." -", screen.wid * 0.15, screen.hei * 0.25, screen.wid * 0.3, "center")
        love.graphics.printf("- "..lang.s4_player2.." -", screen.wid * 0.55, screen.hei * 0.25, screen.wid * 0.3, "center")
        --[[love.graphics.setColor(255, 210, 77)
        love.graphics.setFont(font_type.edosz5)
        love.graphics.printf(lang.s4_2playerNote, screen.wid * 0.1, screen.hei * 0.79, screen.wid * 0.8, "center")]]
        love.graphics.setColor(255,255,255)
        if player[1].controller ~= nil and player[1].controller ~= "keyboard" then
            love.graphics.draw(gui_controller, screen.wid * 0.30, screen.hei / 2, _, scale.wid, scale.hei, gui_controller:getWidth() / 2, gui_controller: getHeight() / 2)
        elseif player[1].controller == "keyboard" then
            love.graphics.draw(gui_keyboard, screen.wid * 0.30, screen.hei / 2, _, scale.wid, scale.hei, gui_keyboard:getWidth() / 2, gui_keyboard: getHeight() / 2)
        else
            love.graphics.draw(gui_butA, screen.wid * 0.325, screen.hei / 2, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
            love.graphics.draw(gui_enter, screen.wid * 0.275, screen.hei / 2, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        end
        if player[2].controller ~= nil and player[2].controller ~= "keyboard" then
            love.graphics.draw(gui_controller, screen.wid * 0.70, screen.hei / 2, _, scale.wid, scale.hei, gui_controller:getWidth() / 2, gui_controller: getHeight() / 2)
        elseif player[2].controller == "keyboard" then
            love.graphics.draw(gui_keyboard, screen.wid * 0.70, screen.hei / 2, _, scale.wid, scale.hei, gui_keyboard:getWidth() / 2, gui_keyboard: getHeight() / 2)
        else
            love.graphics.draw(gui_butA, screen.wid * 0.725, screen.hei / 2, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
            love.graphics.draw(gui_enter, screen.wid * 0.675, screen.hei / 2, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        end
    end

    love.graphics.setFont(font_type.edosz2)
    love.graphics.setColor(255, 210, 77)
    love.graphics.printf(lang.s4_controllerSelect, 0, screen.hei * 0.11, screen.wid, "center")

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font_type.edosz4)
    love.graphics.printf(lang.s4_controllerInstructions, screen.wid * 0.1, screen.hei * 0.72, screen.wid * 0.8, "center")

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.0), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
    love.graphics.setFont(font_type.edosz3)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(lang.sx_back, 0, screen.hei * 0.9, screen.wid * 0.2, "right")
    love.graphics.draw(gui_backspace, screen.wid * 0.26, screen.hei * 0.93, _, scale.wid , scale.hei, gui_backspace:getWidth() / 2, gui_backspace:getHeight() / 2)
    love.graphics.draw(gui_butB, screen.wid * 0.225, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butB:getWidth() / 2, gui_butB:getHeight() / 2)

    if contsel_confirmation then
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_next, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
        love.graphics.draw(gui_enter, screen.wid * 0.74, screen.hei * 0.93, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.775, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
    end
end