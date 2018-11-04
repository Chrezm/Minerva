-- Better Sonic Debug Script
-- Allows to toggle debug and slow motion flags, 
-- Original script by: deltaphc
-- Modified by: Chrezm

function sr_debug() 
	local v = mem_read_ubyte(DEBUG_FLAG)
	mem_write_ubyte(DEBUG_FLAG,1-v)
end

function sr_slowmotion()
	local v = mem_read_ubyte(SLOWMO_FLAG)
	mem_write_ubyte(SLOWMO_FLAG,1-v)
end

function sr_stagerestart()
	if keys[cs_spkeys[1]] then
		mem_write_uword(LAST_CHKP,0)
		mem_write_uword(OST_START+OBJ_X,0)
		mem_write_uword(OST_START+OBJ_Y,0)
	end
	mem_write_ubyte(STG_RESTART,1)
end

met_debug = {sr_debug,sr_nil,sr_nil,sr_nil}
met_slowmotion = {sr_slowmotion,sr_nil,sr_nil,sr_nil}
met_stagerestart = {sr_stagerestart,sr_nil,sr_nil,sr_nil}