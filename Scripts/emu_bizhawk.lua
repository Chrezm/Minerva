cs_spkeys = {'LeftShift'}

mem_read_ubyte = memory.read_u8
mem_read_uword = memory.read_u16_be
mem_read_ulong = memory.read_u32_be
mem_write_ubyte = memory.write_u8
mem_write_uword = memory.write_u16_be
mem_write_ulong = memory.write_u32_be

get_game_size = function()
	cli_screenwidth = client.screenwidth()
	cli_screenheight = client.screenheight()

	gam_xnat = 320 -- Natural x-resolution, defaulted to Genesis
	gam_ynat = 224 -- Natural y-resolution, defaulted to Genesis
	gam_up = 0
	gam_down = cli_screenheight
	gam_xport = cli_screenheight * gam_xnat/gam_ynat
	gam_yport = cli_screenheight
	gam_left = (cli_screenwidth - gam_xport)/2
	gam_right = gam_left + gam_xport
	gam_xscale = gam_xport/gam_xnat
	gam_yscale = gam_yport/gam_ynat
	
	margin = 40
	x_left = margin
	x_right = cli_screenwidth - margin - fnt_width*34

	y_1 = 10
	y_2 = y_1 + fnt_height*5
	y_sh = 160 --Sonic HUD offset
	y_limit = cli_screenheight - fnt_height*2
end
table.insert(persistent_functions, get_game_size)

fnt_width = 10
fnt_height = 14

sav_load = savestate.load
sav_create = savestate.create
sav_save = savestate.save

gui_register = function(instructions) while true do 
	instructions()
	emu.frameadvance()
end 
end

print("---\nWARNING: If you need to restart Minerva on BizHawk (due to an error or some other reason), please reopen the Lua console before doing that. Attempting to restart Minerva on the same session may lead to unexpected errors.\n---")