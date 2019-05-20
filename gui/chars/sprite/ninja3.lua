require "love.graphics"


local image_w = 7200
local image_h = 5280


return {
    serialization_version = 1.0,

    sprite_sheet = "gui/chars/sprite/ninja3.png",
    sprite_name = "Ninja3",

    frame_duration = 0.075,

    animations_names = {
        "idle", --1
        "walk", --2
        "jump", --3
        "dash", --4
        "punch", --5
        "kick", --6
        "crouch", --7
        "crouchpunch", --8
        "crouchkick", --9
        "defend", --10
        "hurt", --11
        "dead", --12
        --"intro", --13
    },

    animations = {
        idle = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 0, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 0, 480, 480, image_w, image_h )
        },
        walk = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 480, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 480, 480, 480, image_w, image_h )
        },
        jump = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 960, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 960, 480, 480, image_w, image_h )
        },
        dash = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 1440, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 1440, 480, 480, image_w, image_h )
        },
        punch = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 1920, 480, 480, image_w, image_h )
        },
        kick = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 2400, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 2400, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 2400, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 2400, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 2400, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 2400, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 2400, 480, 480, image_w, image_h )
        },
        crouch = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 2880, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 2880, 480, 480, image_w, image_h )
        },
        crouchpunch = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 3360, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 3360, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 3360, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 3360, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 3360, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 3360, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 3360, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 3360, 480, 480, image_w, image_h )
        },
        crouchkick = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 3840, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 3840, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 3840, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 3840, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 3840, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 3840, 480, 480, image_w, image_h )
        },
        defend = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad( 3840, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4800, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 5280, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 5760, 1920, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 6240, 1920, 480, 480, image_w, image_h )
        },
        hurt = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 4320, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 4320, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 4320, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 4320, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 4320, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 4320, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 4320, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 4320, 480, 480, image_w, image_h )
        },
        dead = {
            --	love.graphics.newQuad( X, Y, Width, Height, Image_W, Image_H)
            love.graphics.newQuad(    0, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  480, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad(  960, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1440, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 1920, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2400, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 2880, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3360, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 3840, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4320, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 4800, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 5280, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 5760, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 6240, 4800, 480, 480, image_w, image_h ),
            love.graphics.newQuad( 6720, 4800, 480, 480, image_w, image_h )
        }

    } --animations

} --return (end of file)

