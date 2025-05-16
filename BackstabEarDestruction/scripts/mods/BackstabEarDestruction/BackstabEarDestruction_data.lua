local mod = get_mod("BackstabEarDestruction")

local backstab_options = {"melee", "melee_elite", "ranged",}
local final_nonaudio_widgets = {}

--local widgets_location = final_data_table.options.widgets
--local nonaudio_subwidgets = widgets_location[#widgets_location].sub_widgets
for _, backstab_event in pairs(backstab_options) do
    -- insert at the tail (index of size plus 1)
    final_nonaudio_widgets[#final_nonaudio_widgets + 1] = {
        setting_id = "replace_nonaudio_"..backstab_event,
        type = "checkbox",
        default_value = false,
        sub_widgets = {
            {
                setting_id = "replace_nonaudio_"..backstab_event.."_choice",
                type = "dropdown",
                default_value = "havoc_terminal_rank_up_final_tier",
                options = {
                    {text = backstab_event.."_option_havoc_final", value = "havoc_terminal_rank_up_final_tier"},
                    {text = backstab_event.."_option_crafting_trait", value = "crafting_view_on_replace_trait"},
                    {text = backstab_event.."_option_crafting_upgrade", value = "crafting_view_on_upgrade_item"},
                    {text = backstab_event.."_option_crafting_sacrifice", value = "crafting_view_sacrifice_weapon"},
                }
            },
        }
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
                -- To be filled by loop
                sub_widgets = final_nonaudio_widgets,
			},
        }
	}
}
