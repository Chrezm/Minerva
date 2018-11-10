-- PARAMETERS THAT CAN BE MODIFIED --
emulator = 'emu_gens' --Your emulator
game = 'scr_s3k' --Your game
additional_scripts = {'std_betterrewind'} --Additional scripts. If no additional scripts, put {}
base_path = 'C:/Users/ACER/Desktop/Games/Emulators/Gens Rerecording 11c/Minerva/'

-- DO NOT MODIFY THE CODE BELOW THIS LINE --
-- 
-- Initialisation
--

cs_keys = {}
cs_keydelay = {}
cs_spkeys = {'LeftShift'}
keys = input.get()
prevkeys = {}
persistent_functions = {}

version = '1.0.0'
print(string.format("---\r\nWelcome to Minerva v. %s\r\n---",version))

int_scripts_to_run = {emulator}
for i,name in pairs(additional_scripts) do
	table.insert(int_scripts_to_run, name)
end
table.insert(int_scripts_to_run, game)

function sr_nil()
end

--
-- Error handler
--
function xcall(func, args, error_handler, error_message)
	ok, err = pcall(function() func(args) end)
	if not ok then
		if error_handler == nil then
			error_handler = lua_error
		end
		
		if error_message ~= nil then
			error_handler(error_message)
		else
			error_handler(err)
		end
	end
end

function mnv_error(current_error)
	message = '\r\n---\r\nERROR: Minerva ran into a procedure error. \r\n---\r\nERROR MESSAGE:\r\n'
	message = string.format('%s%s',message,current_error)
	print(message)
	error()
end

function lua_error(current_error)
	if current_error ~= nil then
		message = '\r\n---\r\n ERROR: Minerva ran into a Lua error. \r\n'
		
		-- Traceback
		message = string.format('%s%s',message,'---\r\nSTACK TRACEBACK (most recent call first)')
		traceback = debug.traceback()
		_, relevant = string.find(traceback, "call'")
		traceback = string.sub(traceback, relevant+1)
		traceback = string.gsub(traceback,"%.%.%.","\r\n%.%.%.")
		traceback = string.gsub(traceback,"\t","")
		message = string.format('%s%s',message,traceback)
		
		-- Current error
		message = string.format('%s%s',message,'\r\n---\r\nERROR MESSAGE')
		current_error = string.gsub(current_error,'%.%.%.','\r\n%.%.%.')
		current_error = string.gsub(current_error,"\t","\r\n")
		message = string.format("%s%s",message,current_error)
		print(message)
	end
	error()
end
	
--
-- Deal with script loading
--
package.path = string.format("%s%s", base_path, 'Scripts/?.lua')

-- Use this function when requiring scripts, as some emulators will keep
-- the same Lua environment on error when you boot again, which will cause
-- a looping issue; this makes sure to clear the package from memory if
-- already loaded
function crequire(name)
	package.loaded[name] = nil
	f = io.open(string.format("%sScripts/%s.lua",base_path,name),'r')
	if f == nil then
		mnv_error(string.format('File %sScripts/%s.lua not found. Are you sure your base_path in minerva.lua is set correctly and that you are calling the right scripts?',base_path,name))
	end
	io.close(f)
	require(name) 
end

-- Use this function when requiring multiple scripts (script_list is a table)
function load_scripts(script_list)				
	for i,name in pairs(script_list) do
		print(string.format('Loading script: %s',name))
		crequire(name) 
		print(string.format('Loaded script: %s',name))
		short_name = string.sub(name,5,-1)
		default_inp_file = io.open(string.format("%sScripts/%s%s.lua",base_path,'inpd_',short_name),'r')
		normal_inp_file = io.open(string.format("%sScripts/%s%s.lua",base_path,'inp_',short_name),'r')
		if default_inp_file and normal_inp_file then
			io.close(default_inp_file)
			io.close(normal_inp_file)
			mnv_error(string.format('Detected conflicting existing input files %s%s.lua and %s%s.lua. Please merge both input files into the former one, delete the latter one, then restart the script.','inp_',short_name,'inpd_',short_name))
		elseif default_inp_file and not normal_inp_file then
			io.close(default_inp_file)
			os.rename(string.format("%sScripts/%s%s.lua",base_path,'inpd_',short_name), string.format("%sScripts/%s%s.lua",base_path,'inp_',short_name))
			--os.rename(string.format("%s%s",'inpd_',short_name), string.format("%s%s",'inp_',short_name))
			print(string.format('Set up default key values for %s (first time running this script).',short_name))
			crequire(string.format("inp_%s",short_name))
		elseif normal_inp_file then
			io.close(normal_inp_file)
			crequire(string.format("inp_%s",short_name))
		end
	end
end

xcall(load_scripts, int_scripts_to_run)
print('Finished loading scripts.')

--
-- Deal with keyboard inputs
--
for i,key in pairs(cs_keys) do
	cs_keydelay[key[1]] = -1
end

function recognize_keys()
	keys = input.get()
	keychain = ""
		
	for i, key in pairs(cs_keys) do
		if keys[key[1]] then
			if cs_keydelay[key[1]] == -1 then
				cs_keydelay[key[1]] = 20
				if not pcall(function() cs_keys[i][2][1]() end) then
					mnv_error(string.format('Selected key %s is declared in the input file but is not associated to a valid command.',key[1]))
				end
			elseif cs_keydelay[key[1]] == 0 then
				cs_keydelay[key] = 1
				cs_keys[i][2][2]()
			else
				cs_keydelay[key[1]] = cs_keydelay[key[1]] - 1
				cs_keys[i][2][3]()
			end
		else
			if prevkeys[key[1]] then
				cs_keydelay[key[1]] = -1
				cs_keys[i][2][4]()
			end
		end
	end
	prevkeys = input.get()
end

table.insert(persistent_functions, 1, recognize_keys) --Keys should be polled first

--
-- Execute the persistent functions (functions that should be called every
-- frame, like say, overlays)
--
do_functions = function()
	for i,func in pairs(persistent_functions) do
		xcall(func)
	end
end

gui_register(do_functions)
