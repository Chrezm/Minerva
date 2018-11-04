
cs_spkeys = {'shift'}

mem_read_ubyte = memory.readbyte
mem_read_uword = memory.readword
mem_read_ulong = memory.readlong
mem_write_ubyte = memory.writebyte
mem_write_uword = memory.writeword
mem_write_ulong = memory.writelong

cli_screenwidth = 320
cli_screenheight = 224

-- Gens needs not worry about this
gam_xnat = 320 -- Natural x-resolution, defaulted to Genesis
gam_ynat = 224 -- Natural y-resolution, defaulted to Genesis
gam_up = 0
gam_down = 224
gam_xport = 320
gam_yport = 224
gam_left = 0
gam_right = 324
gam_xscale = 1
gam_yscale = 1


fnt_width = 4
fnt_height = 7

sav_load = savestate.load
sav_create = savestate.create
sav_save = savestate.save

gui_register = function(instructions) gui.register(instructions) end
gui_registerafter = function(instructions) gens.registerafter(instructions) end

margin = 20
x_left = margin
x_right = cli_screenwidth - margin - fnt_width*34

y_1 = 10
y_2 = y_1 + fnt_height*5
y_sh = 66 --Sonic HUD offset
y_limit = cli_screenheight - fnt_height*2