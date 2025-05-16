local mod = get_mod("BackstabEarDestruction")
mod.version = "1.0.2"

--#################################
-- Requirements
--#################################

--#################################
-- Helper Functions
--#################################
local debug

local replace_melee
local replace_melee_elite
local replace_ranged

local Audio
local audio_files

-- ######
-- Sleep
-- ######
-- DESCRIPTION: Waits n seconds. In most systems (POSIX-compliant, Windows, some others), os.time is measured in seconds
-- GIVEN: 
--  int
-- RETURNS: N/A
local function sleep(seconds_to_wait)
    local start_time = os.time()
    local current_time = os.time()

    -- just keep checking current time until n seconds has passed
    while (os.difftime(current_time, start_time) < seconds_to_wait) do
        current_time = os.time()
    end
end

-- "wwise/events/player/play_backstab_indicator_melee"
-- "wwise/events/player/play_backstab_indicator_melee_elite"
-- "wwise/events/player/play_backstab_indicator_ranged"
local function replace_sounds()
    debug = mod:get("enable_debug_mode")

    -- Check if game backend caught up yet
    --while(true) do
    --  The max I will wait is 20 seconds. If it takes longer than that, your game is cooked
    for i = 1, 20 do
        if Managers.backend._initialized then -- ty tickbox
            break
        else
            sleep(1)
        end
    end

    -- User is using Audio plugin
    Audio = get_mod("Audio")

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