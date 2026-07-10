local mod = get_mod("BackstabEarDestruction")
mod.version = "1.1.0"

--#################################
-- Requirements
--#################################

--#################################
-- Helper Functions
--#################################
local debug
local backstab_events = mod.backstab_events

mod.initialized = false

local replace_melee
local replace_melee_elite
local replace_ranged

local Audio
local audio_files
local simple_audio
local simple_audio_random = {}

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

    -- Audio maxes at 100%
    if volume_int > 100 then
        volume_int = 100
    end

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

-- ######
-- Simple Audio Hook sound
-- ######
local function simple_audio_replace_backstab_sound(given_audio_plugin, audio_files_manager, which_sound, volume_int)
    -- SA needs the $ at the end to terminate the regex. Otherwise it wildcard matchs for you
    local event_to_replace = "play_backstab_indicator_"..which_sound.."$"
    if debug then mod:echo("Replacing "..event_to_replace.." with volume "..tostring(volume_int)) end

    given_audio_plugin.hook_sound(event_to_replace, function(sound_type, sound_name, delta)
        -- Delta debounce so only 10 can play per second
        if delta == nil or delta > 0.1 then
            audio_files_manager:play({ 
                audio_type = "sfx", 
                volume = volume_int or 100, 
            })
        end
        -- Silence original
        return false
    end)
end

local function replace_one_sound(which_sound) 
    local volume_replace =  mod:get("replacement_sound_volume_"..which_sound)
    if simple_audio then
        simple_audio_replace_backstab_sound(simple_audio, simple_audio_random[which_sound], which_sound, volume_replace)
    elseif Audio then
        audio_replace_backstab_sound(Audio, audio_files, which_sound, volume_replace)
    else
        mod:info("how tf did you get here")
    end
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
    simple_audio = get_mod("SimpleAudio")
    if simple_audio then
        simple_audio_random.melee = simple_audio.glob("melee/*")
        simple_audio_random.melee_elite = simple_audio.glob("melee_elite/*")
        simple_audio_random.ranged = simple_audio.glob("ranged/*")
    elseif Audio then
        audio_files = Audio.new_files_handler()
    else
        mod:error(mod:localize("error_missing_audio_framework"))
        return
    end

    -- Replace sounds    
    for i = 1, #backstab_events do
        local sound = backstab_events[i]
        if mod:get("replace_indicator_"..sound) then
            replace_one_sound(sound)
        end
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

-- Replaces sound on whatever state changes. By then, the backend should've caught up.
function mod.on_game_state_changed(status, state_name)
    if not mod.initialized then
        replace_sounds()
    end
end
mod.on_game_state_changed("exit", "StateMainMenu") -- Upon choosing character