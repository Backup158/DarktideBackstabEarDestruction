return {
    run = function()
        fassert(rawget(_G, "new_mod"), "`BackstabEarDestruction` encountered an error loading the Darktide Mod Framework.")

        new_mod("BackstabEarDestruction", {
            mod_script       = "BackstabEarDestruction/scripts/mods/BackstabEarDestruction/BackstabEarDestruction",
            mod_data         = "BackstabEarDestruction/scripts/mods/BackstabEarDestruction/BackstabEarDestruction_data",
            mod_localization = "BackstabEarDestruction/scripts/mods/BackstabEarDestruction/BackstabEarDestruction_localization",
        })
    end,
    require = {
		"DarktideLocalServer",
		"Audio",
	},
    load_after = {
        "Audio",
    },
    packages = {},
}
