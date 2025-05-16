local mod = get_mod("BackstabEarDestruction")
mod.version = "1.0"

--#################################
-- Requirements
--#################################
-- scripts/settings/minion_backstab/minion_backstab_settings.lua

--#################################
-- Helper Functions
--#################################
local debug
local useAudio
local replaceMelee
local replaceMeleeElite
local replaceRanged

local replace_nonaudio_melee
local replace_nonaudio_melee_choice
local replace_nonaudio_melee_elite
local replace_nonaudio_melee_elite_choice
local replace_nonaudio_ranged
local replace_nonaudio_ranged_choice
local replacement_table_melee
local replacement_table_melee_elite
local replacement_table_ranged

local Audio
local audio_files

-- #############
-- Split String by Period
-- Description: Splits the given string, using a period as a delimiter, then inserts each substring into the given table
-- Given:
--  string
--  table
--  bool
-- Returns: the filled up table
local function split_string_by_period(string_to_split, table_to_insert_into, debug)
    -- Splits value into keys 
    --  %. escapes the magic character (period)
    --  [^%.] match anything that's not a period
    --  [^%.]+ match the longest string of not periods
    for v in string.gmatch(string_to_split, "[^%.]+") do 
        table.insert(table_to_insert_into, v)
        if debug then mod:echo("Split string result: "..tostring(v)) end
    end
    return table_to_insert_into
end

-- "wwise/events/player/play_backstab_indicator_melee"
-- "wwise/events/player/play_backstab_indicator_melee_elite"
-- "wwise/events/player/play_backstab_indicator_ranged"
local function replaceTheSound()
    debug = mod:get("enable_debug_mode")
    useAudio = mod:get("use_audio")

    -- User is NOT using Audio plugin, so get option from dropdown
    -- Replace the sound then return
    if not useAudio then
        replace_nonaudio_melee = mod:get("replace_nonaudio_melee")
        
        replace_nonaudio_melee_elite = mod:get("replace_nonaudio_melee_elite")
        replace_nonaudio_melee_elite_choice = mod:get("replace_nonaudio_melee_elite_choice")
        replace_nonaudio_ranged = mod:get("replace_nonaudio_ranged")
        replace_nonaudio_ranged_choice = mod:get("replace_nonaudio_ranged_choice")

        if replace_nonaudio_melee then
            replace_nonaudio_melee_choice = mod:get("replace_nonaudio_melee_choice")
            replacement_table_melee = {}

            replacement_table_melee = split_string_by_period(replace_nonaudio_melee_choice, replacement_table_melee, debug)

            if debug then 
                mod:echo("Replacement Sound is: "..replace_nonaudio_melee_choice)
                mod:echo("Replacing minion_backstab_settings.melee_backstab_event with: "..PlayerCharacterSoundEventAliases[replacementTable[1]][replacementTable[2]][replacementTable[3]]) 
            end
        end

        if debug then 
            mod:echo("Replacement Sound is: "..replacementSound)
            mod:echo("Replacing sfx_scanning_sucess.events.scanner_equip with: "..PlayerCharacterSoundEventAliases[replacementTable[1]][replacementTable[2]][replacementTable[3]]) 
        end
        PlayerCharacterSoundEventAliases.sfx_scanning_sucess.events.scanner_equip = PlayerCharacterSoundEventAliases[replacementTable[1]][replacementTable[2]][replacementTable[3]]
        mod:echo("not implemented yet")
        return
    end
    -- User is using Audio plugin
    Audio = get_mod("Audio")
    
    replaceMelee = mod:get("replace_indicator_melee")
    replaceMeleeElite = mod:get("replace_indicator_melee_elite")
    replaceRanged = mod:get("replace_indicator_ranged")

    if not Audio then
        mod:error("Audio plugin is required for this option!")
        return
    end
    audio_files = Audio.new_files_handler()
    if replaceMelee then 
        Audio.hook_sound("play_backstab_indicator_melee", function(sound_type, sound_name, delta)
            if delta == nil or delta > 0.1 then
                Audio.play_file(audio_files:random("melee"), { audio_type = "sfx" })
            end
            return false
        end)
    end
    if replaceMeleeElite then
        Audio.hook_sound("play_backstab_indicator_melee_elite", function(sound_type, sound_name, delta)
            if delta == nil or delta > 0.1 then
                Audio.play_file(audio_files:random("melee_elite"), { audio_type = "sfx" })
            end
            return false
        end)
    end
    if replaceRanged then
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
    replaceTheSound()
end
mod.on_setting_changed = function()
    replaceTheSound()
end