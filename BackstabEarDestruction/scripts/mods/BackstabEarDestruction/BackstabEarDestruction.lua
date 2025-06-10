local mod = get_mod("BackstabEarDestruction")
mod.version = "1.0.3ns"

--#################################
-- Requirements
--#################################

--#################################
-- Helper Functions
--#################################
local debug

mod.initialized = false

local replace_melee
local replace_melee_elite
local replace_ranged

local Audio
local audio_files

-- ######
-- Audio Hook sound
-- ######
-- Given:
--  object: audio plugin
--  object: audio files handler for random
--  string: the end part of the backstab event name
--  int: volume for sound
local function audio_replace_backstab_sound(given_audio_plugin, audio_files_manager, which_sound, volume_int)
    local event_to_replace = "play_backstab_indicator_"..which_sound
    if debug then mod:echo("Replacing "..event_to_replace.." with volume "..tostring(volume_int)) end

    given_audio_plugin.hook_sound(event_to_replace, function(sound_type, sound_name, delta)
        -- Delta debounce so only 10 can play per second
        if delta == nil or delta > 0.1 then
            given_audio_plugin.play_file(audio_files_manager:random(which_sound), 
                { 
                    audio_type = "sfx", 
                    volume = volume_int, 
                }
            )
        end
        -- Silence original
        return false
    end)
end

-- "wwise/events/player/play_backstab_indicator_melee"
-- "wwise/events/player/play_backstab_indicator_melee_elite"
-- "wwise/events/player/play_backstab_indicator_ranged"
local function replace_sounds()
    debug = mod:get("enable_debug_mode")

    -- Check if game backend caught up yet
    --  The max I will wait is 10 prints. That's probably not many milliseconds but it should avoid the deadlocks.
    for iterations = 1, 10 do
        if Managers.backend._initialized then -- ty tickbox
            if debug then mod:info("Backend initialized after ~"..tostring(iterations).." seconds") end
            mod.initialized = true
            break
        else
            if debug then mod:info("sleepy time :3 "..tostring(iterations)) end
            mod:info("tick tock")
        end
    end
    -- If backend hasn't caught up, leave so we can try again later
    if not mod.initialized then
        return
    end

    -- User is using Audio plugin
    Audio = get_mod("Audio")
    if not Audio then
        mod:error("Audio plugin is required for this option!")
        return
    end

    -- Replace sounds    
    replace_melee = mod:get("replace_indicator_melee")
    replace_melee_elite = mod:get("replace_indicator_melee_elite")
    replace_ranged = mod:get("replace_indicator_ranged")

    audio_files = Audio.new_files_handler()

    if replace_melee then 
        local volume_replace_melee = mod:get("replacement_sound_volume_melee")
        audio_replace_backstab_sound(Audio, audio_files, "melee", volume_replace_melee)
    end
    if replace_melee_elite then
        local volume_replace_melee_elite = mod:get("replacement_sound_volume_melee_elite")
        audio_replace_backstab_sound(Audio, audio_files, "melee_elite", volume_replace_melee_elite)
    end
    if replace_ranged then
        local volume_replace_ranged = mod:get("replacement_sound_volume_ranged")
        audio_replace_backstab_sound(Audio, audio_files, "ranged", volume_replace_ranged)
    end

end

--#################################
-- Hooks and Execution
--#################################
mod.on_all_mods_loaded = function()
    mod:info("BackstabEarDestruction v" .. mod.version .. " loaded uwu nya :3")
    replace_sounds()
end
mod.on_setting_changed = function()
    replace_sounds()
end
-- Replaces sound after loadscreens. By now, the backend should've caught up.
function mod.on_game_state_changed(status, state_name)
    if not mod.initialized then
        replace_sounds()
    end
end
mod.on_game_state_changed("exit", "StateMainMenu") -- Upon choosing character