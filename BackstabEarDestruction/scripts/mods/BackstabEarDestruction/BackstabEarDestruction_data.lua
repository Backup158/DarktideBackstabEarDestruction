local mod = get_mod("BackstabEarDestruction")

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
                sub_widgets = {
                    {
                        setting_id = "replace_indicator_melee",
                        type = "checkbox",
                        default_value = true,
                    },
                    {
                        setting_id = "replace_indicator_melee_elite",
                        type = "checkbox",
                        default_value = true,
                    },
                    {
                        setting_id = "replace_indicator_ranged",
                        type = "checkbox",
                        default_value = true,
                    },
                }
			},
        }
	}
}
