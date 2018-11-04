slotsonobjects_shown = 1

function sr_slotsonobjectsvis()
	slotsonobjects_shown = (slotsonobjects_shown + 1) % 3
end

function slotsonobjects()
	if slotsonobjects_shown == 0 then
		return
	end
	
	scr_x = mem_read_uword(SCR_X)
	scr_y = mem_read_uword(SCR_Y)
	
	for i=object_limit,0,-1 do
		if mem_read_ulong(OST_START+i*OST_ENTRY_LENGTH) ~= 0 then
			obj_x = mem_read_uword(OST_START+OBJ_X+i*OST_ENTRY_LENGTH)
			obj_y = mem_read_uword(OST_START+OBJ_Y+i*OST_ENTRY_LENGTH)
			
			if slotsonobjects_shown == 1 then
				slot = string.format("%02x",i)
				off_x = -fnt_width*1
			elseif slotsonobjects_shown == 2 then	
				slot = string.format("%04x",OST_START_SHR+i*OST_ENTRY_LENGTH)
				off_x = -fnt_width*2
			end
			off_y = - fnt_height/2
			pos_x = (obj_x - scr_x)*gam_xscale + gam_left + off_x
			pos_y = (obj_y - scr_y)*gam_yscale + gam_up + off_y
			
			if gam_left <= pos_x and pos_x <= gam_right and gam_up <= pos_y and pos_y <= gam_down then
				gui.text(pos_x,pos_y,slot,"green","black")
			end
			if i == 0 and not (gam_left <= pos_x and pos_x <= gam_right and gam_up <= pos_y and pos_y <= gam_down) then --Redundant code, but put here for clarity
				gui.text(math.max(gam_left+fnt_width,math.min(gam_right-fnt_width,pos_x)), math.max(gam_up+fnt_height,math.min(gam_down-fnt_height,pos_y)),string.rep("##",slotsonobjects_shown),"green","black")
			end
		end
	end
end

met_slotsonobjectvis = {sr_slotsonobjectsvis,sr_nil,sr_nil,sr_nil}
table.insert(persistent_functions, slotsonobjects)
