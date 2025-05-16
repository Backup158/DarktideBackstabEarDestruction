local mod = get_mod("BackstabEarDestruction")
mod.version = "1.1"

--#################################
-- Requirements
--#################################
-- scripts/settings/minion_backstab/minion_backstab_settings.lua
local MinionBackstabSettings = require("scripts/settings/minion_backstab/minion_backstab_settings")
-- UI Sounds
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")

--#################################
-- Helper Functions
--#################################
local debug
local use_audio_plugin

local replace_melee
local replace_melee_elite
local replace_ranged
local replace_nonaudio_melee
local replace_nonaudio_melee_choice
local replace_nonaudio_melee_elite
local replace_nonaudio_melee_elite_choice
local replace_nonaudio_ranged
local replace_nonaudio_ranged_choice
--local replacement_table_melee
--local replacement_table_melee_elite
--local replacement_table_ranged

local Audio
local audio_files

-- #############
-- Split String by Period
-- #############
-- Description: Splits the given string, using a period as a delimiter, then inserts each substring into the given table
-- Given:
--  string
--  table
--  bool
-- Returns: the filled up table
-- NOTE: turns out there's only one level in these tables
--local function split_string_by_period(string_to_split, debug)
--    table_to_insert_into = {}
--    -- Splits value into keys 
--    --  %. escapes the magic character (period)
--    --  [^%.] match anything that's not a period
--    --  [^%.]+ match the longest string of not periods
--    for v in string.gmatch(string_to_split, "[^%.]+") do 
--        table.insert(table_to_insert_into, v)
--        if debug then mod:echo("Split string result: "..tostring(v)) end
--    end
--    return table_to_insert_into
--end

-- #############
-- Replace a Backstab Sound
-- #############
-- Description: replaces the specified backstab sound with the given sound from the UI
-- Given
--  string: key from ui sounds table
--  string: key from backstab settings table
--  bool: debug mode from mod options
local function replace_this_backstab_sound(replacement_sound_key, original_backstab_event_id, debug)
    local replacement_wwise_event_string = UISoundEvents[replacement_sound_key]
    if debug then 
        mod:echo("Replacement Sound is: "..replacement_sound_key)
        mod:echo("Replacing (in minion_backstab_settings) "..original_backstab_event_id.." with: "..tostring(replacement_wwise_event_string)) 
    end
    MinionBackstabSettings[original_backstab_event_id] = replacement_wwise_event_string
end

local function reset_sounds()
    MinionBackstabSettings.melee_backstab_event = "wwise/events/player/play_backstab_indicator_melee"
    MinionBackstabSettings.melee_elite_backstab_event = "wwise/events/player/play_backstab_indicator_melee_elite"
    MinionBackstabSettings.ranged_backstab_event = "wwise/events/player/play_backstab_indicator_ranged"
end

-- "wwise/events/player/play_backstab_indicator_melee"
-- "wwise/events/player/play_backstab_indicator_melee_elite"
-- "wwise/events/player/play_backstab_indicator_ranged"
local function replace_sounds()
    debug = mod:get("enable_debug_mode")
    use_audio_plugin = mod:get("use_audio")

    -- User is NOT using Audio plugin, so get option from dropdown
    -- Replace the sound then return
    if not use_audio_plugin then
        replace_nonaudio_melee = mod:get("replace_nonaudio_melee")
        replace_nonaudio_melee_elite = mod:get("replace_nonaudio_melee_elite")
        replace_nonaudio_ranged = mod:get("replace_nonaudio_ranged")

        -- Melee
        if replace_nonaudio_melee then
            replace_nonaudio_melee_choice = mod:get("replace_nonaudio_melee_choice")
            replace_this_backstab_sound(replace_nonaudio_melee_choice, "melee_backstab_event", debug)
        end
        -- Melee Elite
        if replace_nonaudio_melee_elite then
            replace_nonaudio_melee_elite_choice = mod:get("replace_nonaudio_melee_elite_choice")
            replace_this_backstab_sound(replace_nonaudio_melee_elite_choice, "melee_elite_backstab_event", debug)
        end
        -- Ranged
        if replace_nonaudio_ranged then
            replace_nonaudio_ranged_choice = mod:get("replace_nonaudio_ranged_choice")
            replace_this_backstab_sound(replace_nonaudio_ranged_choice, "ranged_backstab_event", debug)
        end

        -- Important!
        -- This return makes it so it won't move on and try to use the audio plugin, since this segment of code only executes when NOT using audio
        return
    end

    -- User is using Audio plugin
    Audio = get_mod("Audio")

    -- Reset to default
    reset_sounds()

    -- Replace sounds    
    replace_melee = mod:get("replace_indicator_melee")
    replace_melee_elite = mod:get("replace_indicator_melee_elite")
    replace_ranged = mod:get("replace_indicator_ranged")

    if not Audio then
        mod:error("Audio plugin is required for this option!")
        return
    end
    audio_files = Audio.new_files_handler()
    if replace_melee then 
        Audio.hook_sound("play_backstab_indicator_melee", function(sound_type, sound_name, delta)
            if delta == nil or delta > 0.1 then
                Audio.play_file(audio_files:random("melee"), { audio_type = "sfx" })
            end
            return false
        end)
    end
    if replace_melee_elite then
        Audio.hook_sound("play_backstab_indicator_melee_elite", function(sound_type, sound_name, delta)
            if delta == nil or delta > 0.1 then
                Audio.play_file(audio_files:random("melee_elite"), { audio_type = "sfx" })
            end
            return false
        end)
    end
    if replace_ranged then
        Audio.hook_sound("play_backstab_indicator_ranged", function(sound_type, sound_name, delta)
            if delta == nil or delta > 0.1 then
                Audio.play_file(audio_files:random("ranged"), { audio_type = "sfx" })
            end
            return false
        end)
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