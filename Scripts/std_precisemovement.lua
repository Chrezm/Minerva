if CHR1_X == nil then CHR1_X = OST_START+OBJ_X end
if CHR1_SPX == nil then CHR1_SPX = OST_START+OBJ_SPX end
if CHR1_Y == nil then CHR1_Y = OST_START+OBJ_Y end
if CHR1_SPY == nil then CHR1_SPY = OST_START+OBJ_SPY end

function sr_moveup()
	local px = mem_read_uword(CHR1_Y)
	local sp = mem_read_ubyte(CHR1_SPY)
	if keys[cs_spkeys[1]] ~= nil then
		px = px - 1
	else
		sp = sp - 1
		if sp < 0 then
			px = px - 1
			sp = 255
		end
	end
	mem_write_uword(CHR1_Y,px)
	mem_write_ubyte(CHR1_SPY,sp)
end

function sr_movedown()
	local px = mem_read_uword(CHR1_Y)
	local sp = mem_read_ubyte(CHR1_SPY)
	
	if keys[cs_spkeys[1]] ~= nil then
		px = px + 1
	else
		sp = sp + 1
		if sp > 255 then
			px = px + 1
			sp = 0
		end
	end
	mem_write_uword(CHR1_Y,px)
	mem_write_ubyte(CHR1_SPY,sp)
end

function sr_moveleft()
	local px = mem_read_uword(CHR1_X)
	local sp = mem_read_ubyte(CHR1_SPX)
	
	if keys[cs_spkeys[1]] ~= nil then
		px = px - 1
	else
		sp = sp - 1
		if sp < 0 then
			px = px - 1
			sp = 255
		end
	end
	mem_write_uword(CHR1_X,px)
	mem_write_ubyte(CHR1_SPX,sp)
end

function sr_moveright()
	local px = mem_read_uword(CHR1_X)
	local sp = mem_read_ubyte(CHR1_SPX)
	
	if keys[cs_spkeys[1]] ~= nil then
		px = px + 1
	else
		sp = sp + 1
		if sp > 255 then
			px = px + 1
			sp = 0
		end
	end
	mem_write_uword(CHR1_X,px)
	mem_write_ubyte(CHR1_SPX,sp)
end

met_moveup = {sr_moveup,sr_moveup,sr_nil,sr_nil}
met_movedown = {sr_movedown,sr_movedown,sr_nil,sr_nil}
met_moveleft = {sr_moveleft,sr_moveleft,sr_nil,sr_nil}
met_moveright = {sr_moveright,sr_moveright,sr_nil,sr_nil}