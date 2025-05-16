local mod = get_mod("BackstabEarDestruction")

local backstab_events = {"melee", "melee_elite", "ranged", }

-- Creates options for each indicator replacer
local audio_replacement_widgets = {}
for _, event_name in pairs(backstab_events) do
    audio_replacement_widgets[#audio_replacement_widgets + 1] = {
        setting_id = "replace_indicator_"..event_name,
        type = "checkbox",
        default_value = true,
    }
end

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
		widgets = {
            {
				setting_id = "enable_debug_mode",
				type = "checkbox",
				default_value = false,
			},
            {
				setting_id = "use_audio",
				--type = "checkbox",
				--default_value = true,
                type = "group",
                sub_widgets = audio_replacement_widgets,
			},
        }
	}
}
