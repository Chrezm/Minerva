FN  main()
+   [
    offset = 209400
    stage = 1
    active = 0
    ]
_   [true] [
        framecount = emu.framecount()
        @hud
        @determine_status
    ]
ENDFN

FN  hud()
+   [
        if emu.islagged() then
            gui_atext(0, fnt_height, framecount+offset, "red", "black")
        else
            gui_atext(0, fnt_height, framecount+offset, "white", "black")
        end
    ]
ENDFN

FN  determine_status()
+   [
        if framecount < 15000 then
            stage = 1
            if framecount > 10000 then
                active = 1
            else
                active = 0
            end
        elseif framecount < 18000 then
            stage = 2
            if framecount > 15600 then
                active = 1
            else
                active = 0
            end
        elseif framecount < 45000 then
            stage = 3
            if framecount > 38000 then
                active = 1
            else
                active = 0
            end
        end
        
        if active == 1 then
            @execute_actions
        end
    ]
ENDFN

FN  execute_actions()
+   [
        if framecount == 10066 then
            mem_write_uword(0xFFB014, 0x0260)
            mem_write_uword(0xFFB010, 0x340)
        elseif framecount == 10178 then
            mem_write_ubyte(0xFFEE33, 8)
        elseif framecount == 10228 then
            mem_write_uword(0xFFB014, 0x200)
        elseif framecount == 15616 then
            mem_write_uword(0xFFB04A+0x10, 0x250)
        elseif framecount == 15842 then
            mem_write_uword(0xFFB014, 0x620)
        elseif framecount == 16100 then
            mem_write_uword(0xFFB014, 0x890)
        elseif framecount == 16370 then
            mem_write_uword(0xFFB014, 0x24C)
        elseif framecount == 16430 then
            mem_write_uword(0xFFB014, 0x3FF)
        elseif framecount == 33864 then
            mem_write_ubyte(0xFFF600, 0x24)
        end
    ]
ENDFN