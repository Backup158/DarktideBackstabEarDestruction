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

local function to_sentence_case(str)
    return (str:gsub("\b%l", string.upper))
end

local function add_localization_format(event_name, base_key, base_localization, will_append)
    local final_localization_desc
    if will_append then 
        final_localization_desc = base_localization..event_name
    else
        final_localization_desc = event_name..base_localization
    end
    final_localization_desc = to_sentence_case(final_localization_desc)

    localizations[base_key..event_name] = {
        en = final_localization_desc
    }

end

for _, event_name in pairs(backstab_events) do
    add_localization_format(event_name, "replace_indicator", "", true)
end

return localizations
