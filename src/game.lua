--[[    Update the game loading screen variables
    (dt: delta-time from "love.update(dt)")
]]
function gameloading_update(dt)

    --timer
    if chrono.reset then
        chrono.start = love.timer.getTime() 
        chrono.reset = false
        chrono.actual = 0
        chrono.passed = 0
    end

    --background audio
    if sfx_bgm:isPlaying() then
        audio_stop(sfx_bgm)
    end

    if not isLoading then
        isLoading = true
        game_load()
        isReady = true
    end
    if isReady then
        screen_setState(7)
    end

    chrono.actual = love.timer.getTime()
    chrono.passed = chrono.actual - chrono.start
end

--[[    Draw the game loading screen in the screen
]]
function gameloading_draw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_background_alt, screen.wid / 2, screen.hei / 2, _, scale.wid * 1.1, scale.hei * 1.1, gui_background_alt:getWidth() / 2, gui_background_alt:getHeight() / 2)
    love.graphics.draw(gui_char[char_selected.p1].big, screen.wid * 0.15, screen.hei * 0.635, _, scale.wid, scale.hei, gui_char[char_selected.p1].big:getWidth() / 2, gui_char[char_selected.p1].big:getHeight() / 2)
    love.graphics.draw(gui_char[char_selected.p2].big, screen.wid * 0.85, screen.hei * 0.635, _, -scale.wid, scale.hei, gui_char[char_selected.p2].big:getWidth() / 2, gui_char[char_selected.p2].big:getHeight() / 2)
    love.graphics.setFont(font_type.edosz1)
    love.graphics.printf(lang.s0_loading, 0, screen.hei*0.8, screen.wid, "center")
    love.graphics.draw(gui_logo, (screen.wid/2), (screen.hei * 0.4), _, scale.wid * 0.75, scale.hei * 0.75, gui_logo:getWidth() / 2, gui_logo:getHeight() / 2)
end

--[[    Load all the resources needed to run the game
]]
function game_load()

    require "AnimatedSprite"

    VEL_WALK = 250
    VEL_DASH = 1000
    VEL_JUMP = -750
    HIT_DISTANCE = p_hit_distance()
    FAR_DISTANCE = p_get_distance(1050)
    MED_DISTANCE = p_get_distance(700)
    CLO_DISTANCE = p_get_distance(350)

    ia_wait = {t = 0, reason = ""}

    y_base = screen.hei * 0.65

    p1_inst = {
        instance = GetInstance ("gui/chars/sprite/ninja" .. player[1].character .. ".lua"),
        health = 100, status = "idle", pos_x = screen.wid * 0.2, pos_y = y_base, vel_x = 0, vel_y = 0, 
        dir = 1, t = 0, pause_anim = false
    }
    p2_inst = {
        instance = GetInstance ("gui/chars/sprite/ninja" .. player[2].character .. ".lua"),
        health = 100, status = "idle", pos_x = screen.wid * 0.8, pos_y = y_base, vel_x = 0, vel_y = 0, 
        dir = -1, t = 0, pause_anim = false
    }

    --game variables
    game.roundTime = settings.roundTime
    game.roundsToWin = settings.roundsToWin
    player[1].c_left = false    player[2].c_left = false
    player[1].c_right = false   player[2].c_right = false
    player[1].c_up = false      player[2].c_up = false
    player[1].c_down = false    player[2].c_down = false
    player[1].c_a = false       player[2].c_a = false
    player[1].c_b = false       player[2].c_b = false
    player[1].c_x = false       player[2].c_x = false
    player[1].c_y = false       player[2].c_y = false
    player[1].c_back = false    player[2].c_back = false
    player[1].c_start = false   player[2].c_start = false
    player[1].c_bumpR = false   player[2].c_bumpR = false
    player[1].c_bumpL = false   player[2].c_bumpL = false
    player[1].rounds = 0        player[2].rounds = 0
    player[1].axis_x = 0        player[2].axis_x = 0
    player[1].axis_y = 0        player[2].axis_y = 0
    player[1].var = p1_inst     player[2].var = p2_inst

    time = game.roundTime
    countdown = 3
    screenTime = time
    gameState = "countdown" --[["countdown" "playing" "paused" "roundEnded" "ended"]]
    prev_gameState = ""
    roundCount = 0
    new_round_text = "-"

    gui_countdownBG = love.graphics.newImage("gui/countdown_bg.png")
    gui_barsBG = love.graphics.newImage("gui/bars_bg.png")
    gui_round = love.graphics.newImage("gui/round_point.png")

    game_selected = 1

    dash_sound = {vol = settings.volMaster * settings.volGame, pit = 1, loop = false}
    punch_sound = {vol = settings.volMaster * settings.volGame, pit = 1, loop = false}
    hit_sound = {vol = settings.volMaster * settings.volGame, pit = 1, loop = false}
    jump_sound = {vol = settings.volMaster * settings.volGame, pit = 1, loop = false}
    defend_sound = {vol = settings.volMaster * settings.volGame, pit = 1, loop = false}
    sfx_dash = love.audio.newSource("sfx/effects/dash.ogg")
    sfx_punch = love.audio.newSource("sfx/effects/punch.ogg")
    sfx_hit = love.audio.newSource("sfx/effects/hit.ogg")
    sfx_jump = love.audio.newSource("sfx/effects/jump.ogg")
    sfx_defend = love.audio.newSource("sfx/effects/defend.ogg")

    gbgm = {vol = 0.5 * settings.volMusic * settings.volMaster, i = 0, n = 4}
    voice = {vol = 1 * settings.volMaster * settings.volGame, pit = 1, loop = false, s = ""}
    sfx_timeup = love.audio.newSource("sfx/voice/timeup.ogg")
    sfx_newround = love.audio.newSource("sfx/voice/newround.ogg")
    sfx_fight = love.audio.newSource("sfx/voice/fight.ogg")
    sfx_won = love.audio.newSource("sfx/voice/won.ogg")

    sfx_bgm_game = {}
    sfx_round = {}
    for i = 1, gbgm.n, 1 do
        table.insert(sfx_bgm_game, love.audio.newSource("sfx/bgm/" .. i .. ".ogg"))        
    end
    for i = 1, 9, 1 do
        table.insert(sfx_round, love.audio.newSource("sfx/voice/round" .. i .. ".ogg"))
    end

    sfx_playing = nil
    --gbgm.i = math.random(1, 7)
    gbgm.i = math.random(1, gbgm.n)
    --audio_play(sfx_bgm_game[gbgm.i], gbgm.vol, 1, true)
    sfx_playing = sfx_bgm_game[gbgm.i]
end

--[[    Update the game variables
(dt: delta-time from "love.update(dt)")
]]
function game_update(dt)
    if gameState == "countdown" then
        countdown = countdown - dt
        if countdown <= 0 then
            voice.s = ""
            gameState = "playing"
        end

        if countdown <= 3 and countdown > 1 and voice.s == "" then
            voice.s = "round"
            audio_play(sfx_round[roundCount + 1], voice.vol, voice.pit, voice.loop, true)
        elseif countdown <= 1 and countdown > 0 and voice.s == "round" then
            voice.s = "fight"
            audio_play(sfx_fight, voice.vol, voice.pit, voice.loop, true)
        end

        if not sfx_playing:isPlaying() then
            gbgm.i = math.random(1, gbgm.n)
            --audio_play(sfx_bgm_game[gbgm.i], gbgm.vol, 1, true)
            sfx_playing = sfx_bgm_game[gbgm.i]
            audio_play(sfx_playing, gbgm.vol, 1, false, true)
        end

        sfx_playing:setVolume(gbgm.vol/3)

        update_player(player[1], dt)
        update_player(player[2], dt)

    elseif gameState == "playing" then
        if time ~= "~" then 
            time = time - dt
            screenTime = time - (time % 1) + 1
        end
        if game.playerCount == 1 then
            game_ia(player[1], player[2])
        end
        if ia_wait.t > 0 then
            ia_wait.t = ia_wait.t - dt
        end

        if not sfx_playing:isPlaying() then
            tmp = math.random(1, gbgm.n)
            while gbgm.i == tmp do
                tmp = math.random(1, gbgm.n)
            end
            gbgm.i = tmp 

            --audio_play(sfx_bgm_game[gbgm.i], gbgm.vol, 1, true)
            sfx_playing = sfx_bgm_game[gbgm.i]
            audio_play(sfx_playing, gbgm.vol, 1, false, true)
        end

        sfx_playing:setVolume(gbgm.vol)

        update_player(player[1], dt)
        update_player(player[2], dt)

        update_game(dt)

        if screenTime == 0 then
            if player[1].var.health > player[2].var.health then
                player[1].rounds = player[1].rounds + 1
                if game.roundsToWin == player[1].rounds then
                    winner = char_names[player[1].character]
                    change_status(player[2], "dead")
                    audio_play(sfx_won, voice.vol/2, voice.pit, voice.loop, true)
                    gameState = "ended"
                else
                    new_round_text = lang.s7_time_up
                    change_status(player[2], "dead")
                    audio_play(sfx_timeup, voice.vol, voice.pit, voice.loop, true)
                    gameState = "roundEnded"
                end
            elseif player[2].var.health > player[1].var.health then
                player[2].rounds = player[2].rounds + 1
                if game.roundsToWin == player[2].rounds then
                    winner = char_names[player[2].character]
                    change_status(player[1], "dead")
                    audio_play(sfx_won, voice.vol/2, voice.pit, voice.loop, true)
                    gameState = "ended"
                else
                    new_round_text = lang.s7_time_up
                    change_status(player[1], "dead")
                    audio_play(sfx_timeup, voice.vol, voice.pit, voice.loop, true)
                    gameState = "roundEnded"
                end
            else
                new_round_text = lang.s7_time_up
                audio_play(sfx_timeup, voice.vol, voice.pit, voice.loop, true)
                new_round(false)
                countdown = 4
            end
        end
    elseif gameState == "paused" then
        if player[1].c_start or player[2].c_start then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            gameState = prev_gameState
            prev_gameState = ""
            player[1].c_start = false
            player[2].c_start = false
        end
        if player[1].c_up or player[2].c_up then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            game_changeSelected("up")
            player[1].c_up = false
            player[2].c_up = false
        end
        if player[1].c_down or player[2].c_down then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            game_changeSelected("down")
            player[1].c_down = false
            player[2].c_down = false
        end
        if player[1].c_a or player[2].c_a then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            player[1].c_a = false
            player[2].c_a = false
            if game_selected == 1 then -- resume
                gameState = prev_gameState
                prev_gameState = ""
            elseif game_selected == 2 then --reset
                player[1].character = nil
                player[2].character = nil
                game.arena = nil
                charsel_load()
                audio_stop(sfx_bgm_game[gbgm.i])
                screen_setState(5)
            elseif game_selected == 3 then --main menu
                menu_load()
                options_load()
                audio_stop(sfx_bgm_game[gbgm.i])
                screen_setState(1)
            end
        end
    elseif gameState == "roundEnded" then
        update_player(player[1], dt)
        update_player(player[2], dt)

        sfx_playing:setVolume(gbgm.vol/3)
    elseif gameState == "ended" then

        if gbgm.i ~= 0 then
            if sfx_bgm_game[gbgm.i]:isPlaying() then
                audio_stop(sfx_bgm_game[gbgm.i])
                gbgm.i = 0
            end
        end

        update_player(player[1], dt)
        update_player(player[2], dt)

        if player[1].c_up or player[2].c_up then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            game_changeSelected("up")
            player[1].c_up = false
            player[2].c_up = false
        end
        if player[1].c_down or player[2].c_down then
            audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
            game_changeSelected("down")
            player[1].c_down = false
            player[2].c_down = false
        end
        if player[1].c_a or player[2].c_a then
            audio_play(sfx_selection, sel.vol, sel.pit, sel.loop, true)
            player[1].c_a = false
            player[2].c_a = false
            if game_selected == 1 then -- rematch
                new_round(true)
            elseif game_selected == 2 then --reset
                player[1].character = nil
                player[2].character = nil
                game.arena = nil
                charsel_load()
                audio_stop(sfx_bgm_game[gbgm.i])
                screen_setState(5)
            elseif game_selected == 3 then --main menu
                menu_load()
                options_load()
                audio_stop(sfx_bgm_game[gbgm.i])
                screen_setState(1)
            end
        end
    end  
end

--[[    Updates the players variables including controller actions and the sprite animation and status
(player: player table, dt: delta-time from "love.update(dt)")
]]
function update_player(player, dt)
    if player.c_start and (gameState == "countdown" or gameState == "playing" or gameState == "roundEnded") then
        audio_play(sfx_option, opt.vol, opt.pit, opt.loop, true)
        prev_gameState = gameState
        gameState = "paused"
        player.c_start = false
    end
    if gameState == "playing" then
        if player.var.t > 0 then
            player.var.t = player.var.t - dt
        elseif player.var.t ~= 0 then
            player.var.t = 0
        end

        if player.c_up then

        end
        if player.c_down and (player.var.status == "walk" or player.var.status == "idle") then
            if player.var.status ~= "crouch" then
                player.var.vel_x = 0
                change_status(player, "crouch")
            end
        elseif player.var.status == "crouch" and not player.c_down then
            change_status(player, "idle")
        end

        if player.c_left and (player.var.status == "walk" or player.var.status == "idle") and not player.c_right then
            player.var.dir = -1
            player.var.vel_x = VEL_WALK
            if player.var.status ~= "walk" then
                change_status(player, "walk")
            end
        end
        if player.c_right and (player.var.status == "walk" or player.var.status == "idle") and not player.c_left then
            player.var.dir = 1
            player.var.vel_x = VEL_WALK
            if player.var.status ~= "walk" then
                change_status(player, "walk")
            end
        end
        if player.var.status == "walk" and not (player.c_left or player.c_right) then
            player.var.vel_x = 0
            change_status(player, "idle")
        end

        if (player.var.status == "jump" or player.var.status == "dash" or player.var.status == "punch" or player.var.status == "kick" or player.var.status == "defend" or player.var.status == "hurt") and get_animation_end(player) then
            player.var.vel_x = 0
            change_status(player, "idle")
        end

        if (player.var.status == "crouchpunch" or player.var.status == "crouchkick") and get_animation_end(player) then
            if player.c_down then
                player.var.vel_x = 0
                change_status(player, "crouch")
            else
                player.var.vel_x = 0
                change_status(player, "idle")
            end
        end


        if player.c_a and player.var.t <= 2 and (player.var.status == "walk" or player.var.status == "idle") then -- jump
            player.var.vel_y = VEL_JUMP
            player.var.t = player.var.t + 3
            audio_play(sfx_jump, jump_sound.vol, jump_sound.pit, jump_sound.loop, false)
            change_status(player, "jump")
        end
        if player.c_b and player.var.t < 4 and (player.var.status == "walk" or player.var.status == "idle") then -- defend
            player.var.vel_x = 0
            player.var.t  = player.var.t + (dt * 10)
            change_status(player, "defend")
        elseif player.c_b and player.var.t < 5 and player.var.status == "defend" then
            player.var.instance.curr_frame = 4
            player.var.t  = player.var.t + (dt * 10)
            player.var.pause_anim = true
        else
            player.var.pause_anim = false
        end
        if player.c_x and (player.var.status == "walk" or player.var.status == "idle" or player.var.status == "crouch") then -- punch
            if player.c_down then
                player.var.vel_x = 0
                audio_play(sfx_punch, punch_sound.vol, punch_sound.pit, punch_sound.loop, false)
                change_status(player, "crouchpunch")
            else
                player.var.vel_x = 0
                audio_play(sfx_punch, punch_sound.vol, punch_sound.pit, punch_sound.loop, false)
                change_status(player, "punch")
            end
        end
        if player.c_y and (player.var.status == "walk" or player.var.status == "idle" or player.var.status == "crouch") then -- kick
            if player.c_down then
                player.var.vel_x = 0
                audio_play(sfx_punch, punch_sound.vol, punch_sound.pit, punch_sound.loop, false)
                change_status(player, "crouchkick")
            else
                player.var.vel_x = 0
                audio_play(sfx_punch, punch_sound.vol, punch_sound.pit, punch_sound.loop, false)
                change_status(player, "kick")
            end
        end

        if player.c_bumpL and player.var.t == 0 and (player.var.status == "walk" or player.var.status == "idle" or player.var.status == "crouch") then -- dash
            player.var.dir = 1
            player.var.t = 5
            player.var.vel_x = VEL_DASH
            audio_play(sfx_dash, dash_sound.vol, dash_sound.pit, dash_sound.loop, false)
            change_status(player, "dash")
        end
        if player.c_bumpR and player.var.t == 0 and (player.var.status == "walk" or player.var.status == "idle" or player.var.status == "crouch") then -- dash
            player.var.dir = -1
            player.var.t = 5
            player.var.vel_x = VEL_DASH
            audio_play(sfx_dash, dash_sound.vol, dash_sound.pit, dash_sound.loop, false)
            change_status(player, "dash")
        end

        player.var.pos_x = player.var.pos_x + (player.var.dir * dt * player.var.vel_x * scale.wid)
        player.var.pos_y = player.var.pos_y + (dt * player.var.vel_y * scale.hei)

        if player.var.pos_y < y_base then
            player.var.vel_y = player.var.vel_y + dt * 1000
        else
            player.var.vel_y = 0
            player.var.pos_y = y_base
        end

        player.c_a = false    
        --player.c_b = false    
        player.c_x = false    
        player.c_y = false    
        player.c_back = false 
        player.c_start = false
        player.c_bumpR = false
        player.c_bumpL = false
    end
    if gameState == "ended" or gameState == "roundEnded" then
        if player.var.status == "dead" and get_animation_end(player) then
            player.var.pause_anim = true
            if gameState == "roundEnded" then
                new_round(false)
            end
        elseif player.var.status ~= "dead" and get_animation_end(player) then
            change_status(player, "idle")
        end
        player.var.pos_x = player.var.pos_x + (player.var.dir * dt * player.var.vel_x * scale.wid)
        player.var.pos_y = player.var.pos_y + (dt * player.var.vel_y * scale.hei)

        if player.var.pos_y < y_base then
            player.var.vel_y = player.var.vel_y + dt * 1000
        else
            player.var.vel_y = 0
            player.var.vel_x = 0
            player.var.pos_y = y_base
        end
    end

    UpdateInstance(player.var.instance, dt, player.var.pause_anim)
end

--[[    Updates the games variables for example colision, tests for the round and game winner
(dt: delta-time from "love.update(dt)")
]]
function update_game(dt)
    if player[1].var.pos_x < (240 * scale.wid) then
        player[1].var.pos_x = (240 * scale.wid)
    end
    if player[2].var.pos_x < (240 * scale.wid) then
        player[2].var.pos_x = (240 * scale.wid)
    end
    if player[1].var.pos_x > screen.wid - (240 * scale.wid) then
        player[1].var.pos_x = screen.wid - (240 * scale.wid)
    end
    if player[2].var.pos_x > screen.wid - (240 * scale.wid) then
        player[2].var.pos_x = screen.wid - (240 * scale.wid)
    end

    math.randomseed(dt)
    luck = math.random(2)

    if luck == 1 then
        collision(player[1], player[2])
        collision(player[2], player[1])
    elseif luck == 2 then
        collision(player[2], player[1])
        collision(player[1], player[2])
    end

    if player[1].var.health <= 0 then
        player[1].var.health = 0
        player[2].rounds = player[2].rounds + 1
        if game.roundsToWin == player[2].rounds then
            winner = char_names[player[2].character]
            change_status(player[1], "dead")
            audio_play(sfx_won, voice.vol/2, voice.pit, voice.loop, true)
            gameState = "ended"
        else
            new_round_text = lang.s7_newRound
            change_status(player[1], "dead")
            audio_play(sfx_newround, voice.vol, voice.pit, voice.loop, true)
            gameState = "roundEnded"
        end
    end
    if player[2].var.health <= 0 then
        player[2].var.health = 0
        player[1].rounds = player[1].rounds + 1
        if game.roundsToWin == player[1].rounds then
            winner = char_names[player[1].character]
            change_status(player[2], "dead")
            audio_play(sfx_won, voice.vol/2, voice.pit, voice.loop, true)
            gameState = "ended"
        else
            new_round_text = lang.s7_newRound
            change_status(player[2], "dead")
            audio_play(sfx_newround, voice.vol, voice.pit, voice.loop, true)
            gameState = "roundEnded"
        end
    end
end

--[[    Function to do the hits work
(ref_player: the reference player, target_player: the target player)
]]
function collision(ref_player, target_player)
    dist = p_distance(ref_player, target_player)

    if dist <= HIT_DISTANCE and dist > HIT_DISTANCE / 3 and is_looking(ref_player, target_player) then --if the players are close enough, and not too close, to hit each other
        if target_player.var.status ~= "hurt" and ref_player.var.status == "punch" and ref_player.var.instance.curr_frame == 5 and target_player.var.status ~= "jump" and target_player.var.status ~= "dash" then
            if target_player.var.status == "defend" then
                audio_play(sfx_defend, defend_sound.vol, defend_sound.pit, defend_sound.loop, false)
            else
                audio_play(sfx_hit, hit_sound.vol, hit_sound.pit, hit_sound.loop, false)
                change_status(target_player, "hurt")
                target_player.var.vel_x = 0
                target_player.var.vel_y = 0
                target_player.var.health = target_player.var.health - (dist / 25)
                target_player.var.pause_anim = false
            end
        end
        if target_player.var.status ~= "hurt" and ref_player.var.status == "kick" and ref_player.var.instance.curr_frame == 5 and target_player.var.status ~= "jump" and target_player.var.status ~= "dash" then
            if target_player.var.status == "defend" then
                audio_play(sfx_defend, defend_sound.vol, defend_sound.pit, defend_sound.loop, false)
            else
                audio_play(sfx_hit, hit_sound.vol, hit_sound.pit, hit_sound.loop, false)
                change_status(target_player, "hurt")
                target_player.var.vel_x = 0
                target_player.var.vel_y = 0
                target_player.var.health = target_player.var.health - (dist / 25)
                target_player.var.pause_anim = false
            end
        end
        if target_player.var.status ~= "hurt" and ref_player.var.status == "crouchpunch" and ref_player.var.instance.curr_frame == 5 and target_player.var.status ~= "jump" and target_player.var.status ~= "dash" then
            audio_play(sfx_hit, hit_sound.vol, hit_sound.pit, hit_sound.loop, false)
            change_status(target_player, "hurt")
            target_player.var.vel_x = 0
            target_player.var.vel_y = 0
            target_player.var.health = target_player.var.health - (dist / 50)
            target_player.var.pause_anim = false
        end
        if target_player.var.status ~= "hurt" and ref_player.var.status == "crouchkick" and ref_player.var.instance.curr_frame == 4 and target_player.var.status ~= "jump" and target_player.var.status ~= "dash" then
            audio_play(sfx_hit, hit_sound.vol, hit_sound.pit, hit_sound.loop, false)
            change_status(target_player, "hurt")
            target_player.var.vel_x = 0
            target_player.var.vel_y = 0
            target_player.var.health = target_player.var.health - (dist / 50)
            target_player.var.pause_anim = false
        end
    end
end

--[[    Handle when some key has pressed
(key: key code)
]]
function game_keypressed(key)
    if player[1].controller == "keyboard" then
        if key == "a" or key == "left" then
            player[1].c_left = true
            player[1].c_right = false
        end
        if key == "d" or key == "right" then
            player[1].c_right = true
            player[1].c_left = false
        end
        if key == "w" or key == "up" then
            player[1].c_up = true
        end
        if key == "s" or key == "down" then
            player[1].c_down = true
        end
        if key == "k" then
            player[1].c_a = true
        end
        if key == "l" then
            player[1].c_b = true
        end
        if key == "i" then
            player[1].c_x = true
        end
        if key == "o" then
            player[1].c_y = true
        end
        if key == "q" then
            player[1].c_bumpR = true
        end
        if key == "e" then
            player[1].c_bumpL = true
        end
    end
    if player[2].controller == "keyboard" then
        if key == "a" then
            player[2].c_left = true
        end
        if key == "d" then
            player[2].c_right = true
        end
        if key == "w" then
            player[2].c_up = true
        end
        if key == "s" then
            player[2].c_down = true
        end
        if key == "k" then
            player[2].c_a = true
        end
        if key == "l" then
            player[2].c_b = true
        end
        if key == "i" then
            player[2].c_x = true
        end
        if key == "o" then
            player[2].c_y = true
        end
        if key == "q" then
            player[2].c_bumpR = true
        end
        if key == "e" then
            player[2].c_bumpL = true
        end
    end
end

--[[    Handle when some key has released
(key: key code)
]]
function game_keyreleased(key)
    if player[1].controller == "keyboard" then
        if key == "a" or key == "left"  then
            player[1].c_left = false
        end
        if key == "d" or key == "right"  then
            player[1].c_right = false
        end
        if key == "w" or key == "up"  then
            player[1].c_up = false
        end
        if key == "s" or key == "down"  then
            player[1].c_down = false
        end
        if key == "l" then
            player[1].c_b = false
        end
        if key == "escape" then
            player[1].c_start = true
        end
        if gameState == "paused" or gameState == "ended" then
            if key == "return" then
                player[1].c_a = true
            end
        end
    end
    if player[2].controller == "keyboard" then
        if key == "a" then
            player[2].c_left = false
        end
        if key == "d" then
            player[2].c_right = false
        end
        if key == "w" then
            player[2].c_up = false
        end
        if key == "s" then
            player[2].c_down = false
        end
        if key == "l" then
            player[2].c_b = false
        end
        if key == "escape" then
            player[2].c_start = true
        end
        if gameState == "paused" or gameState == "ended" then
            if key == "return" then
                player[2].c_a = true
            end
        end
    end
end

--[[    Handle when some gamepad button has pressed
(gamepad: gamepad object, key: button code)
]]
function game_gamepadpressed(gamepad, key)
    if player[1].controller == gamepad then
        if key == "dpleft" then
            player[1].c_left = true
        end
        if key == "dpright" then
            player[1].c_right = true
        end
        if key == "dpup" then
            player[1].c_up = true
        end
        if key == "dpdown" then
            player[1].c_down = true
        end
        if key == "a" and gameState == "playing" then
            player[1].c_a = true
        end
        if key == "b" then
            player[1].c_b = true
        end
        if key == "x" then
            player[1].c_x = true
        end
        if key == "y" then
            player[1].c_y = true
        end
        if key == "leftshoulder" then
            player[1].c_bumpR = true
        end
        if key == "rightshoulder" then
            player[1].c_bumpL = true
        end
    end
    if player[2].controller == gamepad then
        if key == "dpleft" then
            player[2].c_left = true
        end
        if key == "dpright" then
            player[2].c_right = true
        end
        if key == "dpup" then
            player[2].c_up = true
        end
        if key == "dpdown" then
            player[2].c_down = true
        end
        if key == "a" and gameState == "playing" then
            player[2].c_a = true
        end
        if key == "b" then
            player[2].c_b = true
        end
        if key == "x" then
            player[2].c_x = true
        end
        if key == "y" then
            player[2].c_y = true
        end
        if key == "leftshoulder" then
            player[2].c_bumpR = true
        end
        if key == "rightshoulder" then
            player[2].c_bumpL = true
        end
    end
end

--[[    Handle when some gamepad button has released
(gamepad: gamepad object, key: button code)
]]
function game_gamepadreleased(gamepad, key)
    if player[1].controller == gamepad then
        if key == "dpleft" then
            player[1].c_left = false
        end
        if key == "dpright" then
            player[1].c_right = false
        end
        if key == "dpup" then
            player[1].c_up = false
        end
        if key == "dpdown" then
            player[1].c_down = false
        end
        if key == "b" then
            player[1].c_b = false
        end
        if settings.backAsStart then
            if key == "back" then
                player[1].c_start = true
            end
        else
            if key == "start" then
                player[1].c_start = true
            end
        end
        if gameState == "paused" or gameState == "ended" then
            if key == "a" then
                player[1].c_a = true
            end
        end
    end
    if player[2].controller == gamepad then
        if key == "dpleft" then
            player[2].c_left = false
        end
        if key == "dpright" then
            player[2].c_right = false
        end
        if key == "dpup" then
            player[2].c_up = false
        end
        if key == "dpdown" then
            player[2].c_down = false
        end
        if key == "b" then
            player[2].c_b = false
        end
        if settings.backAsStart then
            if key == "back" then
                player[2].c_start = true
            end
        else
            if key == "start" then
                player[2].c_start = true
            end
        end
        if gameState == "paused" or gameState == "ended" then
            if key == "a" then
                player[2].c_a = true
            end
        end
    end
end

--[[    Draw the game in the screen
]]
function game_draw()
    --love.graphics.setBackgroundColor(255,0,255)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(gui_arena[game.arena].big, screen.wid * 0.5, screen.hei * 0.5, _, scale.wid, scale.hei, gui_arena[arena_selected].big:getWidth() / 2, gui_arena[arena_selected].big:getHeight() / 2)
    love.graphics.draw(gui_barsBG, screen.wid * 0.5, 0, _, scale.wid, scale.hei, gui_barsBG:getWidth() / 2, _)
    love.graphics.draw(gui_char[player[1].character].thumb, screen.wid * 0.06, screen.hei * 0.1, _, scale.wid, scale.hei, gui_char[player[1].character].thumb:getWidth() / 2, gui_char[player[1].character].thumb:getHeight() / 2)
    love.graphics.draw(gui_char[player[2].character].thumb, screen.wid * 0.94, screen.hei * 0.1, _, -scale.wid, scale.hei, gui_char[player[2].character].thumb:getWidth() / 2, gui_char[player[2].character].thumb:getHeight() / 2)
    love.graphics.setFont(font_type.edosz3)
    love.graphics.printf(char_names[player[1].character], screen.wid * 0.03, screen.hei * 0.01, screen.wid * 0.2, "left")
    love.graphics.printf(char_names[player[2].character], screen.wid * 0.77, screen.hei * 0.01, screen.wid * 0.2, "right")
    if player[1].rounds >= 1 then
        love.graphics.draw(gui_round, screen.wid * 0.41, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
        if player[1].rounds >= 2 then
            love.graphics.draw(gui_round, screen.wid * 0.39, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
            if player[1].rounds >= 3 then
                love.graphics.draw(gui_round, screen.wid * 0.37, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
                if player[1].rounds >= 4 then
                    love.graphics.draw(gui_round, screen.wid * 0.35, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
                    if player[1].rounds == 5 then
                        love.graphics.draw(gui_round, screen.wid * 0.33, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
                    end
                end
            end
        end
    end
    if player[2].rounds >= 1 then
        love.graphics.draw(gui_round, screen.wid * 0.59, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
        if player[2].rounds >= 2 then
            love.graphics.draw(gui_round, screen.wid * 0.61, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
            if player[2].rounds >= 3 then
                love.graphics.draw(gui_round, screen.wid * 0.63, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
                if player[2].rounds >= 4 then
                    love.graphics.draw(gui_round, screen.wid * 0.65, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
                    if player[2].rounds == 5 then
                        love.graphics.draw(gui_round, screen.wid * 0.67, screen.hei * 0.13, _, scale.wid, scale.hei, gui_round:getWidth() / 2, gui_round:getHeight() / 2)
                    end
                end
            end
        end
    end

    love.graphics.setColor(127, 32, 0)
    love.graphics.rectangle("fill", (screen.wid * 0.13), (screen.hei * 0.08), (screen.wid * 0.3), (screen. hei * 0.03))
    love.graphics.rectangle("fill", (screen.wid * 0.57), (screen.hei * 0.08), (screen.wid * 0.3), (screen. hei * 0.03))
    love.graphics.setColor(255, 64, 0)
    love.graphics.rectangle("fill", (screen.wid * 0.13), (screen.hei * 0.08), (screen.wid * 0.3) * (player[1].var.health / 100), (screen. hei * 0.03))
    love.graphics.rectangle("fill", (screen.wid * 0.57) + ((screen.wid * 0.3) * ((100 - player[2].var.health) / 100)), (screen.hei * 0.08), (screen.wid * 0.3) * (player[2].var.health / 100), (screen. hei * 0.03))

    love.graphics.setColor(64, 64, 64)
    love.graphics.rectangle("fill", (screen.wid * 0.13), (screen.hei * 0.125), (screen.wid * 0.15), (screen. hei * 0.01))
    love.graphics.rectangle("fill", (screen.wid * 0.72), (screen.hei * 0.125), (screen.wid * 0.15), (screen. hei * 0.01))
    love.graphics.setColor(255, 255, 255)
    rev_t = 5 - player[1].var.t
    if rev_t > 5 then
        rev_t = 5
    elseif rev_t < 0 then
        rev_t = 0
    end
    love.graphics.rectangle("fill", (screen.wid * 0.13), (screen.hei * 0.125), (screen.wid * 0.15) * (rev_t / 5), (screen. hei * 0.01))
    rev_t = 5 - player[2].var.t
    if rev_t > 5 then
        rev_t = 5
    elseif rev_t < 0 then
        rev_t = 0
    end
    love.graphics.rectangle("fill", (screen.wid * 0.72) + ((screen.wid * 0.15) * ((5 - rev_t) / 5)), (screen.hei * 0.125), (screen.wid * 0.15) * (rev_t / 5), (screen. hei * 0.01))

    if time ~= "~" then
        if screenTime <= game.roundTime / 4 or screenTime <= 10 then
            love.graphics.setColor(255, 64, 0)
        elseif screenTime <= game.roundTime / 2 or screenTime <= 20 then
            love.graphics.setColor(255, 210, 77)
        else
            love.graphics.setColor(255,255,255)
        end
        love.graphics.setFont(font_type.drje2)
        love.graphics.printf(screenTime, screen.wid * 0.1, screen.hei * 0.075, screen.wid * 0.8, "center")
    else
        love.graphics.setColor(255,255,255)
        love.graphics.setFont(font_type.drje2)
        love.graphics.printf(". . .", screen.wid * 0.1, screen.hei * 0.075, screen.wid * 0.8, "center")
    end

    love.graphics.setColor(255,255,255)
    DrawInstance(player[2].var.instance, player[2].var.pos_x, player[2].var.pos_y, player[2].var.dir)
    DrawInstance(player[1].var.instance, player[1].var.pos_x, player[1].var.pos_y, player[1].var.dir)

    if gameState == "countdown" then
        if countdown > 3 then
            love.graphics.setColor(255,255,255)
            love.graphics.draw(gui_countdownBG, screen.wid / 2, screen.hei / 2, _, scale.wid * 0.5, scale.hei * 0.5, gui_countdownBG:getWidth() / 2, gui_countdownBG:getHeight() / 2)
            love.graphics.setFont(font_type.drje1)
            love.graphics.printf(new_round_text, screen.wid * 0.1, screen.hei * 0.45, screen.wid * 0.8, "center")
        elseif countdown <= 3 and countdown > 1 then
            love.graphics.setColor(255,255,255)
            love.graphics.draw(gui_countdownBG, screen.wid / 2, screen.hei / 2, _, scale.wid * 0.5, scale.hei * 0.5, gui_countdownBG:getWidth() / 2, gui_countdownBG:getHeight() / 2)
            love.graphics.setColor(255, 210, 77)
            love.graphics.setFont(font_type.drje1)
            love.graphics.printf(lang.s7_round .. " " .. roundCount + 1, screen.wid * 0.1, screen.hei * 0.45, screen.wid * 0.8, "center")
        elseif countdown <= 1 and countdown > 0 then
            love.graphics.setColor(255,255,255)
            love.graphics.draw(gui_countdownBG, screen.wid / 2, screen.hei / 2, _, scale.wid * 0.85, scale.hei * 0.85, gui_countdownBG:getWidth() / 2, gui_countdownBG:getHeight() / 2)
            love.graphics.setColor(255, 64, 0)
            love.graphics.setFont(font_type.drje0)
            love.graphics.printf(lang.s7_FIGHT, screen.wid * 0.1, screen.hei * 0.4, screen.wid * 0.8, "center")
        end
    end
    if gameState == "playing" then

    end
    if gameState == "paused" then
        love.graphics.setColor(0, 0, 0, 127)
        love.graphics.rectangle("fill", 0, 0, screen.wid, screen.hei)
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.3), (screen.hei * 0.35), (screen.wid * 0.4), (screen. hei * 0.085))
        love.graphics.rectangle("fill", (screen.wid * 0.3), (screen.hei * 0.48), (screen.wid * 0.4), (screen. hei * 0.20))

        love.graphics.setFont(font_type.edosz2)
        love.graphics.setColor(255, 210, 77)
        love.graphics.printf(lang.s7_paused, 0, screen.hei * 0.36, screen.wid, "center")
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        if game_selected == 1 then
            love.graphics.setColor(255, 210, 77)
        end
        love.graphics.printf(lang.s7_resume, 0, screen.hei * 0.5, screen.wid, "center")
        love.graphics.setColor(255, 255, 255)
        if game_selected == 2 then
            love.graphics.setColor(255, 210, 77)
        end
        love.graphics.printf(lang.s7_reset, 0, screen.hei * 0.55, screen.wid, "center")
        love.graphics.setColor(255, 255, 255)
        if game_selected == 3 then
            love.graphics.setColor(255, 210, 77)
        end
        love.graphics.printf(lang.s7_mainMenu, 0, screen.hei * 0.6, screen.wid, "center")

        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.0), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_select, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
        love.graphics.printf(lang.sx_back, 0, screen.hei * 0.9, screen.wid * 0.2, "right")
        love.graphics.draw(gui_keyK, screen.wid * 0.74, screen.hei * 0.93, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.775, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
        love.graphics.draw(gui_esc, screen.wid * 0.26, screen.hei * 0.93, _, scale.wid , scale.hei, gui_esc:getWidth() / 2, gui_esc:getHeight() / 2)
        if settings.backAsStart then
            love.graphics.draw(gui_back, screen.wid * 0.225, screen.hei * 0.93, _, scale.wid , scale.hei, gui_back:getWidth() / 2, gui_back:getHeight() / 2)
        else
            love.graphics.draw(gui_start, screen.wid * 0.225, screen.hei * 0.93, _, scale.wid , scale.hei, gui_start:getWidth() / 2, gui_start:getHeight() / 2)
        end
    end
    if gameState == "roundEnded" then
        love.graphics.setColor(255,255,255)
        love.graphics.draw(gui_countdownBG, screen.wid / 2, screen.hei / 2, _, scale.wid * 0.5, scale.hei * 0.5, gui_countdownBG:getWidth() / 2, gui_countdownBG:getHeight() / 2)
        love.graphics.setFont(font_type.drje1)
        love.graphics.printf(new_round_text, screen.wid * 0.1, screen.hei * 0.45, screen.wid * 0.8, "center")
    end
    if gameState == "ended" then

        love.graphics.setColor(0, 0, 0, 127)
        love.graphics.rectangle("fill", 0, 0, screen.wid, screen.hei)
        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.25), (screen.hei * 0.3), (screen.wid * 0.5), (screen. hei * 0.2))
        love.graphics.rectangle("fill", (screen.wid * 0.3), (screen.hei * 0.58), (screen.wid * 0.4), (screen. hei * 0.2))

        love.graphics.setFont(font_type.drje1)
        love.graphics.setColor(255, 210, 77)
        love.graphics.printf(winner .. " " .. lang.s7_won, screen.wid * 0.1, screen.hei * 0.35, screen.wid * 0.8, "center")
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        if game_selected == 1 then
            love.graphics.setColor(255, 210, 77)
        end
        love.graphics.printf(lang.s7_rematch, 0, screen.hei * 0.6, screen.wid, "center")
        love.graphics.setColor(255, 255, 255)
        if game_selected == 2 then
            love.graphics.setColor(255, 210, 77)
        end
        love.graphics.printf(lang.s7_reset, 0, screen.hei * 0.65, screen.wid, "center")
        love.graphics.setColor(255, 255, 255)
        if game_selected == 3 then
            love.graphics.setColor(255, 210, 77)
        end
        love.graphics.printf(lang.s7_mainMenu, 0, screen.hei * 0.7, screen.wid, "center")

        love.graphics.setColor(0, 0, 0, 96)
        love.graphics.rectangle("fill", (screen.wid * 0.7), (screen.hei * 0.895), (screen.wid * 0.3), (screen. hei * 0.07))
        love.graphics.setFont(font_type.edosz3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf(lang.sx_select, screen.wid * 0.8, screen.hei * 0.9, screen.wid, "left")
        love.graphics.draw(gui_keyK, screen.wid * 0.74, screen.hei * 0.93, _, scale.wid , scale.hei, gui_enter:getWidth() / 2, gui_enter:getHeight() / 2)
        love.graphics.draw(gui_butA, screen.wid * 0.775, screen.hei * 0.93, _, scale.wid , scale.hei, gui_butA:getWidth() / 2, gui_butA:getHeight() / 2)
    end
end

--[[    Handle when the game lose or gain focus
(f: focus)
]]
function game_focus(f)
    if not f then
        if gameState == "countdown" or gameState == "playing" or gameState == "roundEnded" then
            prev_gameState = gameState
            gameState = "paused"
        end
    end
end

--[[    Change the current status of the player animation
(player: player instance, new_status: new state of the character)
]]
function change_status(player, new_status)
    player.var.instance.curr_frame = 1
    player.var.status = new_status
    --player.var.instance.curr_anim = player.var.instance.sprite.animations_names[player.var.status]
    player.var.instance.curr_anim = new_status
end

--[[    Detects when the current animation of the player
(player: player instance)
]]
function get_animation_end(player)
    if player.var.status == "idle" then --idle
        if player.var.instance.curr_frame == 10 then
            return true
        end
    elseif player.var.status == "walk" then --walk
        if player.var.instance.curr_frame == 10 then
            return true
        end
    elseif player.var.status == "jump" then --jump
        if player.var.instance.curr_frame == 20 then
            return true
        end
    elseif player.var.status == "dash" then --dash
        if player.var.instance.curr_frame == 10 then
            return true
        end
    elseif player.var.status == "punch" then --punch
        if player.var.instance.curr_frame == 7 then
            return true
        end
    elseif player.var.status == "kick" then --kick
        if player.var.instance.curr_frame == 7 then
            return true
        end
    elseif player.var.status == "crouch" then --crouch
        if player.var.instance.curr_frame == 10 then
            return true
        end
    elseif player.var.status == "crouchpunch" then --crouch-punch
        if player.var.instance.curr_frame == 8 then
            return true
        end
    elseif player.var.status == "crouchkick" then --crouch-kick
        if player.var.instance.curr_frame == 6 then
            return true
        end
    elseif player.var.status == "defend" then --defend
        if player.var.instance.curr_frame == 6 then
            return true
        end
    elseif player.var.status == "hurt" then --hurt
        if player.var.instance.curr_frame == 8 then
            return true
        end
    elseif player.var.status == "dead" then --dead
        if player.var.instance.curr_frame == 15 then
            return true
        end
    end
end
--
--[[    Change the selection in menu
(dir: set the next item to be selected ["up"-"down"/number])
]]
function game_changeSelected(dir)
    if dir == "up" then
        game_selected = game_selected - 1
        if game_selected < 1 then
            game_selected = 3
        end
    elseif dir == "down" then
        game_selected = game_selected + 1
        if game_selected > 3 then
            game_selected = 1
        end
    else
        game_selected = dir
    end
end

--[[    Starts a new round
(boolean: rematch game)
]]
function new_round(rematch)
    player[1].var.health = 100              player[2].var.health = 100
    player[1].var.pos_x = screen.wid * 0.2  player[2].var.pos_x = screen.wid * 0.8
    player[1].var.pos_y = y_base            player[2].var.pos_y = y_base
    player[1].var.vel_x = 0                 player[2].var.vel_x = 0
    player[1].var.vel_y = 0                 player[2].var.vel_y = 0
    player[1].var.dir = 1                   player[2].var.dir = -1
    player[1].var.t = 0                     player[2].var.t = 0
    player[1].c_left = false                player[2].c_left = false
    player[1].c_right = false               player[2].c_right = false
    player[1].c_up = false                  player[2].c_up = false
    player[1].c_down = false                player[2].c_down = false
    player[1].c_a = false                   player[2].c_a = false
    player[1].c_b = false                   player[2].c_b = false
    player[1].c_x = false                   player[2].c_x = false
    player[1].c_y = false                   player[2].c_y = false
    player[1].c_back = false                player[2].c_back = false
    player[1].c_start = false               player[2].c_start = false
    player[1].c_bumpR = false               player[2].c_bumpR = false
    player[1].c_bumpL = false               player[2].c_bumpL = false
    player[1].var.pause_anim = false        player[2].var.pause_anim = false
    change_status(player[1], "idle")        change_status(player[2], "idle")

    time = game.roundTime
    countdown = 3
    screenTime = time
    gameState = "countdown"
    roundCount = player[1].rounds + player[2].rounds

    if rematch then
        player[1].rounds = 0
        player[2].rounds = 0
        countdown = 3
        roundCount = 0
    end
end

--[[    Calculate the distance between the players
(player1: player instance, player2: player instance)
return: the distance - number
]]
function p_distance(player1, player2)
    return math.sqrt(math.pow(player1.var.pos_x - player2.var.pos_x, 2)) / scale.wid
end

--[[    Calculate the distance where the player can hit each other
return: the hit distance - number
]]
function p_hit_distance()
    return math.sqrt(math.pow(230 * scale.wid, 2)) / scale.wid
end

--[[    Calculate the game distance value of a given reference value
return: the value in game distance
]]
function p_get_distance(value)
    return math.sqrt(math.pow(value * scale.wid, 2)) / scale.wid
end

--[[    Tests if the reference player is looking to the target player
(ref_player: reference player istance, target_player: target player instance)
return: true if looking, false if not.
]]
function is_looking(ref_player, target_player)
    return (ref_player.var.pos_x < target_player.var.pos_x and ref_player.var.dir == 1) or (ref_player.var.pos_x > target_player.var.pos_x and ref_player.var.dir == -1)
end

--[[ This Function is your adversary in the 1 player game
(player: player instance, ia_player: ia controlled player instance)
]]
function game_ia(player, ia_player)
    --future plans: 
    --  > difficulty be changeable
    --  > different actions for each character
    --  > change its behavior depending on how much life have
    --    player.var.pos_x
    --    player.var.dir
    --    player.var.t
    --    player.c_left
    --    player.c_right
    --    player.c_up
    --    player.c_down
    --    player.c_a
    --    player.c_b
    --    player.c_x
    --    player.c_y
    --    player.c_bumpR
    --    player.c_bumpL
    dist = p_distance(player, ia_player)
    desire = math.random(100)

    if not is_looking(ia_player, player) then
        if get_direction(ia_player, player) == "left" then
            ia_player.c_left = true
            ia_player.c_right = false
        elseif get_direction(ia_player, player) == "right" then
            ia_player.c_right = true
            ia_player.c_left = false
        end
    elseif dist >= FAR_DISTANCE then
        if get_direction(ia_player, player) == "left" then
            ia_player.c_left = true
            ia_player.c_right = false
        elseif get_direction(ia_player, player) == "right" then
            ia_player.c_right = true
            ia_player.c_left = false
        end
    elseif dist < FAR_DISTANCE and dist > MED_DISTANCE then

        if desire == 1 and ia_wait.reason == "" then
            --jump
            ia_player.c_a = true
        elseif desire == 2 and ia_wait.reason == "" then
            --defend
            ia_player.c_b = true
            ia_wait.t = math.random(20) / 10
            ia_wait.reason = "defend"
        elseif desire == 3 and ia_wait.reason == "" then
            ia_player.c_down = true
            ia_wait.t = math.random(20) / 10
            ia_wait.reason = "crouch"
        else
            if get_direction(ia_player, player) == "left" then
                ia_player.c_left = true
                ia_player.c_right = false
            elseif get_direction(ia_player, player) == "right" then
                ia_player.c_right = true
                ia_player.c_left = false
            end
        end
    elseif dist < MED_DISTANCE and dist > HIT_DISTANCE then
        if desire == 1 and ia_wait.reason == "" then
            --defend
            ia_player.c_b = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "defend"
        elseif desire == 3 and ia_wait.reason == "" then
            ia_player.c_down = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "crouch"
        else
            if get_direction(ia_player, player) == "left" then
                ia_player.c_left = true
                ia_player.c_right = false
            elseif get_direction(ia_player, player) == "right" then
                ia_player.c_right = true
                ia_player.c_left = false
            end
        end
    elseif dist < CLO_DISTANCE and ((ia_player.var.pos_x < (300 * scale.wid)) or (ia_player.var.pos_x > screen.wid - (300 * scale.wid))) and ia_player.var.t <= 0 then
        if get_direction(ia_player, player) == "right" then
            ia_player.c_bumpL = true
        elseif get_direction(ia_player, player) == "left" then
            ia_player.c_bumpR = true
        end
    elseif dist < CLO_DISTANCE and dist > HIT_DISTANCE then
        if desire % 10 == 1 and ia_wait.reason == "" then
            ia_player.c_down = true
            ia_player.c_x = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "crouch"
        elseif desire % 10 == 2 and ia_wait.reason == "" then
            ia_player.c_down = true
            ia_player.c_y = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "crouch"
        elseif desire % 10 == 3 and ia_wait.reason == "" then
            ia_player.c_x = true
        elseif desire % 10 == 4 and ia_wait.reason == "" then
            ia_player.c_y = true
        elseif desire == 5 and (player.var.status == "punch" or player.var.status == "kick") and ia_wait.reason == "" then
            --defend
            ia_player.c_b = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "defend"
        elseif desire == 6 and player.var.status == "defend" and ia_wait.reason == "" then
            ia_player.c_down = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "crouch"
        else
            if get_direction(ia_player, player) == "left" then
                ia_player.c_left = true
                ia_player.c_right = false
            elseif get_direction(ia_player, player) == "right" then
                ia_player.c_right = true
                ia_player.c_left = false
            end
        end
    elseif dist < HIT_DISTANCE then
        if desire == 82 and ia_player.var.t <= 0 then
            if get_direction(ia_player, player) == "left" then
                ia_player.c_bumpR = true
            elseif get_direction(ia_player, player) == "right" then
                ia_player.c_bumpL = true
            end
        elseif desire % 2 == 0 and ia_wait.reason == "" and player.var.status == "defend" then
            ia_player.c_down = true
            ia_player.c_x = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "crouch"
        elseif desire % 2 == 1 and ia_wait.reason == "" and player.var.status == "defend" then
            ia_player.c_down = true
            ia_player.c_y = true
            ia_wait.t = math.random(10) / 10
            ia_wait.reason = "crouch"
        elseif desire % 3 == 0 and ia_wait.reason == "" and player.var.status ~= "defend" then
            ia_player.c_x = true
        elseif desire % 3 == 1 and ia_wait.reason == "" and player.var.status ~= "defend" then
            ia_player.c_y = true
        else
            if get_direction(ia_player, player) == "right" then
                ia_player.c_left = true
                ia_player.c_right = false
                ia_wait.t = math.random(10) / 10
                ia_wait.reason = "distance"
            elseif get_direction(ia_player, player) == "left" then
                ia_player.c_right = true
                ia_player.c_left = false
                ia_wait.t = math.random(10) / 10
                ia_wait.reason = "distance"
            end
        end
    else
        ia_player.c_left = false
        ia_player.c_right = false
        ia_player.c_up = false
    end

    if ia_wait.reason == "defend" then
        if ia_wait.t > 0 then
            ia_player.c_b = true
        else
            ia_wait.t = 0
            ia_wait.reason = ""
            ia_player.c_b = false
        end
    elseif ia_wait.reason == "crouch" then
        if ia_wait.t > 0 then
            ia_player.c_down = true
        else
            ia_wait.t = 0
            ia_wait.reason = ""
            ia_player.c_down = false
        end
    elseif ia_wait.reason == "distance" then
        if ia_wait.t > 0 then
            if get_direction(ia_player, player) == "right" then
                ia_player.c_left = true
                ia_player.c_right = false
            elseif get_direction(ia_player, player) == "left" then
                ia_player.c_right = true
                ia_player.c_left = false
            end
        else
            ia_wait.t = 0
            ia_wait.reason = ""
        end
    else
        ia_player.c_down = false
        ia_player.c_b = false
    end
end

--[[    Function to tell what direction the playter are
(ref_player: reference player instance, target_player: target player instance)
return: target_player's direction - "left" | "right"
]]
function get_direction(ref_player, target_player)
    if ref_player.var.pos_x < target_player.var.pos_x then
        return "right"
    elseif ref_player.var.pos_x > target_player.var.pos_x then
        return "left"
    else
        return "center"
    end
end