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

local dynamic_objects_spawned_when_moving_left = 0

function overlay()
	if overlay_shown == 0 then
		return
	end

	-- TEMP: REMOVE LATER
	--show_1p_last_stood_on = false
	--show_2p_last_stood_on = false
	--object_limit = 1

	--Last Object character stood on (Only relevant for Sonic games)
	y = y_1
	if show_1p_last_stood_on then
		gui.text(x_right, y, "1P LAST ON", "green", "black")
		if (id_is_word and mem_read_uword(PLAYER1 + OBJ_LASTON) == 00) or (not id_is_word and mem_read_ubyte(PLAYER1 + OBJ_LASTON) == 0) then
			gui.text(x_right + fnt_width * 13, y, "--", "white", "black")
		else
			if mem_read_ubyte(PLAYER1 + OBJ_STAT_FIELD) % 0x10 >= 0x08 then
				color = "green"
			else
				color = "white"
			end
			if id_is_word then
				gui.text(x_right + fnt_width * 13, y,
					string.format("%02x", (mem_read_uword(PLAYER1 + OBJ_LASTON) - PLAYER1_SHR) / (OST_ENTRY_LENGTH)), color,
					"black")
			else
				gui.text(x_right + fnt_width * 13, y, string.format("%02x", mem_read_ubyte(PLAYER1 + OBJ_LASTON)), color, "black")
			end
		end
	end

	--Last Object 2P character stood on (Only relevant for Sonic games)
	y = y_1 + fnt_height
	if show_2p_last_stood_on then
		gui.text(x_right, y, "2P LAST ON", "green", "black")
		if (id_is_word and mem_read_uword(PLAYER2 + OBJ_LASTON) == 00) or (not id_is_word and mem_read_ubyte(PLAYER2 + OBJ_LASTON) == 0) then
			gui.text(x_right + fnt_width * 13, y, "--", "white", "black")
		else
			if mem_read_ubyte(PLAYER2 + OBJ_STAT_FIELD) % 0x10 >= 0x08 then
				color = "green"
			else
				color = "white"
			end
			if id_is_word then
				gui.text(x_right + fnt_width * 13, y,
					string.format("%02x", (mem_read_uword(PLAYER2 + OBJ_LASTON) - PLAYER2_SHR) / (OST_ENTRY_LENGTH)), color,
					"black")
			else
				gui.text(x_right + fnt_width * 13, y, string.format("%02x", mem_read_ubyte(PLAYER2 + OBJ_LASTON)), color, "black")
			end

			if show_2p_last_visible_stood_on then
				gui.text(x_right + fnt_width * 18, y,
					string.format("%04x", mem_read_uword(0xFF0000 + mem_read_uword(PLAYER2 + OBJ_LASTON))), "white", "black")
			end
		end
		if show_2p_last_visible_stood_on then
			gui.text(x_right, y + fnt_height, "2P LAST VIS ON", "green", "black")
			gui.text(x_right + fnt_width * 18, y + fnt_height,
				string.format("%04x", mem_read_uword(PLY2_LAST_VISIBLE_STOOD_ON)), "white", "black")
		end
	end

	--RAM slots
	y = y_2

	gui.text(x_right, y, "RAM Page:", "green", "black")
	gui.text(x_right + fnt_width * 10, y, string.format("%d%s%d", current_page, "/", max_pages), "white", "black")

	y = y_2 + fnt_height
	gui.text(x_right + fnt_width * 2, y, "RAM", "green", "black")
	gui.text(x_right + aux * .35 + fnt_width * 9, y, "ID", "green", "black")
	gui.text(x_right + aux + fnt_width * 15, y, "X", "green", "black")
	gui.text(x_right + aux + fnt_width * 24, y, "Y", "green", "black")
	gui.text(x_right + aux + fnt_width * 30, y, "RN", "green", "black")
	j = 0

	any_objects_flag = false
	object_page = 1
	eggman_address = 0

	for i = 0, object_limit do
		y_off = (y_2 + 2 * fnt_height)
		obj_offset = OST_START + i * OST_ENTRY_LENGTH
		obj_offset_shr = obj_offset % 0x10000
		if mem_read_ulong(obj_offset) ~= 0 and mem_read_ulong(obj_offset) ~= 0x8b720 then
			any_objects_flag = true
			x = x_right             --Adapted x_right
			y = y_off + j * fnt_height --Adapted yoff
			object_page = 1
			while y >= y_limit do
				object_page = object_page + 1
				y = y - (y_limit - y_off)
			end

			if object_page == current_page then
				gui.text(x, y, string.format("%02x%s%04x", i, " ", obj_offset_shr), "white", "black")

				if 0x23400 <= mem_read_ulong(obj_offset) and 0x23500 >= mem_read_ulong(obj_offset) then
					gui.text(x - 10, y, ">", "red", "black")
				end
				--Edge calculations, based on the Sonic Disassembly
				d1 = mem_read_ubyte(obj_offset + OBJ_WD) --Width of object
				d2 = d1 * 2 - 2
				d1 = d1 + mem_read_uword(OST_START + OBJ_X) - mem_read_uword(obj_offset + OBJ_X)
				if d1 >= 2 and d1 < d2 then
					gui.text(x, y, string.format("%02x%s%04x", i, " ", obj_offset_shr), "green", "black")
				else
					if mem_read_uword(obj_offset + OBJ_X) - mem_read_uword(OST_START + OBJ_X) < 0x20 and mem_read_uword(obj_offset + OBJ_X) - mem_read_uword(OST_START + OBJ_X) >= -0x20 then
						gui.text(x, y, string.format("%02x%s%04x", i, " ", obj_offset_shr), "#40000070", "black")
					end
				end
				if id_is_word then
					gui.text(x + fnt_width * 9, y, string.format("%05x", mem_read_ulong(obj_offset)), "white", "black") --ID
					if mem_read_ulong(obj_offset) == 0x65c04 or mem_read_ulong(obj_offset) == 0x65c50 then
						eggman_address = obj_offset
					end
					if mem_read_ulong(obj_offset) == 0x8b720 then
						gui.text(x + fnt_width * 9, y, string.format("%05x", mem_read_ulong(obj_offset)), "cyan", "black")
					end

					local respawn_addr = mem_read_uword(obj_offset + 0x48)
					gui.text(x + fnt_width * -5, y, string.format("%04x", mem_read_uword(obj_offset + 0x48)), "yellow", "black")
				else
					gui.text(x + fnt_width * 9, y, string.format("%02x", mem_read_ubyte(obj_offset)), "white", "black") --ID
				end
				gui.text(x + aux + fnt_width * 12, y, string.format("%04x%s", mem_read_uword(obj_offset + OBJ_X), ":"), "white",
					"black")
				gui.text(x + aux + fnt_width * 17, y, string.format("%02x", mem_read_ubyte(obj_offset + OBJ_SPX)), "white",
					"black")
				gui.text(x + aux + fnt_width * 21, y, string.format("%04x%s", mem_read_uword(obj_offset + OBJ_Y), ":"), "white",
					"black")
				gui.text(x + aux + fnt_width * 26, y, string.format("%02x", mem_read_ubyte(obj_offset + OBJ_SPY)), "white",
					"black")
				gui.text(x + aux + fnt_width * 30, y, string.format("%02x", mem_read_ubyte(obj_offset + OBJ_ROUT_CNT)), "white",
					"black")
			end
			j = j + 1
		end
	end
	max_pages = object_page --What an extremely lazy way of getting how many pages there should be.	
	if current_page > max_pages then
		current_page = max_pages
	end
	page_length = (y_limit - y_off) / fnt_height
	if any_objects_flag then
		objects_in_memory = (max_pages - 1) * page_length + (j - 1) % page_length + 1
	else
		objects_in_memory = 0
	end
	y = y_2
	gui.text(x_right + fnt_width * 14, y, "Obj in Mem:", "green", "black")
	gui.text(x_right + fnt_width * 26, y, string.format("%d", objects_in_memory), "white", "black")

	y1 = y_sh
	y2 = y_sh + fnt_height
	y3 = y_sh + fnt_height * 2

	gui.text(x_left, y1, "CAMERA", "green", "black")
	gui.text(x_left, y2, "X-LOCK", "green", "black")
	gui.text(x_left, y3, "Y-LOCK", "green", "black")

	--Camera
	gui.text(x_left + fnt_width * 8, y1, string.format("%s%04x", "X: ", mem_read_uword(SCR_X)), "white", "black")
	gui.text(x_left + fnt_width * 22, y1, string.format("%s%04x", "Y: ", mem_read_uword(SCR_Y)), "white", "black")

	--Camera lock
	--Current locks
	gui.text(x_left + fnt_width * 8, y2, string.format("%s%04x", "<: ", mem_read_uword(SCR_LOCK_L)), "white", "black") --left
	gui.text(x_left + fnt_width * 22, y2, string.format("%s%04x", ">: ", mem_read_uword(SCR_LOCK_R)), "white", "black") --right
	gui.text(x_left + fnt_width * 8, y3, string.format("%s%04x", "^: ", mem_read_uword(SCR_LOCK_T)), "white", "black") --top
	gui.text(x_left + fnt_width * 22, y3, string.format("%s%04x", "v: ", mem_read_uword(SCR_LOCK_B)), "white", "black") --bottom

	--Target locks positions
	gui.text(x_left + fnt_width * 16, y2, string.format("%04x", mem_read_uword(SCR_TARG_LOCK_L)), "green", "black") --left
	gui.text(x_left + fnt_width * 30, y2, string.format("%04x", mem_read_uword(SCR_TARG_LOCK_R)), "green", "black") --right
	gui.text(x_left + fnt_width * 16, y3, string.format("%04x", mem_read_uword(SCR_TARG_LOCK_T)), "green", "black") --top
	gui.text(x_left + fnt_width * 30, y3, string.format("%04x", mem_read_uword(SCR_TARG_LOCK_B)), "green", "black") --bottom

	local object_list_pointer = mem_read_ulong(0xFFEF5A)

	local value_at_object_load_addr_back = mem_read_ulong(0xFFF776)
	local left_object_offset_in_list = mem_read_ubyte(value_at_object_load_addr_back + 4)
	local x_coord_object_load_addr_back = mem_read_uword(value_at_object_load_addr_back + 0)
	local y_coord_object_load_addr_back = mem_read_uword(value_at_object_load_addr_back + 2)
	local pc_addr_object_load_addr_back = mem_read_ulong(object_list_pointer + left_object_offset_in_list * 4)
	gui.text(x_left, y_sh + fnt_height * 3, "< NEXT OBJECT", "green", "black")
	gui.text(x_left + fnt_width * 14, y_sh + fnt_height * 3,
		string.format("%06x", value_at_object_load_addr_back), "white", "black")
	gui.text(x_left + fnt_width * 22, y_sh + fnt_height * 3,
		string.format("X: %04x", x_coord_object_load_addr_back), "white", "black")
	gui.text(x_left + fnt_width * 32, y_sh + fnt_height * 3,
		string.format("Y: %04x", y_coord_object_load_addr_back), "white", "black")
	gui.text(x_left + fnt_width * 42, y_sh + fnt_height * 3,
		string.format("%02x", left_object_offset_in_list), "white", "black")
	gui.text(x_left + fnt_width * 47, y_sh + fnt_height * 3,
		string.format("ID: %05x", pc_addr_object_load_addr_back), "white", "black")

	local value_at_object_respawn_index_back = mem_read_uword(0xFFF77C)
	local respawn_object_back_offset = mem_read_ubyte(0xFF0000 + value_at_object_respawn_index_back)
	gui.text(x_left, y_sh + fnt_height * 4, "< ORT ADDR", "green", "black")
	local value_at_object_respawn_index_back_color = "white"
	if value_at_object_respawn_index_back > 0 then
		if value_at_object_respawn_index_back < 0xE700 then
			value_at_object_respawn_index_back_color = "red"
		elseif value_at_object_respawn_index_back < 0xEB00 then
			value_at_object_respawn_index_back_color = "yellow"
		end
	end
	gui.text(x_left + fnt_width * 16, y_sh + fnt_height * 4, string.format("%04x", value_at_object_respawn_index_back),
		value_at_object_respawn_index_back_color, "green")
	gui.text(x_left + fnt_width * 24, y_sh + fnt_height * 4, string.format("%02x", respawn_object_back_offset), "white",
		"green")

	local ort_index_back = value_at_object_respawn_index_back - 0xEB00
	if (ort_index_back == -60160) then
		ort_index_back = 0
	end
	local olm_value_start_offset = mem_read_ubyte(0xFFFE10) * 2 + mem_read_ubyte(0xFFFE11)
	local olm_value_start = mem_read_ulong(0x1e3d98 + olm_value_start_offset * 4)
	local olm_index_back = (value_at_object_load_addr_back - olm_value_start) / 6
	if (olm_index_back < 0) then
		olm_index_back = 0
	end
	-- gui.text(x_left + fnt_width * 32, y_sh + fnt_height * 4,
	-- 	string.format("OLM ID: %d", olm_index_back, "white", "green"))
	-- gui.text(x_left + fnt_width * 47, y_sh + fnt_height * 4,
	-- 	string.format("ORT ID: %d", ort_index_back, "white", "green"))
	-- gui.text(x_left + fnt_width * 60, y_sh + fnt_height * 4,
	-- 	string.format("Diff: %d", olm_index_back - ort_index_back, "white", "green"))

	gui.text(x_left + fnt_width * 0, y_sh + fnt_height * 5,
		"< OLM ID", "green", "black")
	gui.text(x_left + fnt_width * 15, y_sh + fnt_height * 5,
		string.format("#%04d", olm_index_back), "white", "green")
	gui.text(x_left + fnt_width * 22, y_sh + fnt_height * 5,
		"< ORT ID", "green", "black")
	gui.text(x_left + fnt_width * 34, y_sh + fnt_height * 5,
		string.format("#%04d", ort_index_back), value_at_object_respawn_index_back_color, "green")
	gui.text(x_left + fnt_width * 42, y_sh + fnt_height * 5,
		"Diff:", "green", "black")
	gui.text(x_left + fnt_width * 51, y_sh + fnt_height * 5,
		string.format("#%04d", olm_index_back - ort_index_back), "white", "green")

	local value_at_object_load_addr_front = mem_read_ulong(0xFFF772)
	local right_object_offset_in_list = mem_read_ubyte(value_at_object_load_addr_front + 4)
	local x_coord_object_load_addr_front = mem_read_uword(value_at_object_load_addr_front + 0)
	local y_coord_object_load_addr_front = mem_read_uword(value_at_object_load_addr_front + 2)
	local pc_addr_object_load_addr_front = mem_read_ulong(object_list_pointer + right_object_offset_in_list * 4)
	gui.text(x_left, y_sh + fnt_height * 7, "> NEXT OBJECT", "green", "black")
	gui.text(x_left + fnt_width * 14, y_sh + fnt_height * 7,
		string.format("%06x", value_at_object_load_addr_front), "white", "black")
	gui.text(x_left + fnt_width * 22, y_sh + fnt_height * 7,
		string.format("X: %04x", x_coord_object_load_addr_front), "white", "black")
	gui.text(x_left + fnt_width * 32, y_sh + fnt_height * 7,
		string.format("Y: %04x", y_coord_object_load_addr_front), "white", "black")
	gui.text(x_left + fnt_width * 42, y_sh + fnt_height * 7,
		string.format("%02x", right_object_offset_in_list), "white", "black")
	gui.text(x_left + fnt_width * 47, y_sh + fnt_height * 7,
		string.format("ID: %05x", pc_addr_object_load_addr_front), "white", "black")

	local value_at_object_respawn_index_front = mem_read_uword(0xFFF77A)
	local respawn_object_front_offset = mem_read_ubyte(0xFF0000 + value_at_object_respawn_index_front)
	gui.text(x_left, y_sh + fnt_height * 8, "> ORT ADDR", "green", "black")
	gui.text(x_left + fnt_width * 16, y_sh + fnt_height * 8, string.format("%04x", value_at_object_respawn_index_front),
		"white", "green")
	gui.text(x_left + fnt_width * 24, y_sh + fnt_height * 8, string.format("%02x", respawn_object_front_offset), "white",
		"green")

	-- d1 = (mem_read_ubyte(0xFFEE24) * 4 + 4) % 256
	-- d0 = (mem_read_uword(0xFFEE24 + 2))
	-- if ((d0 % 256) - d1) < 0 then
	-- 	d0 = d0 - d1 + 256
	-- else
	-- 	d0 = d0 - d1
	-- end
	-- d0b = (mem_read_uword(0xFFE500 + d0)) % 32768
	-- d0c = d0b - mem_read_uword(0xFFEE78) - 0x90
	--gui.text(x_left, y_sh+fnt_height*5, string.format("%02x - %04x - %04x - %04x", d1, d0, d0b, d0c))

	--gui.text(x_left, y_sh + fnt_height * 4, string.format("$F772 %08x", mem_read_ulong(0xFFF772)), "green", "black") --top
	--gui.text(x_left, y_sh + fnt_height * 5, string.format("$F776 %08x", mem_read_ulong(0xFFF776)), "green", "black") --top

	-- gui.text(x_left, y_sh + fnt_height * 7, string.format("Button Obj Addr: %04x", eggman_address), "white", "black")
	-- gui.text(x_left, y_sh + fnt_height * 8, string.format("RNG value: %08x", mem_read_ulong(0xFFF636)), "white", "black")

	-- local loose_rings = 0
	-- for i = 0, object_limit do
	-- 	local obj_offset = OST_START + i * OST_ENTRY_LENGTH
	-- 	local obj_id = mem_read_ulong(obj_offset)
	-- 	if (obj_id == 0x1a88c) or (obj_id == 0x1a64a) or (obj_id == 0x1a662) then
	-- 		loose_rings = loose_rings + 1
	-- 	end
	-- end

	-- gui.text(x_left, y_sh + fnt_height * 9, string.format("%s %d", "Bouncing/attracted rings:", loose_rings), "white",
	-- 	"black")

	-- local flames = 0
	-- for i = 0, object_limit do
	-- 	local obj_offset = OST_START + i * OST_ENTRY_LENGTH
	-- 	local obj_id = mem_read_ulong(obj_offset)
	-- 	if (obj_id == 0x6998a) then
	-- 		flames = flames + 1
	-- 	end
	-- end

	-- gui.text(x_left, y_sh + fnt_height * 12, string.format("%s %d", "Flames:", flames), "white",
	-- 	"black")

	local dynamic_objects_spawned_now = count_dynamic_objects()
	local dynamic_objects_spawned_now_text_color = "white"
	if dynamic_objects_spawned_now == 90 then
		dynamic_objects_spawned_now_text_color = "red"
	end
	gui.text(x_left, y_sh + fnt_height * 10,
		"DOSST Count now:", "green", "black")
	gui.text(x_left + fnt_width * 30, y_sh + fnt_height * 10,
		string.format("#%02d", dynamic_objects_spawned_now),
		dynamic_objects_spawned_now_text_color, "black")

	local dynamic_objects_spawned_when_moving_left_text_color = "white"
	if (dynamic_objects_spawned_when_moving_left == 90) then
		dynamic_objects_spawned_when_moving_left_text_color = "red"
	end
	gui.text(x_left, y_sh + fnt_height * 11,
		"DOSST Count when moving left:", "green", "black")
	gui.text(x_left + fnt_width * 30, y_sh + fnt_height * 11,
		string.format("#%02d", dynamic_objects_spawned_when_moving_left),
		dynamic_objects_spawned_when_moving_left_text_color, "black")

	-- for i = 0, 3 do
	-- 	local offset = 0x64 + i * 6
	-- 	local source_module_location = mem_read_ulong(0xFFFF00 + offset)
	-- 	local destination_vram_location = mem_read_uword(0xFFFF00 + offset + 4)
	-- 	local text_color = "white"
	-- 	if source_module_location ~= 0 then
	-- 		text_color = "red"
	-- 	end

	-- 	gui.text(x_left, y_sh + fnt_height * (13 + i),
	-- 		string.format("KMDQQ slot %02d: %02x %08x %04x", i + 1, offset,
	-- 			source_module_location, destination_vram_location),
	-- 		text_color, "black")
	-- end
	-- for i = 0, 9 do
	-- 	local offset = 0x7C + i * 6
	-- 	local source_module_location = mem_read_ulong(0xFFFF00 + offset)
	-- 	local destination_vram_location = mem_read_uword(0xFFFF00 + offset + 4)
	-- 	local text_color = "white"
	-- 	if source_module_location ~= 0 then
	-- 		text_color = "red"
	-- 	end

	-- 	gui.text(x_left, y_sh + fnt_height * (17 + i),
	-- 		string.format("Chaos slot %02d: %02x %08x %04x", i + 1, offset,
	-- 			source_module_location, destination_vram_location),
	-- 		text_color, "black")
	-- end

	local sram_color = "white"
	local valid_stage = mem_read_ubyte(0xFFFE10) == 0x05
	if valid_stage and (mem_read_ubyte(0xFFE6F2) == 0x80 or mem_read_ubyte(0xFFE6F2) == 0x81) then
		sram_color = "yellow"
	elseif mem_read_ubyte(0xFFE6F2) == 0x01 and mem_read_ubyte(0xFFE6F5) < 80 then
		sram_color = "orange"
	elseif mem_read_ubyte(0xFFE6F2) == 0x01 and mem_read_ubyte(0xFFE6F5) >= 80 then
		sram_color = "cyan"
	end

	gui.text(x_left, y_sh + fnt_height * 12,
		"SRAM Cache Slot 08:", "green", "black")
	gui.text(x_left + fnt_width * 21, y_sh + fnt_height * 12,
		string.format("%08x", mem_read_ulong(0xFFE6F2)),
		sram_color, "black")
	gui.text(x_left + fnt_width * 29, y_sh + fnt_height * 12,
		string.format("%08x", mem_read_ulong(0xFFE6F6)),
		sram_color, "black")
	gui.text(x_left + fnt_width * 37, y_sh + fnt_height * 12,
		string.format("%08x", mem_read_uword(0xFFE6FA)),
		sram_color, "black")

	gui.text(x_left, y_sh + fnt_height * 13,
		"SRAM Cache Checksum:", "green", "black")
	local sram_cache_checksum = mem_read_uword(0xFFE6FC)
	local sram_cache_color = "white"
	if (sram_cache_checksum ~= 0x4244) then
		sram_cache_color = "red"
	end
	gui.text(x_left + fnt_width * 21, y_sh + fnt_height * 13,
		string.format("%04x", sram_cache_checksum),
		sram_cache_color, "black")

	local bad_snow_count = 0
	for i = 0, object_limit do
		local obj_offset = OST_START + i * OST_ENTRY_LENGTH
		local obj_id = mem_read_ulong(obj_offset)
		if (obj_id == 0x8b73a) then
			bad_snow_count = bad_snow_count + 1
		end
	end

	gui.text(x_left, y_sh + fnt_height * 14,
		"Bad Snow Count:", "green", "black")
	gui.text(x_left + fnt_width * 18, y_sh + fnt_height * 14,
		string.format("#%02d", bad_snow_count))
end

met_overlayvis = { sr_overlayvis, sr_nil, sr_nil, sr_nil }
met_rampageprev = { sr_rampageprev, sr_nil, sr_nil, sr_nil }
met_rampagenext = { sr_rampagenext, sr_nil, sr_nil, sr_nil }

table.insert(persistent_functions, overlay)

function count_dynamic_objects()
	local count = 0
	for i = 0xFFB128, 0xFFCAE2, 0x4A do
		if mem_read_uword(i) ~= 0 then
			count = count + 1
		end
	end
	return count
end

function on_overlay_bus_exec(address)
	dynamic_objects_spawned_when_moving_left = count_dynamic_objects()
end

function on_overlay_bus_write(address, value)
	on_overlay_bus_exec(address)
end

function trace(address, value)
	console.write(string.format("[%08x] Trace write to %08x with value %08x\n", emu.getregister("M68K PC"), address, value))
end

event.on_bus_exec(on_overlay_bus_exec, 0x01B8A8)
-- event.on_bus_exec(on_overlay_bus_exec, 0x01CB66)
event.onloadstate(on_overlay_bus_exec)
