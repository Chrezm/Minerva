-- BOOTUP CONSTANTS --
show_1p_last_stood_on = true
show_2p_last_stood_on = true
show_2p_last_visible_stood_on = false
id_is_word = false --Sonic 2 uses object ID
show_object_list = true
aux = 0

-- GAME CONSTANTS --
OST_START = 0xFFB000
OST_START_SHR = OST_START % 0x10000
OST_ENTRY_LENGTH = 0x40
OST_END = 0xFFD5FF

PLAYER1 = OST_START
PLAYER1_SHR = OST_START_SHR
PLAYER2 = OST_START + OST_ENTRY_LENGTH
PLAYER2_SHR = OST_START_SHR + OST_ENTRY_LENGTH

OBJ_WD = 0x19 --Width
OBJ_X = 0x08
OBJ_SPX = 0x0A
OBJ_Y = 0x0C
OBJ_SPY = 0x0E
OBJ_STAT_FIELD = 0x22
OBJ_ROUT_CNT = 0x24
OBJ_LASTON = 0x3D

SCR_X = 0xFFEE00
SCR_Y = 0xFFEE04

SCR_LOCK_L = 0xFFEEC8
SCR_LOCK_R = 0xFFEECA
SCR_LOCK_T = 0xFFEECC
SCR_LOCK_B = 0xFFEECE

--Sonic 2 does not really have target locks except for the bottom one
SCR_TARG_LOCK_L = 0xFFEEC8
SCR_TARG_LOCK_R = 0xFFEECA
SCR_TARG_LOCK_T = 0xFFEECC
SCR_TARG_LOCK_B = 0xFFEEC6

DEBUG_FLAG = 0xFFFFFA
SLOWMO_FLAG = 0xFFFFD1
LAST_CHKP = 0xFFFE30
STG_RESTART = 0xFFFE02

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
