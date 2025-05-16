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
				type = "checkbox",
				default_value = true,
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
			{
                setting_id = "scan_sound",
				type = "dropdown",
				default_value = "sfx_scanning_sucess.events.scanner_equip",
        		options = {
                    {text = "scan_option_default", value = "sfx_scanning_sucess.events.scanner_equip"},
                    {text = "scan_option_ability_ogryn_taunt", value = "ability_shout.events.ogryn_taunt_shout"},
                    {text = "scan_option_ability_vent", value = "ability_shout.events.psyker_shout"},
                    {text = "scan_option_ability_voc", value = "ability_shout.events.veteran_combat_ability"},
                    {text = "scan_option_ability_book", value = "ability_shout.events.zealot_relic"},
                }
			},
        }
	}
}
