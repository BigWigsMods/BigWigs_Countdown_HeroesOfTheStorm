
local function registerVoices(mod)
	mod:RegisterVoice("English: Heroes: Blackheart", {
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Blackheart_Countdown1sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Blackheart_Countdown2sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Blackheart_Countdown3sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Blackheart_Countdown4sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Blackheart_Countdown5sec00.ogg",
	})

	mod:RegisterVoice("English: Heroes: Raven Lord", {
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\RavenLord_Countdown1sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\RavenLord_Countdown2sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\RavenLord_Countdown3sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\RavenLord_Countdown4sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\RavenLord_Countdown5sec00.ogg",
	})

	mod:RegisterVoice("English: Heroes: Snake God", {
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\SnakeGod_Countdown1sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\SnakeGod_Countdown2sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\SnakeGod_Countdown3sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\SnakeGod_Countdown4sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\SnakeGod_Countdown5sec00.ogg",
	})

	mod:RegisterVoice("English: Heroes: Lady of Thorns", {
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\LadyofThorns_Countdown1sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\LadyofThorns_Countdown2sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\LadyofThorns_Countdown3sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\LadyofThorns_Countdown4sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\LadyofThorns_Countdown5sec00.ogg",
	})

	mod:RegisterVoice("English: Heroes: Necromancer", {
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Necromancer_Countdown1sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Necromancer_Countdown2sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Necromancer_Countdown3sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Necromancer_Countdown4sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\Necromancer_Countdown5sec00.ogg",
	})

	mod:RegisterVoice("English: Heroes: Gardens Day", {
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\GardensDayAnnouncer_Countdown1sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\GardensDayAnnouncer_Countdown2sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\GardensDayAnnouncer_Countdown3sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\GardensDayAnnouncer_Countdown4sec00.ogg",
		"Interface\\AddOns\\BigWigs_Voice_HeroesOfTheStorm\\enUS\\GardensDayAnnouncer_Countdown5sec00.ogg",
	})
end

local name = ...
local plugin = BigWigs:GetPlugin("Super Emphasize", true)
if plugin then
	registerVoices(plugin)
else
	BigWigs.RegisterMessage(name, "BigWigs_OnPluginEnable", function(_, module)
		if module.moduleName == "Super Emphasize" then
			BigWigs.UnregisterMessage(name, "BigWigs_OnPluginEnable")
			registerVoices(module)
		end
	end)
end
