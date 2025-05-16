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

local replacementSound
local replacementTable

local Audio
local audio_files

-- "wwise/events/player/play_backstab_indicator_melee"
-- "wwise/events/player/play_backstab_indicator_melee_elite"
-- "wwise/events/player/play_backstab_indicator_ranged"
local function replaceTheSound()
    debug = mod:get("enable_debug_mode")
    useAudio = mod:get("use_audio")
    replaceMelee = mod:get("replace_indicator_melee")
    replaceMeleeElite = mod:get("replace_indicator_melee_elite")
    replaceRanged = mod:get("replace_indicator_ranged")

    -- User is NOT using Audio plugin, so get option from dropdown
    -- Replace the sound then return
    if not useAudio then
        --replacementSound = mod:get("scan_sound")
        ---- Default Case. Directly replace with the sound and gtfo
        --if replacementSound == "sfx_scanning_sucess.events.scanner_equip" then
        --    PlayerCharacterSoundEventAliases.sfx_scanning_sucess.events.scanner_equip = "wwise/events/player/play_scanner_collect_success"
        --    return
        --end
--
        --replacementTable = {}
        ---- Splits value into keys 
        ----  %. escapes the magic character (period)
        ----  [^%.] match anything that's not a period
        ----  [^%.]+ match the longest string of not periods
        --for v in string.gmatch(replacementSound, "[^%.]+") do 
        --    table.insert(replacementTable, v)
        --    if debug then mod:echo("Split string result: "..tostring(v)) end
        --end
--
        --if debug then 
        --    mod:echo("Replacement Sound is: "..replacementSound)
        --    mod:echo("Replacing sfx_scanning_sucess.events.scanner_equip with: "..PlayerCharacterSoundEventAliases[replacementTable[1]][replacementTable[2]][replacementTable[3]]) 
        --end
        --PlayerCharacterSoundEventAliases.sfx_scanning_sucess.events.scanner_equip = PlayerCharacterSoundEventAliases[replacementTable[1]][replacementTable[2]][replacementTable[3]]
        mod:echo("not implemented yet")
        return
    end
    -- User is using Audio plugin
    Audio = get_mod("Audio")
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