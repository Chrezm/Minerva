-- BOOTUP CONSTANTS --
show_1p_last_stood_on = true
show_2p_last_stood_on = true
show_2p_last_visible_stood_on = true
id_is_word = true --Sonic 3 & Knuckles uses RAM addresses
show_object_list = true
aux = fnt_width*4 -- Sonic 3 & Knuckles requires 5-wide IDs, so add 4 extra spaces

-- GAME CONSTANTS --
OST_START = 0xFFB000
OST_START_SHR = OST_START % 0x10000
OST_ENTRY_LENGTH = 0x4A
OST_END = 0xFFCFFF

PLAYER1 = OST_START
PLAYER1_SHR = OST_START_SHR
PLAYER2 = OST_START + OST_ENTRY_LENGTH
PLAYER2_SHR = OST_START_SHR + OST_ENTRY_LENGTH

OBJ_WD = 0x07 --Width
OBJ_X = 0x10
OBJ_SPX = 0x12
OBJ_Y = 0x14
OBJ_SPY = 0x16
OBJ_STAT_FIELD = 0x2A
OBJ_ROUT_CNT = 0x05
OBJ_LASTON = 0x42

SCR_X = 0xFFEE78
SCR_Y = 0xFFEE7C

SCR_LOCK_L = 0xFFEE14
SCR_LOCK_R = 0xFFEE16
SCR_LOCK_T = 0xFFEE18
SCR_LOCK_B = 0xFFEE1A

SCR_TARG_LOCK_L = 0xFFEE0C
SCR_TARG_LOCK_R = 0xFFEE0E
SCR_TARG_LOCK_T = 0xFFEE10
SCR_TARG_LOCK_B = 0xFFEE12

DEBUG_FLAG = 0xFFFFDA
SLOWMO_FLAG = 0xFFFFDA
LAST_CHKP = 0xFFFE2A
STG_RESTART = 0xFFFE02

PLY2_LAST_VISIBLE_STOOD_ON = 0xFFF700

-- LOAD SUBSCRIPTS --
subscripts_to_run = {'std_precisemovement', 'std_slotsonobjects', 'std_overlay', 'std_bettersonicdebug'}
load_scripts(subscripts_to_run)

-- CUSTOM SCRIPTS --

--[[
Parameter syntax: 
-Thing to do on key press (only one frame)
-Thing to do when assumed key delay expires, 
-Thing to do while key delay is counting down
-Thing to do when key is released (only one frame)
]]
