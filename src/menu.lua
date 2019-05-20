--[[    Load all the resources needed to menu
]]
function menu_load()
    --logo animation variables
    logo = {anim = 1, mod = 1, bgi = 1}
    --menu variables
    menu_selected = 1
    menu_confirmation = false
    input = {up = false, down = false, ok = false, back = false, abort = false}
    --audio variables
    bgm = {vol = 0.5 * settings.volMusic * settings.volMaster, pit = 1, loop = true}
    opt = {vol = 0.75 * settings.volMaster, pit = 1, loop = false}
    sel = {vol = 1 * settings.volMaster, pit = 1, loop = false}
    sfx_bgm = love.audio.newSource("sfx/menu_bgm.ogg")
    sfx_option = love.audio.newSource("sfx/option.ogg")
    sfx_selection = love.audio.newSource("sfx/selection.ogg")
    

    --gui variables
    font_size = {
        s5 = screen.hei/35, 
        s4 = screen.hei/25, 
        s3 = screen.hei/20, 
        s2 = screen.hei/15,
        s1 = screen.hei/10,
        s0 = screen.hei/5
    }
    font_type = {
        edosz5 = love.graphics.newFont("gui/edosz.ttf", font_size.s5), 
        edosz4 = love.graphics.newFont("gui/edosz.ttf", font_size.s4), 
        edosz3 = love.graphics.newFont("gui/edosz.ttf", font_size.s3), 
        edosz2 = love.graphics.newFont("gui/edosz.ttf", font_size.s2),
        edosz1 = love.graphics.newFont("gui/edosz.ttf", font_size.s1),
        drje3 = love.graphics.newFont("gui/drjekyll.ttf", font_size.s3),
        drje2 = love.graphics.newFont("gui/drjekyll.ttf", font_size.s2),
        drje1 = love.graphics.newFont("gui/drjekyll.ttf", font_size.s1),
        drje0 = love.graphics.newFont("gui/drjekyll.ttf", font_size.s0)
    }

    gui_logo = love.graphics.newImage("gui/title.png")
    gui_background = love.graphics.newImage("gui/splash_bg_red.png")
    gui_background_alt = love.graphics.newImage("gui/splash_bg_silver.png")
    gui_enter = love.graphics.newImage("gui/keyboard/key_enter.png")
    gui_backspace = love.graphics.newImage("gui/keyboard/key_backspace.png")
    gui_butA = love.graphics.newImage("gui/controller/face_A.png")
    gui_butB = love.graphics.newImage("gui/controller/face_B.png")

    --game variables
    game = {playerCount = 0, roundTime = settings.roundTime, roundsToWin = settings.roundsToWin, arena = nil}
    player = {
        {controller = nil, character = nil, rounds = nil,
            c_left = false, c_right = false, c_up = false, c_down = false, 
            c_a = false, c_b = false, c_x = false, c_y = false, 
            c_back = false, c_start = false, c_bumpR = false, c_bumpL = false,
            axis_x = 0, axis_y = 0, var = nil}, 
        {controller = nil, character = nil, rounds = nil,
            c_left = false, c_right = false, c_up = false, c_down = false, 
            c_a = false, c_b = false, c_x = false, c_y = false, 
            c_back = false, c_start = false, c_bumpR = false, c_bumpL = false,
            axis_x = 0, axis_y = 0, var = nil}
        }
end

--[[    Update the menu variables
    (dt: delta-time from "love.update(dt)")
]]
function menu_update(dt)
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
    if menu_confirmation then
        sfx_bgm:setVolume(bgm.vol/2)
    else
        sfx_bgm:setVolume(bgm.vol)
    end

    --menu
    if input.up then
        audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
        menu_changeSelected("up")
        input.up = false
    elseif input.down then
        audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
        menu_changeSelected("down")
        input.down = false
    elseif input.ok then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        if menu_selected == 1 then
            game.playerCount = 1
            contsel_load()
            screen_setState(4)
        elseif menu_selected == 2 then
            game.playerCount = 2
            contsel_load()
            screen_setState(4)
        elseif menu_selected == 3 then
            temp_settings = settings
            screen_setState(3)
        elseif menu_selected == 4 then
            audio_stop(sfx_bgm)
            credits_load()
            screen_setState(2)
        elseif menu_selected == 5 then
            if not menu_confirmation then
                menu_confirmation = true
            else
                love.event.quit()
            end
        end
        input.ok = false
    elseif input.back then
        if not menu_confirmation then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            menu_changeSelected(5)
        else
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            menu_changeSelected(1)
            menu_confirmation = false
        end
        input.back = false
    elseif input.abort then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        if not menu_confirmation then
            menu_changeSelected(5)
            menu_confirmation = true
        end
        input.abort = false
    end
end

--[[    Handle when some key has released
    (key: key code)
]]
function menu_keyreleased(key)
    if key == "escape" then
        input.abort = true
    end
    if key == "w" or key == "up" and not menu_confirmation then
        input.up = true
    end
    if key == "s" or key == "down" and not menu_confirmation then
        input.down = true
    end
    if key == "return" then
        input.ok = true
    end
    if key == "backspace" then
        input.back = true
    end
end

--[[    Handle when some gamepad button has released
    (gamepad: gamepad object, key: button code)
]]
function menu_gamepadreleased(gamepad, key)
    if key == "back" then
        input.abort = true
    end
    if key == "dpup" and not menu_confirmation then
        input.up = true
    end
    if key == "dpdown" and not menu_confirmation then
        input.down = true
    end
    if key == "a" or key == "start" then
        input.ok = true
    end
    if key == "b" then
        input.back = true
    end
end

--[[    Draw the menu in the screen
]]
function menu_draw()

    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_background, screen.wid / 2, screen.hei / 2, _, scale.wid * logo.bgi * 1.1, scale.hei * logo.bgi * 1.1, gui_background:getWidth() / 2, gui_background:getHeight() / 2)
    --love.graphics.setBackgroundColor(128,128,128)

    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.5) - (200 * scale.wid), (screen.hei * 0.5), (400 * scale.wid), (screen. hei * 0.4))

    love.graphics.setFont(font_type.edosz2)
    love.graphics.setColor(255, 255, 255)
    if menu_selected == 1 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s1_play, 0, screen.hei * 0.5, screen.wid, "center")
    love.graphics.setColor(255, 255, 255)
    if menu_selected == 2 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s1_versus, 0, screen.hei * 0.575, screen.wid, "center")
    love.graphics.setColor(255, 255, 255)
    if menu_selected == 3 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s1_options, 0, screen.hei * 0.65, screen.wid, "center")
    love.graphics.setColor(255, 255, 255)
    if menu_selected == 4 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s1_credits, 0, screen.hei * 0.725, screen.wid, "center")
    love.graphics.setColor(255, 255, 255)
    if menu_selected == 5 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s1_quit, 0, screen.hei * 0.8, screen.wid, "center")
    love.graphics.setColor(255, 255, 255)

    love.graphics.draw(gui_logo, (screen.wid/2), (screen.hei * 0.25), _, scale.wid * logo.anim, scale.hei * logo.anim, gui_logo:getWidth() / 2, gui_logo:getHeight() / 2)

    if menu_confirmation then
        love.graphics.setColor(0, 0, 0, 127)
        love.graphics.rectangle("fill", 0, 0, screen.wid, screen.hei)
        love.graphics.setColor(32, 32, 32, 223)
        love.graphics.rectangle("fill", 0, (screen.hei / 3), screen.wid, (screen.hei / 3))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 64, 0)
        love.graphics.printf(lang.s1_confirmation, 0, screen.hei * 0.4, screen.wid, "center")
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_yes, 0, screen.hei * 0.53, screen.wid * 0.4, "right")
        love.graphics.printf(lang.sx_no, screen.wid * 0.6, screen.hei * 0.53, screen.wid, "left")
        love.graphics.draw(gui_enter, screen.wid * 0.36, screen.hei * 0.615, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.4, screen.hei * 0.615, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
        love.graphics.draw(gui_backspace, screen.wid * 0.635, screen.hei * 0.615, _, scale.wid , scale.hei, gui_backspace:getWidth() / 2, gui_backspace:getHeight() / 2)
        love.graphics.draw(gui_butB, screen.wid * 0.595, screen.hei * 0.615, _, scale.wid , scale.hei, gui_butB:getWidth() / 2, gui_butB:getHeight() / 2)
    else
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.0), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_select, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
        love.graphics.printf(lang.sx_back, 0, screen.hei * 0.9, screen.wid * 0.2, "right")
        love.graphics.draw(gui_enter, screen.wid * 0.74, screen.hei * 0.93, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.775, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
        love.graphics.draw(gui_backspace, screen.wid * 0.26, screen.hei * 0.93, _, scale.wid , scale.hei, gui_backspace:getWidth() / 2, gui_backspace:getHeight() / 2)
        love.graphics.draw(gui_butB, screen.wid * 0.225, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butB:getWidth() / 2, gui_butB:getHeight() / 2)
    end
end

--[[    Change the selection in menu
    (dir: set the next item to be selected ["up"-"down"/number])
]]
function menu_changeSelected(dir)
    if dir == "up" then
        menu_selected = menu_selected - 1
        if menu_selected < 1 then
            menu_selected = 5
        end
    elseif dir == "down" then
        menu_selected = menu_selected + 1
        if menu_selected > 5 then
            menu_selected = 1
        end
    else
        menu_selected = dir
    end
end

--[[    Reset the variables of the game
]]
function menu_reset()
    menu_selected = 1
    menu_confirmation = false
    input = {up = false, down = false, ok = false, back = false, abort = false}
    game = {playerCount = 0, roundTime = settings.roundTime, roundsToWin = settings.roundsToWin, arena = nil}
    player = {
        {controller = nil}, 
        {controller = nil}
        }
end