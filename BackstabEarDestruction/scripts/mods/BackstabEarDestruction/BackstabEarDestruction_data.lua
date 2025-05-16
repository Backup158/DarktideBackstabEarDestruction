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
				setting_id = "nonaudio_replacements",
				type = "group",
				default_value = false,
                sub_widgets = {
                    {
                        setting_id = "nonaudio_melee",
                        type = "checkbox",
                        default_value = false,
                        sub_widgets = {
                            {
                                setting_id = "nonaudio_melee_choice",
                                type = "dropdown",
                                default_value = false,
                                options = {
                                    {text = "melee_option_havoc_final", value = "ui_sound_events.havoc_terminal_rank_up_final_tier"},
                                    {text = "melee_option_crafting_upgrade", value = "ui_sound_events.crafting_view_on_upgrade_item"},
                                    {text = "melee_option_crafting_sacrifice", value = "ui_sound_events.crafting_view_sacrifice_weapon"},
                                    {text = "melee_option_crafting_extract", value = "ui_sound_events.crafting_view_on_extract_trait"},
                                }
                            },
                        }
                    },
                    {
                        setting_id = "nonaudio_melee_elite",
                        type = "checkbox",
                        default_value = false,
                        sub_widgets = {
                            {
                                setting_id = "nonaudio_melee_elite_choice",
                                type = "dropdown",
                                default_value = false,
                                options = {
                                    {text = "melee_elite_option_havoc_final", value = "ui_sound_events.havoc_terminal_rank_up_final_tier"},
                                    {text = "melee_elite_option_crafting_upgrade", value = "ui_sound_events.crafting_view_on_upgrade_item"},
                                    {text = "melee_elite_option_crafting_sacrifice", value = "ui_sound_events.crafting_view_sacrifice_weapon"},
                                    {text = "melee_elite_option_crafting_extract", value = "ui_sound_events.crafting_view_on_extract_trait"},
                                }
                            },
                        }
                    },
                    {
                        setting_id = "nonaudio_ranged",
                        type = "checkbox",
                        default_value = false,
                        sub_widgets = {
                            {
                                setting_id = "nonaudio_ranged_choice",
                                type = "dropdown",
                                default_value = false,
                                options = {
                                    {text = "ranged_option_havoc_final", value = "ui_sound_events.havoc_terminal_rank_up_final_tier"},
                                    {text = "ranged_option_crafting_upgrade", value = "ui_sound_events.crafting_view_on_upgrade_item"},
                                    {text = "ranged_option_crafting_sacrifice", value = "ui_sound_events.crafting_view_sacrifice_weapon"},
                                    {text = "ranged_option_crafting_extract", value = "ui_sound_events.crafting_view_on_extract_trait"},
                                }
                            },
                        }
                    },
                }
			},
        }
	}
}
