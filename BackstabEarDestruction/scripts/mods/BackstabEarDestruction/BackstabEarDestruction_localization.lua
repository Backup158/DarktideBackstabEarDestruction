local localizations = {
    mod_name = {
        en = "Backstab Ear Destruction",
    },
    mod_description = {
        en = "REPLACES BACKSTAB SOUNDS WITH SOMETHING LOUD using the Audio plugin",
    },
    enable_debug_mode = {
        en = "Debug Mode",
    },
    enable_debug_mode_description = {
        en = "Enables verbose logging (does nothing atm)",
    },
    use_audio = {
        en = "Backstab Events to Replace",
    },
}

local backstab_events = {"melee", "melee_elite", "ranged", }

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

for _, event_name in pairs(backstab_events) do
    add_localization_format(event_name, "replace_indicator_", "", true)
    add_localization_format(event_name, "replacement_sound_volume_", "Volume for ", true)
end

return localizations
