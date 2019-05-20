--[[    settings to implement
    gameplay:
        change AI difficulty maybe
]]

--[[    Load all the resources needed to options
]]
function options_load()
    --options variables
    options_selected = 1
    options_confirmation = false
    option_text = "nil"
    input = {up = false, down = false, left = false, right = false, ok = false, back = false, abort = false}
    
    --gui variables
    gui_hatA = love.graphics.newImage("gui/controller/hat_all.png")
    gui_butA = love.graphics.newImage("gui/controller/face_A.png")
    gui_butB = love.graphics.newImage("gui/controller/face_B.png")
    gui_butX = love.graphics.newImage("gui/controller/face_X.png")
    gui_butY = love.graphics.newImage("gui/controller/face_Y.png")
    gui_bumR = love.graphics.newImage("gui/controller/bumper_right.png")
    gui_bumL = love.graphics.newImage("gui/controller/bumper_left.png")
    gui_start = love.graphics.newImage("gui/controller/button_start.png")
    gui_back = love.graphics.newImage("gui/controller/button_back.png")
    gui_wsad = love.graphics.newImage("gui/keyboard/arrow_wsad.png")
    gui_keyK = love.graphics.newImage("gui/keyboard/letter_K.png")
    gui_keyL = love.graphics.newImage("gui/keyboard/letter_L.png")
    gui_keyI = love.graphics.newImage("gui/keyboard/letter_I.png")
    gui_keyO = love.graphics.newImage("gui/keyboard/letter_O.png")
    gui_keyE = love.graphics.newImage("gui/keyboard/letter_E.png")
    gui_keyQ = love.graphics.newImage("gui/keyboard/letter_Q.png")
    gui_enter = love.graphics.newImage("gui/keyboard/key_enter.png")
    gui_esc = love.graphics.newImage("gui/keyboard/key_esc.png")

end

--[[    Update the options variables
    (dt: delta-time from "love.update(dt)")
]]
function options_update(dt)
    --logo animation
    logo.anim = logo.anim + (dt/50 * logo.mod)
    logo.bgi = logo.bgi + (dt/50 * -logo.mod)
    if logo.anim > 1.02 then
        logo.mod = -1
    elseif logo.anim < 0.98 then
        logo.mod = 1
    end
    
    --background audio
    bgm = {vol = 0.5 * settings.volMusic * settings.volMaster, pit = 1, loop = true}
    opt = {vol = 1 * settings.volMaster, pit = 1, loop = false}
    sel = {vol = 1 * settings.volMaster, pit = 1, loop = false}
    audio_update(sfx_bgm, bgm.vol, bgm.pit, bgm.loop)
    audio_update(sfx_option, opt.vol, opt.pit, opt.loop)
    audio_update(sfx_selection, sel.vol, sel.pit, sel.loop)
    if not sfx_bgm:isPlaying() then
        audio_play(sfx_bgm, bgm.vol, bgm.pit, bgm.loop, true)
    end
    if options_confirmation then
        sfx_bgm:setVolume(bgm.vol/2)
    else
        sfx_bgm:setVolume(bgm.vol)
    end

    --menu
    if input.up then
        audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
        options_changeSelected("up")
        input.up = false
    elseif input.down then
        audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
        options_changeSelected("down")
        input.down = false
    elseif input.left then
        audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
        if options_selected == 1 then --round time
            options_changeValue("-", 1)
        elseif options_selected == 2 then --rounds to win
            options_changeValue("-", 2)
        elseif options_selected == 3 then --back as start
            options_changeValue("-", 3)
        elseif options_selected == 4 then --language
            options_changeValue("-", 4)
        elseif options_selected == 5 then --master volume
            options_changeValue("-", 5)
        elseif options_selected == 6 then --music volume
            options_changeValue("-", 6)
        elseif options_selected == 7 then --game volume
            options_changeValue("-", 7)
        end
        input.left = false
    elseif input.right then
        audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
        if options_selected == 1 then --round time
            options_changeValue("+", 1)
        elseif options_selected == 2 then --rounds to win
            options_changeValue("+", 2)
        elseif options_selected == 3 then --back as start
            options_changeValue("+", 3)
        elseif options_selected == 4 then --language
            options_changeValue("+", 4)
        elseif options_selected == 5 then --master volume
            options_changeValue("+", 5)
        elseif options_selected == 6 then --music volume
            options_changeValue("+", 6)
        elseif options_selected == 7 then --game volume
            options_changeValue("+", 7)
        end
        input.right = false
    elseif input.ok then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        if not options_confirmation then
            options_confirmation = true
        else
            --apply the settings
            settings = temp_settings
            bgm = {vol = 0.5 * settings.volMusic * settings.volMaster, pit = 1, loop = true}
            opt = {vol = 1 * settings.volMaster, pit = 1, loop = false}
            sel = {vol = 1 * settings.volMaster, pit = 1, loop = false}
            audio_update(sfx_bgm, bgm.vol, bgm.pit, bgm.loop)
            audio_update(sfx_option, opt.vol, opt.pit, opt.loop)
            audio_update(sfx_selection, sel.vol, sel.pit, sel.loop)
            lang = lang_list[settings.language]
            file_saveSettings()
            screen_setState(1)
            options_confirmation = false
        end
        input.ok = false
    elseif input.back then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        if not options_confirmation then
            options_confirmation = true 
        else
            screen_setState(1)
            options_confirmation = false
        end
        input.back = false
    elseif input.abort then
        audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
        screen_setState(1)
        input.abort = false
    end
    if temp_settings.backAsStart then
        option_text = lang.sx_yes
    else
        option_text = lang.sx_no
    end
end

--[[    Handle when some key has released
(key: key code)
]]
function options_keyreleased(key)
    if key == "escape" then
        input.abort = true
    end
    if key == "w" or key == "up" and not options_confirmation then
        input.up = true
    end
    if key == "s" or key == "down" and not options_confirmation then
        input.down = true
    end
    if key == "a" or key == "left" and not options_confirmation then
        input.left = true
    end
    if key == "d" or key == "right" and not options_confirmation then
        input.right = true
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
function options_gamepadreleased(gamepad, key)
    if key == "back" then
        input.abort = true
    end
    if key == "dpup" and not options_confirmation then
        input.up = true
    end
    if key == "dpdown" and not options_confirmation then
        input.down = true
    end
    if key == "dpleft" and not options_confirmation then
        input.left = true
    end
    if key == "dpright" and not options_confirmation then
        input.right = true
    end
    if key == "a" or key == "start" then
        input.ok = true
    end
    if key == "b" then
        input.back = true
    end
end

--[[    Draw the options in the screen
]]
function options_draw()

    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_background, screen.wid / 2, screen.hei / 2, _, scale.wid * logo.bgi * 1.1, scale.hei * logo.bgi * 1.1, gui_background:getWidth() / 2, gui_background:getHeight() / 2)
    
    love.graphics.setColor(0, 0, 0, 96)
    love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.1), (screen.wid * 0.8), (screen. hei * 0.085))
    love.graphics.rectangle("fill", (screen.wid * 0.1), (screen.hei * 0.19), (screen.wid * 0.8), (screen. hei * 0.66))

    love.graphics.setFont(font_type.edosz2)
    love.graphics.setColor(255, 210, 77)
    love.graphics.printf(lang.s1_options, 0, screen.hei * 0.11, screen.wid, "center")

    love.graphics.setFont(font_type.edosz3)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("- "..lang.s3_gameplay.." -", screen.wid * 0.125, screen.hei * 0.19, screen.wid * 0.35, "center")
    love.graphics.printf("- "..lang.s3_general.." -", screen.wid * 0.125, screen.hei * 0.45, screen.wid * 0.35, "center")
    love.graphics.printf("- "..lang.s3_audio.." -", screen.wid * 0.125, screen.hei * 0.61, screen.wid * 0.35, "center")
    love.graphics.printf("- "..lang.s3_controls.." -", screen.wid * 0.5, screen.hei * 0.19, screen.wid * 0.35, "center")

    love.graphics.setFont(font_type.edosz4)
    if options_selected == 1 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s3_roundTime..":", screen.wid * 0.125, screen.hei * 0.25, screen.wid * 0.35, "left")
    love.graphics.printf("-  "..temp_settings.roundTime.." s  +", screen.wid * 0.125, screen.hei * 0.25, screen.wid * 0.35, "right")
    love.graphics.setColor(255, 255, 255)
    if options_selected == 2 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s3_roundsToWin..":", screen.wid * 0.125, screen.hei * 0.3, screen.wid * 0.35, "left")
    love.graphics.printf("-  "..temp_settings.roundsToWin.."  +", screen.wid * 0.125, screen.hei * 0.3, screen.wid * 0.35, "right")
    love.graphics.setColor(255, 255, 255)
    if options_selected == 3 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s3_pauseButton..":", screen.wid * 0.125, screen.hei * 0.35, screen.wid * 0.35, "left")
    love.graphics.printf("-  "..option_text.."  +", screen.wid * 0.125, screen.hei * 0.35, screen.wid * 0.35, "right")
    love.graphics.setColor(255, 255, 255)
    if options_selected == 4 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s3_language..":", screen.wid * 0.125, screen.hei * 0.51, screen.wid * 0.35, "left")
    love.graphics.printf("-  "..lang_names[temp_settings.language].."  +", screen.wid * 0.125, screen.hei * 0.51, screen.wid * 0.35, "right")
    love.graphics.setColor(255, 255, 255)
    if options_selected == 5 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s3_masterVol..":", screen.wid * 0.125, screen.hei * 0.67, screen.wid * 0.35, "left")
    love.graphics.printf("-  "..(temp_settings.volMaster * 100).."  +", screen.wid * 0.125, screen.hei * 0.67, screen.wid * 0.35, "right")
    love.graphics.setColor(255, 255, 255)
    if options_selected == 6 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s3_musicVol..":", screen.wid * 0.125, screen.hei * 0.72, screen.wid * 0.35, "left")
    love.graphics.printf("-  "..(temp_settings.volMusic * 100).."  +", screen.wid * 0.125, screen.hei * 0.72, screen.wid * 0.35, "right")
    love.graphics.setColor(255, 255, 255)
    if options_selected == 7 then
        love.graphics.setColor(255, 210, 77)
    end
    love.graphics.printf(lang.s3_gameVol..":", screen.wid * 0.125, screen.hei * 0.77, screen.wid * 0.35, "left")
    love.graphics.printf("-  "..(temp_settings.volGame * 100).."  +", screen.wid * 0.125, screen.hei * 0.77, screen.wid * 0.35, "right")
    love.graphics.setColor(255, 255, 255)

    love.graphics.draw(gui_wsad, screen.wid * 0.55, screen.hei * 0.3, _, scale.wid * 1.3, scale.hei * 1.3, gui_wsad:getWidth  () / 2, gui_wsad:getHeight() / 2)
    love.graphics.draw(gui_hatA, screen.wid * 0.6, screen.hei * 0.3, _, scale.wid * 1.3, scale.hei * 1.3, gui_hatA:getWidth  () / 2, gui_hatA:getHeight() / 2)
    love.graphics.printf(lang.s3_controlMovement, screen.wid * 0.625, screen.hei * 0.275, screen.wid * 0.225, "right")
    love.graphics.draw(gui_keyO, screen.wid * 0.55, screen.hei * 0.375, _, scale.wid * 1.3, scale.hei * 1.3, gui_keyO:getWidth  () / 2, gui_keyO:getHeight() / 2)
    love.graphics.draw(gui_butY, screen.wid * 0.6, screen.hei * 0.375, _, scale.wid * 1.3, scale.hei * 1.3, gui_butY:getWidth  () / 2, gui_butY:getHeight() / 2)
    love.graphics.printf(lang.s3_controlKick, screen.wid * 0.625, screen.hei * 0.35, screen.wid * 0.225, "right")
    love.graphics.draw(gui_keyI, screen.wid * 0.55, screen.hei * 0.45, _, scale.wid * 1.3, scale.hei * 1.3, gui_keyI:getWidth  () / 2, gui_keyO:getHeight() / 2)
    love.graphics.draw(gui_butX, screen.wid * 0.6, screen.hei * 0.45, _, scale.wid * 1.3, scale.hei * 1.3, gui_butX:getWidth  () / 2, gui_butY:getHeight() / 2)
    love.graphics.printf(lang.s3_controlPunch, screen.wid * 0.625, screen.hei * 0.425, screen.wid * 0.225, "right")
    love.graphics.draw(gui_keyK, screen.wid * 0.55, screen.hei * 0.525, _, scale.wid * 1.3, scale.hei * 1.3, gui_keyK:getWidth  () / 2, gui_keyK:getHeight() / 2)
    love.graphics.draw(gui_butA, screen.wid * 0.6, screen.hei * 0.525, _, scale.wid * 1.3, scale.hei * 1.3, gui_butA:getWidth  () / 2, gui_butA:getHeight() / 2)
    love.graphics.printf(lang.s3_controlJump, screen.wid * 0.625, screen.hei * 0.5, screen.wid * 0.225, "right")
    love.graphics.draw(gui_keyL, screen.wid * 0.55, screen.hei * 0.6, _, scale.wid * 1.3, scale.hei * 1.3, gui_keyL:getWidth  () / 2, gui_keyL:getHeight() / 2)
    love.graphics.draw(gui_butB, screen.wid * 0.6, screen.hei * 0.6, _, scale.wid * 1.3, scale.hei * 1.3, gui_butB:getWidth  () / 2, gui_butB:getHeight() / 2)
    love.graphics.printf(lang.s3_controlDefend, screen.wid * 0.625, screen.hei * 0.575, screen.wid * 0.225, "right")
    love.graphics.draw(gui_keyQ, screen.wid * 0.535, screen.hei * 0.675, _, scale.wid * 1, scale.hei * 1, gui_keyQ:getWidth  () / 2, gui_keyQ:getHeight() / 2)
    love.graphics.draw(gui_keyE, screen.wid * 0.565, screen.hei * 0.675, _, scale.wid * 1, scale.hei * 1, gui_keyE:getWidth  () / 2, gui_keyE:getHeight() / 2)
    love.graphics.draw(gui_bumL, screen.wid * 0.605, screen.hei * 0.675, _, scale.wid * 1, scale.hei * 1, gui_bumL:getWidth  () / 2, gui_bumL:getHeight() / 2)
    love.graphics.draw(gui_bumR, screen.wid * 0.65, screen.hei * 0.675, _, scale.wid * 1, scale.hei * 1, gui_bumR:getWidth  () / 2, gui_bumR:getHeight() / 2)
    love.graphics.printf(lang.s3_controlDash, screen.wid * 0.625, screen.hei * 0.65, screen.wid * 0.225, "right")
    love.graphics.draw(gui_esc, screen.wid * 0.55, screen.hei * 0.75, _, scale.wid * 1.3, scale.hei * 1.3, gui_keyL:getWidth  () / 2, gui_keyL:getHeight() / 2)
    if temp_settings.backAsStart then
        love.graphics.draw(gui_back, screen.wid * 0.6, screen.hei * 0.75, _, scale.wid * 1.3, scale.hei * 1.3, gui_back:getWidth  () / 2, gui_back:getHeight() / 2)
    else
        love.graphics.draw(gui_start, screen.wid * 0.6, screen.hei * 0.75, _, scale.wid * 1.3, scale.hei * 1.3, gui_start:getWidth  () / 2, gui_start:getHeight() / 2)
    end
    love.graphics.printf(lang.s3_controlPause, screen.wid * 0.625, screen.hei * 0.725, screen.wid * 0.225, "right")


    if options_confirmation then
        love.graphics.setColor(0, 0, 0, 127)
        love.graphics.rectangle("fill", 0, 0, screen.wid, screen.hei)
        love.graphics.setColor(32, 32, 32, 223)
        love.graphics.rectangle("fill", 0, (screen.hei / 3), screen.wid, (screen.hei / 3))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.s3_applySettings, 0, screen.hei * 0.4, screen.wid, "center")
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
        love.graphics.printf(lang.s3_apply, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
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
function options_changeSelected(dir)
    if dir == "up" then
        options_selected = options_selected - 1
        if options_selected < 1 then
            options_selected = 7
        end
    elseif dir == "down" then
        options_selected = options_selected + 1
        if options_selected > 7 then
            options_selected = 1
        end
    else
        options_selected = dir
    end
end

--[[    Change the value of the selection
(dir: set if increment or decrement the option["+"/"-"], number: the number of the option to be changed)
]]
function options_changeValue(dir, number)
    if number == 1 then --round time
        if dir == "+" then
            if temp_settings.roundTime == "~" then
                temp_settings.roundTime = "~"
            else
                temp_settings.roundTime = temp_settings.roundTime + 30
                if temp_settings.roundTime > 300 then
                    temp_settings.roundTime = "~"
                end
            end
        elseif dir == "-" then
            if temp_settings.roundTime == "~" then
                temp_settings.roundTime = 300
            else
                temp_settings.roundTime = temp_settings.roundTime - 30
                if temp_settings.roundTime < 30 then
                    temp_settings.roundTime = 30
                end
            end
        end
    elseif number == 2 then --rounds to win
        if dir == "+" then
            temp_settings.roundsToWin = temp_settings.roundsToWin + 1
            if temp_settings.roundsToWin > 5 then
                temp_settings.roundsToWin = 5
            end
        elseif dir == "-" then
            temp_settings.roundsToWin = temp_settings.roundsToWin - 1
            if temp_settings.roundsToWin < 1 then
                temp_settings.roundsToWin = 1
            end
        end
    elseif number == 3 then --back as start
        if dir == "+" then
            temp_settings.backAsStart = true
        elseif dir == "-" then
            temp_settings.backAsStart = false
        end
    elseif number == 4 then --language
        if dir == "+" then
            temp_settings.language = temp_settings.language + 1
            if temp_settings.language > table.getn(lang_names) then
                temp_settings.language = table.getn(lang_names)
            end
        elseif dir == "-" then
            temp_settings.language = temp_settings.language - 1
            if temp_settings.language < 1 then
                temp_settings.language = 1
            end
        end
    elseif number == 5 then --master volume
        if dir == "+" then
            temp_settings.volMaster = temp_settings.volMaster + 0.05
            if temp_settings.volMaster > 1 then
                temp_settings.volMaster = 1
            end
        elseif dir == "-" then
            temp_settings.volMaster = temp_settings.volMaster - 0.05
            if temp_settings.volMaster < 0.05 then
                temp_settings.volMaster = 0
            end
        end
    elseif number == 6 then --music volume
        if dir == "+" then
            temp_settings.volMusic = temp_settings.volMusic + 0.05
            if temp_settings.volMusic > 1 then
                temp_settings.volMusic = 1
            end
        elseif dir == "-" then
            temp_settings.volMusic = temp_settings.volMusic - 0.05
            if temp_settings.volMusic < 0.05 then
                temp_settings.volMusic = 0
            end
        end
    elseif number == 7 then --game volume
        if dir == "+" then
            temp_settings.volGame = temp_settings.volGame + 0.05
            if temp_settings.volGame > 1 then
                temp_settings.volGame = 1
            end
        elseif dir == "-" then
            temp_settings.volGame = temp_settings.volGame - 0.05
            if temp_settings.volGame < 0.05 then
                temp_settings.volGame = 0
            end
        end
    end
end