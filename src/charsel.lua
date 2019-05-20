--[[    Load all the resources needed to character selection screen
    (num_players: the quantity of players who will play)
]]
function charsel_load()
    --charsel variables
    input = {abort = false}
    charsel_confirmation = false
    char_selected = {p1 = 1, p2 = 4}
    charsel_equals = false

    char_names = {
        "Kohuang", "Yangsho", "Mayi", "Tsushu"
    }

    gui_sel1 = love.graphics.newImage("gui/selection1.png")
    gui_sel2 = love.graphics.newImage("gui/selection2.png")
    gui_char = {
        {big = love.graphics.newImage("gui/chars/ninja1_charBig.png"), thumb = love.graphics.newImage("gui/chars/ninja1_charThumb.png")},
        {big = love.graphics.newImage("gui/chars/ninja2_charBig.png"), thumb = love.graphics.newImage("gui/chars/ninja2_charThumb.png")},
        {big = love.graphics.newImage("gui/chars/ninja3_charBig.png"), thumb = love.graphics.newImage("gui/chars/ninja3_charThumb.png")},
        {big = love.graphics.newImage("gui/chars/ninja4_charBig.png"), thumb = love.graphics.newImage("gui/chars/ninja4_charThumb.png")}
    }
end

--[[    Update the character selection screen variables
    (dt: delta-time from "love.update(dt)")
]]
function charsel_update(dt)
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

    if player[1].character ~= nil and player[2].character ~= nil and not charsel_equals then
        charsel_confirmation = true
    else
        charsel_confirmation = false
    end
    
    if char_selected.p1 == char_selected.p2 then
       charsel_equals = true
    else
        charsel_equals = false
    end

    if game.playerCount == 1 then
        if player[1].c_left then
            if player[1].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p1 = charsel_changeSelected("left", char_selected.p1)
            elseif player[2].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p2 = charsel_changeSelected("left", char_selected.p2)
            end
            player[1].c_left = false
        elseif player[1].c_right then
            if player[1].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p1 = charsel_changeSelected("right", char_selected.p1)
            elseif player[2].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p2 = charsel_changeSelected("right", char_selected.p2)
            end
            player[1].c_right = false
        elseif player[1].c_a then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[1].character == nil then
                player[1].character = char_selected.p1 
            elseif player[2].character == nil then
                player[2].character = char_selected.p2
            elseif charsel_confirmation then
                arenasel_load()
                screen_setState(6)
            end

            player[1].c_a = false
        elseif player[1].c_b then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[1].character ~= nil and player[2].character ~= nil then
                player[2].character = nil 
            elseif player[1].character ~= nil and player[2].cgaracter == nil then
                player[1].character = nil
            else
                screen_setState(4)
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
            end
            player[1].c_b = false
        elseif player[1].c_x then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[1].character == nil then
                math.randomseed(dt)
                char_selected.p1 = math.random(4)
                player[1].character = char_selected.p1
            elseif player[2].character == nil then
                math.randomseed(dt)
                char_selected.p2 = math.random(4)
                player[2].character = char_selected.p2
            end
            player[1].c_x = false
        end
    elseif game.playerCount == 2 then
        if player[1].c_left then
            if player[1].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p1 = charsel_changeSelected("left", char_selected.p1)
            end
            player[1].c_left = false
        elseif player[1].c_right then
            if player[1].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p1 = charsel_changeSelected("right", char_selected.p1)
            end
            player[1].c_right = false
        elseif player[1].c_a then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[1].character == nil then
                player[1].character = char_selected.p1 
            elseif charsel_confirmation then
                arenasel_load()
                screen_setState(6)
            end

            player[1].c_a = false
        elseif player[1].c_b then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[1].character == nil and player[2].character == nil then
                screen_setState(4)
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
            elseif player[1].character ~= nil then
                player[1].character = nil
            end
            player[1].c_b = false
        elseif player[1].c_x then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[1].character == nil then
                math.randomseed(dt)
                char_selected.p1 = math.random(4)
                player[1].character = char_selected.p1
            end
            player[1].c_x = false
        end
        if player[2].c_left then
            if player[2].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p2 = charsel_changeSelected("left", char_selected.p2)
            end
            player[2].c_left = false
        elseif player[2].c_right then
            if player[2].character == nil then
                audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
                char_selected.p2 = charsel_changeSelected("right", char_selected.p2)
            end
            player[2].c_right = false
        elseif player[2].c_a then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[2].character == nil then
                player[2].character = char_selected.p2 
            elseif charsel_confirmation then
                arenasel_load()
                screen_setState(6)
            end

            player[2].c_a = false
        elseif player[2].c_b then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[2].character == nil and player[1].character == nil then
                screen_setState(4)
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
            elseif player[2].character ~= nil then
                player[2].character = nil
            end
            player[2].c_b = false
        elseif player[2].c_x then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            if player[2].character == nil then
                math.randomseed(dt)
                char_selected.p2 = math.random(4)
                player[2].character = char_selected.p2 
            end
            player[2].c_x = false
        end
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
function charsel_keyreleased(key)
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
        elseif key == "k" or key == "return" then
            player[1].c_a = true
        elseif key == "i" then
            player[1].c_x = true
        end
    end
    if player[2].controller == kb_keys.id then
        if key == "a" or key == "left" then
            player[2].c_left = true
        elseif key == "d" or key == "right" then
            player[2].c_right = true
        elseif key == "backspace" then
            player[2].c_b = true
        elseif key == "k" or key == "return" then
            player[2].c_a = true
        elseif key == "i" then
            player[2].c_x = true
        end
    end
end

--[[    Handle when some gamepad button has released
(gamepad: gamepad object, key: button code)
]]
function charsel_gamepadreleased(gamepad, key)
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
    if player[2].controller == gamepad then
        if key == "dpleft" then
            player[2].c_left = true
        elseif key == "dpright" then
            player[2].c_right = true
        elseif key == "b" then
            player[2].c_b = true
        elseif key == "a" then
            player[2].c_a = true
        elseif key == "x" then
            player[2].c_x = true
        end
    end
end

--[[    Draw the character selection in the screen
]]
function charsel_draw()

    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_background, screen.wid / 2, screen.hei / 2, _, scale.wid * logo.bgi * 1.1, scale.hei * logo.bgi * 1.1, gui_background:getWidth() / 2, gui_background:getHeight() / 2)

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.1), (screen.wid * 0.8), (screen. hei * 0.085))
    love.graphics.rectangle("fill", (screen.wid * 0.35), (screen.hei * 0.41), (screen.wid * 0.3), (screen. hei * 0.35))

    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_char[1].thumb, screen.wid * 0.395, screen.hei * 0.685, _, scale.wid, scale.hei, gui_char[1].thumb:getWidth() / 2, gui_char[1].thumb:getHeight() / 2)
    love.graphics.draw(gui_char[2].thumb, screen.wid * 0.465, screen.hei * 0.685, _, scale.wid, scale.hei, gui_char[2].thumb:getWidth() / 2, gui_char[2].thumb:getHeight() / 2)
    love.graphics.draw(gui_char[3].thumb, screen.wid * 0.535, screen.hei * 0.685, _, -scale.wid, scale.hei, gui_char[3].thumb:getWidth() / 2, gui_char[3].thumb:getHeight() / 2)
    love.graphics.draw(gui_char[4].thumb, screen.wid * 0.605, screen.hei * 0.685, _, -scale.wid, scale.hei, gui_char[4].thumb:getWidth() / 2, gui_char[4].thumb:getHeight() / 2)
    if game.playerCount == 1 then
        if player[1].character == nil then
            if char_selected.p1 == 1 then
                love.graphics.draw(gui_sel1, screen.wid * 0.395, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
            elseif char_selected.p1 == 2 then
                love.graphics.draw(gui_sel1, screen.wid * 0.465, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
            elseif char_selected.p1 == 3 then
                love.graphics.draw(gui_sel1, screen.wid * 0.535, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
            elseif char_selected.p1 == 4 then
                love.graphics.draw(gui_sel1, screen.wid * 0.605, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
            end
        elseif player[2].character == nil then
            if char_selected.p2 == 1 then
                love.graphics.draw(gui_sel2, screen.wid * 0.395, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
            elseif char_selected.p2 == 2 then
                love.graphics.draw(gui_sel2, screen.wid * 0.465, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
            elseif char_selected.p2 == 3 then
                love.graphics.draw(gui_sel2, screen.wid * 0.535, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
            elseif char_selected.p2 == 4 then
                love.graphics.draw(gui_sel2, screen.wid * 0.605, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
            end 
        end
    elseif game.playerCount == 2 then
        if char_selected.p1 == 1 then
            love.graphics.draw(gui_sel1, screen.wid * 0.395, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
        elseif char_selected.p1 == 2 then
            love.graphics.draw(gui_sel1, screen.wid * 0.465, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
        elseif char_selected.p1 == 3 then
            love.graphics.draw(gui_sel1, screen.wid * 0.535, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
        elseif char_selected.p1 == 4 then
            love.graphics.draw(gui_sel1, screen.wid * 0.605, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel1:getWidth() / 2, gui_sel1:getHeight() / 2)
        end
        if char_selected.p2 == 1 then
            love.graphics.draw(gui_sel2, screen.wid * 0.395, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
        elseif char_selected.p2 == 2 then
            love.graphics.draw(gui_sel2, screen.wid * 0.465, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
        elseif char_selected.p2 == 3 then
            love.graphics.draw(gui_sel2, screen.wid * 0.535, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
        elseif char_selected.p2 == 4 then
            love.graphics.draw(gui_sel2, screen.wid * 0.605, screen.hei * 0.685, _, scale.wid, scale.hei, gui_sel2:getWidth() / 2, gui_sel2:getHeight() / 2)
        end
    end

    love.graphics.draw(gui_char[char_selected.p1].big, screen.wid * 0.2, screen.hei * 0.535, (logo.anim * 2) - 2, scale.wid, scale.hei, gui_char[char_selected.p1].big:getWidth() / 2, gui_char[char_selected.p1].big:getHeight() / 2)
    love.graphics.draw(gui_char[char_selected.p2].big, screen.wid * 0.8, screen.hei * 0.535, (logo.anim * 2) - 2, -scale.wid, scale.hei, gui_char[char_selected.p2].big:getWidth() / 2, gui_char[char_selected.p2].big:getHeight() / 2)

    love.graphics.setFont(font_type.drje1)
    love.graphics.printf(lang.s5_versus, screen.wid * 0.3, screen.hei * 0.485, screen.wid * 0.4, "center")

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.765), (screen.wid * 0.2), (screen. hei * 0.1))
    love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.765), (screen.wid * 0.2), (screen. hei * 0.1))

    love.graphics.setColor(255,255,255)
    love.graphics.setFont(font_type.edosz2)
    love.graphics.printf(char_names[char_selected.p1], screen.wid * 0.1, screen.hei * 0.775, screen.wid * 0.2, "center")
    love.graphics.printf(char_names[char_selected.p2], screen.wid * 0.7, screen.hei * 0.775, screen.wid * 0.2, "center")

    love.graphics.setFont(font_type.edosz2)
    love.graphics.setColor(255, 210, 77)
    love.graphics.printf(lang.s5_characterSelection, 0, screen.hei * 0.11, screen.wid, "center")

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.0), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
    love.graphics.setFont(font_type.edosz3)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(lang.sx_back, 0, screen.hei * 0.9, screen.wid * 0.2, "right")
    love.graphics.draw(gui_backspace, screen.wid * 0.26, screen.hei * 0.93, _, scale.wid , scale.hei, gui_backspace:getWidth() / 2, gui_backspace:getHeight() / 2)
    love.graphics.draw(gui_butB, screen.wid * 0.225, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butB:getWidth() / 2, gui_butB:getHeight() / 2)
    
    if charsel_confirmation then
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_next, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
        love.graphics.draw(gui_enter, screen.wid * 0.74, screen.hei * 0.93, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.775, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
    elseif charsel_equals then
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.3), (screen.hei * 0.765), (screen.wid * 0.4), (screen. hei * 0.13))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 64, 0)
        love.graphics.printf(lang.s5_equalCharacter, screen.wid * 0.3, screen.hei * 0.770, screen.wid * 0.4, "center")
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
function charsel_changeSelected(dir, playerSel)
    if dir == "left" then
        playerSel = playerSel - 1
        if playerSel < 1 then
            playerSel = 4
        end
    elseif dir == "right" then
        playerSel = playerSel + 1
        if playerSel > 4 then
            playerSel = 1
        end
    else
        playerSel = dir
    end
    return playerSel
end