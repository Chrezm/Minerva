overlay_shown = 1
current_page = 1
max_pages = 1
object_limit = 0x6d --This is the actual limit

function sr_overlayvis()
	overlay_shown = 1 - overlay_shown
end

function sr_rampageprev() --Don't mind the name, it's RAM_page_prev
	if current_page ~= 1 then
		current_page = current_page - 1
	end
end

function sr_rampagenext()
	if current_page ~= max_pages then
		current_page = current_page + 1
	end
end

function overlay()
	if overlay_shown == 0 then
		return
	end
	
	--Last Object character stood on (Only relevant for Sonic games)
	y = y_1
	if show_1p_last_stood_on then
		gui.text(x_right, y, "1P LAST ON", "green", "black")
		if (id_is_word and mem_read_uword(PLAYER1+OBJ_LASTON) == 00) or (not id_is_word and mem_read_ubyte(PLAYER1+OBJ_LASTON) == 0) then 
			gui.text(x_right+fnt_width*13, y, "--", "white", "black") 
		else 
			if mem_read_ubyte(PLAYER1+OBJ_STAT_FIELD) % 0x10 >= 0x08 then
				color = "green"
			else
				color = "white"
			end
			if id_is_word then
				gui.text(x_right+fnt_width*13, y, string.format("%s%02x", "0x",(mem_read_uword(PLAYER1+OBJ_LASTON)-PLAYER1_SHR)/(OST_ENTRY_LENGTH)), color, "black")
			else
				gui.text(x_right+fnt_width*13, y, string.format("%s%02x","0x", mem_read_ubyte(PLAYER1+OBJ_LASTON)), color, "black")
			end
		end
	end
	
	--Last Object 2P character stood on (Only relevant for Sonic games)
	y = y_1 + fnt_height
	if show_2p_last_stood_on then
		gui.text(x_right, y, "2P LAST ON", "green", "black")
		if (id_is_word and mem_read_uword(PLAYER2+OBJ_LASTON) == 00) or (not id_is_word and mem_read_ubyte(PLAYER2+OBJ_LASTON) == 0) then 
			gui.text(x_right+fnt_width*13, y, "--", "white", "black") 
		else 
			if mem_read_ubyte(PLAYER2+OBJ_STAT_FIELD) % 0x10 >= 0x08 then
				color = "green"
			else
				color = "white"
			end
			if id_is_word then
				gui.text(x_right+fnt_width*13, y, string.format("%s%02x", "0x",(mem_read_uword(PLAYER2+OBJ_LASTON)-PLAYER2_SHR)/(OST_ENTRY_LENGTH)), color, "black")
			else
				gui.text(x_right+fnt_width*13, y, string.format("%s%02x","0x", mem_read_ubyte(PLAYER2+OBJ_LASTON)), color, "black")
			end

			if show_2p_last_visible_stood_on then
				gui.text(x_right+fnt_width*18, y, string.format("%04x", mem_read_uword(0xFF0000+mem_read_uword(PLAYER2+OBJ_LASTON))), "white", "black")
			end
		end
		if show_2p_last_visible_stood_on then
			gui.text(x_right, y+fnt_height, "2P LAST VIS ON", "green", "black")
			gui.text(x_right+fnt_width*18,y+fnt_height, string.format("%04x", mem_read_uword(PLY2_LAST_VISIBLE_STOOD_ON)), "white", "black")
		end
	end
	
	--RAM slots
	y = y_2

	gui.text(x_right, y,"RAM Page:","green","black")
	gui.text(x_right+fnt_width*10, y,string.format("%d%s%d",current_page,"/",max_pages),"white","black")
	
	y = y_2 + fnt_height
	gui.text(x_right+fnt_width*2, y, "RAM", "green", "black")
	gui.text(x_right+aux*.35+fnt_width*9, y, "ID", "green", "black")
	gui.text(x_right+aux+fnt_width*15, y, "X", "green", "black")
	gui.text(x_right+aux+fnt_width*24, y, "Y", "green", "black")
	gui.text(x_right+aux+fnt_width*30, y, "RN", "green", "black")
	j=0
	
	any_objects_flag = false
	object_page = 1
	
	for i=0,object_limit do
		y_off = (y_2+2*fnt_height)
		obj_offset = OST_START+i*OST_ENTRY_LENGTH
		obj_offset_shr = obj_offset % 0x10000
		if mem_read_ulong(obj_offset) ~= 0 then
			any_objects_flag = true
			x = x_right --Adapted x_right
			y = y_off + j*fnt_height --Adapted yoff
			object_page = 1
			while y >= y_limit do
				object_page = object_page + 1
				y = y - (y_limit - y_off)
			end
			
			if object_page == current_page then
				gui.text(x,y, string.format("%02x%s%04x",i," ",obj_offset_shr), "white", "black")
				
				if 0x23400 <= mem_read_ulong(obj_offset) and 0x23500 >= mem_read_ulong(obj_offset) then
					gui.text(x-10, y, ">", "red", "black")
				end
				--Edge calculations, based on the Sonic Disassembly
				d1 = mem_read_ubyte(obj_offset+OBJ_WD) --Width of object
				d2 = d1*2-2
				d1 = d1+mem_read_uword(OST_START+OBJ_X)-mem_read_uword(obj_offset+OBJ_X) 
				if d1 >= 2 and d1 < d2 then
					gui.text(x,y, string.format("%02x%s%04x",i," ",obj_offset_shr), "green", "black")
				else 
					if mem_read_uword(obj_offset+OBJ_X) - mem_read_uword(OST_START+OBJ_X) < 0x20 and mem_read_uword(obj_offset+OBJ_X) - mem_read_uword(OST_START+OBJ_X) >= -0x20 then
						gui.text(x,y, string.format("%02x%s%04x",i," ",obj_offset_shr), "#40000070", "black")
					end
				end
				if id_is_word then
					gui.text(x+fnt_width*9,y, string.format("%05x", mem_read_ulong(obj_offset)), "white", "black") --ID
				else
					gui.text(x+fnt_width*9,y, string.format("%02x", mem_read_ubyte(obj_offset)), "white", "black") --ID
				end
				gui.text(x+aux+fnt_width*12,y, string.format("%04x%s", mem_read_uword(obj_offset+OBJ_X),":"), "white", "black")
				gui.text(x+aux+fnt_width*17,y, string.format("%02x", mem_read_ubyte(obj_offset+OBJ_SPX)), "white", "black")
				gui.text(x+aux+fnt_width*21,y, string.format("%04x%s", mem_read_uword(obj_offset+OBJ_Y),":"), "white", "black")
				gui.text(x+aux+fnt_width*26,y, string.format("%02x", mem_read_ubyte(obj_offset+OBJ_SPY)), "white", "black")
				gui.text(x+aux+fnt_width*30,y, string.format("%02x", mem_read_ubyte(obj_offset+OBJ_ROUT_CNT)), "white", "black")
			end
			j=j+1
		end
	end 
	max_pages = object_page --What an extremely lazy way of getting how many pages there should be.	
	if current_page > max_pages then
		current_page = max_pages
	end
	page_length = (y_limit-y_off)/7
	if any_objects_flag then
		objects_in_memory = (max_pages-1)*page_length+(j-1)%page_length+1
	else
		objects_in_memory = 0
	end
	y = y_2
	gui.text(x_right+fnt_width*14, y,"Obj in Mem:","green","black")
	gui.text(x_right+fnt_width*26, y,string.format("%d",objects_in_memory),"white","black")

	y1 = y_sh
	y2 = y_sh + fnt_height
	y3 = y_sh + fnt_height*2
	
	gui.text(x_left, y1, "CAMERA", "green", "black")
	gui.text(x_left, y2, "X-LOCK", "green", "black")
	gui.text(x_left, y3, "Y-LOCK", "green", "black")
	
	--Camera
	gui.text(x_left+fnt_width*8,y1,string.format("%s%04x", "X: ", mem_read_uword(SCR_X)), "white", "black") 
	gui.text(x_left+fnt_width*22,y1,string.format("%s%04x", "Y: ", mem_read_uword(SCR_Y)), "white", "black") 
	
	--Camera lock
	--Current locks
	gui.text(x_left+fnt_width*8,y2,string.format("%s%04x", "<: ",mem_read_uword(SCR_LOCK_L)), "white", "black") --left
	gui.text(x_left+fnt_width*22,y2,string.format("%s%04x", ">: ",mem_read_uword(SCR_LOCK_R)), "white", "black") --right
	gui.text(x_left+fnt_width*8,y3,string.format("%s%04x", "^: ",mem_read_uword(SCR_LOCK_T)), "white", "black") --top
	gui.text(x_left+fnt_width*22,y3,string.format("%s%04x", "v: ",mem_read_uword(SCR_LOCK_B)), "white", "black") --bottom
	
	--Target locks positions
	gui.text(x_left+fnt_width*16,y2,string.format("%04x", mem_read_uword(SCR_TARG_LOCK_L)), "green", "black") --left
	gui.text(x_left+fnt_width*30,y2,string.format("%04x", mem_read_uword(SCR_TARG_LOCK_R)), "green", "black") --right
	gui.text(x_left+fnt_width*16,y3,string.format("%04x", mem_read_uword(SCR_TARG_LOCK_T)), "green", "black") --top
	gui.text(x_left+fnt_width*30,y3,string.format("%04x", mem_read_uword(SCR_TARG_LOCK_B)), "green", "black") --bottom
end

met_overlayvis = {sr_overlayvis,sr_nil,sr_nil,sr_nil}
met_rampageprev = {sr_rampageprev,sr_nil,sr_nil,sr_nil}
met_rampagenext = {sr_rampagenext,sr_nil,sr_nil,sr_nil}

table.insert(persistent_functions, overlay)