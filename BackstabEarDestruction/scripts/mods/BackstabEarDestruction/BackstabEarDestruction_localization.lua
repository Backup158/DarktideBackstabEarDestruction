local mod = get_mod("BackstabEarDestruction")

mod.backstab_events = {"melee", "melee_elite", "ranged", }
local backstab_events = mod.backstab_events

local localizations = {
    mod_name = {
        en = "Backstab Ear Destruction",
    },
    mod_description = {
        en = "REPLACES BACKSTAB SOUNDS FROM ENEMY ATTACKS WITH SOMETHING LOUD using custom audio",
    },
    enable_debug_mode = {
        en = "Debug Mode",
    },
    enable_debug_mode_description = {
        en = "Enables verbose logging",
    },
    use_audio = {
        en = "Backstab Events to Replace",
    },
    option_sound_volume = {
        en = "Volume of the sound by percentage. Simple Audio supports 200% volume, but Audio only goes up to 100%; if you select a value over 100% when using Audio, the actual value will be 100%."
    },
    error_missing_audio_framework = {
        en = "Simple Audio or the Audio plugin are required for this option!",
    },
}

local function add_localization_format(event_name, base_key, base_localization, will_append)
    local final_localization_val
    -- Replaces underscores with spaces
    local event_name_formatted = string.gsub(event_name, "_", " ")
    -- Converts string value to sentence case
    --  \b is word boundary
    --  %l is lowercase letter
    --  ^ is start of string
    event_name_formatted = string.gsub(event_name_formatted, "^%l", string.upper)
    event_name_formatted = string.gsub(event_name_formatted, " %l", string.upper)
    if will_append then 
        final_localization_val = base_localization..event_name_formatted
    else
        final_localization_val = event_name_formatted..base_localization
    end

    localizations[base_key..event_name] = {
        en = final_localization_val
    }

end

for i = 1, #backstab_events do
    local event_name = backstab_events[i]
    add_localization_format(event_name, "replace_indicator_", "", true)
    add_localization_format(event_name, "replacement_sound_volume_", "Volume for ", true)
end

return localizations
