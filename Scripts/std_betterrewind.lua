-- Rewind script
-- Will rewind emulation upon pressing a specific key
-- Original script by: deltaphc
-- Modified by: Chrezm

-- Test compatibility
if not pcall(function() sav_create() end) then
	mnv_error('std_betterrewind.lua is not compatible with the current emulator. Please try a different one.')
end
-- Constants
max_states = 600    -- maximum number of states allowed
rewind_interval = 2 -- save state every N frames

states = {}
current_state = 1
rewind_counter = rewind_interval - 1
rewinding = false

function sr_rewindon()
	rewinding = true
end

function sr_rewindoff()
	rewinding = false
end

function rewind()
	if rewinding then
		current_state = current_state - 1
		if current_state < 1 then current_state = 1 end

		sav_load(states[current_state])
		table.remove(states, current_state + 1)
	else
		rewind_counter = rewind_counter + 1

		if rewind_counter == rewind_interval then
			rewind_counter = 1

			if current_state < max_states then
				local state = sav_create()
				sav_save(state)
				table.insert(states, state)

				current_state = current_state + 1
			else
				table.remove(states, 1)

				local state = sav_create()
				sav_save(state)
				table.insert(states, state)
			end
		end
	end
end

met_betterrewind = {sr_rewindon,sr_rewindon,sr_rewindon,sr_rewindoff}
table.insert(persistent_functions, rewind)