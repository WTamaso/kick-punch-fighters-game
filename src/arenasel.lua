--[[    Load all the resources needed to arena selection screen
    (num_players: the quantity of players who will play)
]]
function arenasel_load()
    --arenasel variables
    input = {abort = false}
    arenasel_confirmation = false
    arena_selected = 1

    arena_names = {
        lang.s6_summerForest, lang.s6_winterForest, lang.s6_blazingDesert
    }

    gui_arena = {
        {big = love.graphics.newImage("gui/arenas/arena1_big.png"), thumb = love.graphics.newImage("gui/arenas/arena1_thumb.png")},
        {big = love.graphics.newImage("gui/arenas/arena2_big.png"), thumb = love.graphics.newImage("gui/arenas/arena2_thumb.png")},
        {big = love.graphics.newImage("gui/arenas/arena3_big.png"), thumb = love.graphics.newImage("gui/arenas/arena3_thumb.png")}
    }
end

--[[    Update the arena selection screen variables
    (dt: delta-time from "love.update(dt)")
]]
function arenasel_update(dt)
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

    if game.arena ~= nil then
        arenasel_confirmation = true 
    else
        arenasel_confirmation = false
    end

    if player[1].c_left then
        if game.arena == nil then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            arena_changeSelected("left")
        end
        player[1].c_left = false
    elseif player[1].c_right then
        if game.arena == nil then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            arena_changeSelected("right")
        end
        player[1].c_right = false
    elseif player[1].c_a then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        if game.arena == nil then
            game.arena = arena_selected 
        elseif charsel_confirmation then
            --START GAME
            isLoading = false
            isReady = false
            screen_setState(6.5)
        end
        player[1].c_a = false
    elseif player[1].c_b then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        if game.arena ~= nil then
            game.arena = nil 
        else
            screen_setState(5)
            game.arena = nil
        end
        player[1].c_b = false
    elseif player[1].c_x then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        if game.arena == nil then
            math.randomseed(dt)
            arena_selected = math.random(3)
            game.arena = arena_selected
        end
        player[1].c_x = false
    end

    if input.abort then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        screen_setState(1)
        player = {
            {controller = nil, character = nil, 
                c_left = false, c_right = false, c_up = false, c_down = false, 
                c_a = false, c_b = false, c_x = false, c_y = false, 
                c_back = false, c_start = false, c_bumpR = false, c_bumpL = false}, 
            {controller = nil, character = nil,
                c_left = false, c_right = false, c_up = false, c_down = false, 
                c_a = false, c_b = false, c_x = false, c_y = false, 
                c_back = false, c_start = false, c_bumpR = false, c_bumpL = false}
        }
        input.abort = false
    end
end

--[[    Handle when some key has released
    (key: key code)
]]
function arenasel_keyreleased(key)
    if key == "escape" then
        input.abort = true
    end
    if player[1].controller == kb_keys.id then
        if key == "a" or key == "left" then
            player[1].c_left = true
        elseif key == "d" or key == "right" then
            player[1].c_right = true
        elseif key == "backspace" then
            player[1].c_b = true
        elseif key == "return" then
            player[1].c_a = true
        elseif key == "i" then
            player[1].c_x = true
        end
    end
end

--[[    Handle when some gamepad button has released
(gamepad: gamepad object, key: button code)
]]
function arenasel_gamepadreleased(gamepad, key)
    if key == "back" then
        input.abort = true
    end
    if player[1].controller == gamepad then
        if key == "dpleft" then
            player[1].c_left = true
        elseif key == "dpright" then
            player[1].c_right = true
        elseif key == "b" then
            player[1].c_b = true
        elseif key == "a" then
            player[1].c_a = true
        elseif key == "x" then
            player[1].c_x = true
        end
    end
end

--[[    Draw the arena selection in the screen
]]
function arenasel_draw()

    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_background, screen.wid / 2, screen.hei / 2, _, scale.wid * logo.bgi * 1.1, scale.hei * logo.bgi * 1.1, gui_background:getWidth() / 2, gui_background:getHeight() / 2)

    love.graphics.draw(gui_arena[arena_selected].big, screen.wid * 0.5, screen.hei * 0.55, _, (scale.wid / 2) * logo.anim, (scale.hei / 2) * logo.anim, gui_arena[arena_selected].big:getWidth() / 2, gui_arena[arena_selected].big:getHeight() / 2)

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.1), (screen.wid * 0.8), (screen. hei * 0.085))
    love.graphics.rectangle("fill", (screen.wid * 0.3), (screen.hei * 0.24), (screen.wid * 0.4), (screen. hei * 0.1))
    love.graphics.rectangle("fill", (screen.wid * 0.375), (screen.hei * 0.725), (screen.wid * 0.25), (screen. hei * 0.15))

    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_arena[1].thumb, screen.wid * 0.42, screen.hei * 0.8, _, scale.wid, scale.hei, gui_char[1].thumb:getWidth() / 2, gui_char[1].thumb:getHeight() / 2)
    love.graphics.draw(gui_arena[2].thumb, screen.wid * 0.5, screen.hei * 0.8, _, scale.wid, scale.hei, gui_char[2].thumb:getWidth() / 2, gui_char[2].thumb:getHeight() / 2)
    love.graphics.draw(gui_arena[3].thumb, screen.wid * 0.58, screen.hei * 0.8, _, scale.wid, scale.hei, gui_char[3].thumb:getWidth() / 2, gui_char[3].thumb:getHeight() / 2)

    love.graphics.setFont(font_type.edosz2)
    love.graphics.printf(arena_names[arena_selected], screen.wid * 0.3, screen.hei * 0.25, screen.wid * 0.4, "center")

    if game.arena == nil then
        if arena_selected == 1 then
            love.graphics.draw(gui_sel1, screen.wid * 0.42, screen.hei * 0.8, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
        elseif arena_selected == 2 then
            love.graphics.draw(gui_sel1, screen.wid * 0.5, screen.hei * 0.8, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
        elseif arena_selected == 3 then
            love.graphics.draw(gui_sel1, screen.wid * 0.58, screen.hei * 0.8, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
        end
    end

    love.graphics.setFont(font_type.edosz2)
    love.graphics.setColor(255, 210, 77)
    love.graphics.printf(lang.s6_arenaSelection, 0, screen.hei * 0.11, screen.wid, "center")

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.0), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
    love.graphics.setFont(font_type.edosz3)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(lang.sx_back, 0, screen.hei * 0.9, screen.wid * 0.2, "right")
    love.graphics.draw(gui_backspace, screen.wid * 0.26, screen.hei * 0.93, _, scale.wid , scale.hei, gui_backspace:getWidth() / 2, gui_backspace:getHeight() / 2)
    love.graphics.draw(gui_butB, screen.wid * 0.225, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butB:getWidth() / 2, gui_butB:getHeight() / 2)

    if arenasel_confirmation then
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_next, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
        love.graphics.draw(gui_enter, screen.wid * 0.74, screen.hei * 0.93, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.775, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
    else
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.3), (screen.hei * 0.895), (screen.wid * 0.4), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_random, screen.wid * 0.3, screen.hei * 0.9, screen.wid * 0.2, "right")
        love.graphics.draw(gui_keyI, screen.wid * 0.56, screen.hei * 0.93, _, scale.wid , scale.hei, gui_keyI:getWidth() / 2, gui_keyI:getHeight() / 2)
        love.graphics.draw(gui_butX, screen.wid * 0.525, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butX:getWidth() / 2, gui_butX:getHeight() / 2)

        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_select, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
        love.graphics.draw(gui_enter, screen.wid * 0.74, screen.hei * 0.93, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.775, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
    end
end

--[[    Change the selection in menu
(dir: set the next item to be selected ["left"-"right"/number])
]]
function arena_changeSelected(dir)
    if dir == "left" then
        arena_selected = arena_selected - 1
        if arena_selected < 1 then
            arena_selected = 3
        end
    elseif dir == "right" then
        arena_selected = arena_selected + 1
        if arena_selected > 3 then
            arena_selected = 1
        end
    else
        arena_selected = dir
    end
end