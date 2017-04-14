
if GetAddOnEnableState(UnitName("player"), "BigWigs_Voice_HeroesOfTheStorm") > 0 then
	C_Timer.After(7, function()
		print("|cFF33FF99BigWigs_Voice_HeroesOfTheStorm|r has been renamed to |cFF33FF99BigWigs_Countdown_HeroesOfTheStorm|r and you seem to have both addons enabled! Please remove the old |cFF33FF99BigWigs_Voice_HeroesOfTheStorm|r folder from your Interface/AddOns folder to ensure you're using the correct version.")
	end)
	return
end

-- luacheck: globals BigWigs BigWigs3DB BigWigsAPI BigWigsLoader

local _, ns = ...

-------------------------------------------------------------------------------
-- Locale
--

local L = {}
L["Countdown: Heroes of the Storm"] = "Countdown: Heroes of the Storm"
L["Language"] = "Language"
L["You've changed your language! Normally only one set of voices is used, but each language you change to will remain listed until you reload your UI."] = "You've changed your language! Normally only one set of voices is used, but each language you change to will remain listed until you reload your UI."
ns.L = L

-------------------------------------------------------------------------------
-- Locals
--

local localeMap = {
	enUS = "English",
	deDE = "Deutsch",
	esES = "Español (es)",
	esMX = "Español (mx)",
	frFR = "Français",
	ruRU = "Русский",
	koKR = "한국어",
	itIT = "Italiano",
	ptBR = "Português",
	zhCN = "简体中文",
	zhTW = "繁體中文",
}

local loaded = {}

local db = {}
-- Upvalue the plugin db from it's SavedVars directly since the plugin can't be loaded until BigWigs_Core is
if BigWigs3DB and BigWigs3DB.profileKeys and BigWigs3DB.namespaces and BigWigs3DB.namespaces.BigWigs_Plugins_HeroesVoices and BigWigs3DB.namespaces.BigWigs_Plugins_HeroesVoices.profiles then
	local name, realm = UnitName("player"), GetRealmName()
	if name and realm then
		local profile = BigWigs3DB.profileKeys[name.." - "..realm]
		local profiles = BigWigs3DB.namespaces.BigWigs_Plugins_HeroesVoices.profiles
		if profile and profiles[profile] then
			db = profiles[profile]
		end
	end
end

-------------------------------------------------------------------------------
-- Options
--

function ns.RegisterPlugin(event)
	BigWigsLoader.UnregisterMessage(ns, event)

	local plugin = BigWigs:NewPlugin("HeroesVoices")
	if not plugin then return end

	local locale = GetLocale()
	plugin.defaultDB = {
		locale = localeMap[locale] and locale or "enUS"
	}

	plugin.subPanelOptions = {
		key = "Big Wigs: Voice: Heroes of the Storm",
		name = L["Countdown: Heroes of the Storm"],
		options = {
			name = L["Countdown: Heroes of the Storm"],
			type = "group",
			args = {
				locale = {
					name = L["Language"],
					type = "select",
					values = localeMap,
					get = function() return db.locale end,
					set = function(_, value)
						db.locale = value
						ns.RegisterVoices()
					end,
					order = 2,
				},
				notice = {
					name = "\n"..L["You've changed your language! Normally only one set of voices is used, but each language you change to will remain listed until you reload your UI."],
					type = "description",
					hidden = function()
						local count = 0
						for _ in next, loaded do
							count = count + 1
						end
						if count == 1 then
							return true
						end
					end,
					order = 3,
				},
			},
		},
	}

	local function profileUpdate()
		db = plugin.db.profile
	end
	function plugin:OnEnable()
		self:RegisterMessage("BigWigs_ProfileUpdate", profileUpdate)
		profileUpdate()
	end

	-- Force initialization since the addon is already loaded
	BigWigs.ADDON_LOADED()
end

BigWigsLoader.RegisterMessage(ns, "BigWigs_CoreEnabled", ns.RegisterPlugin)
if BigWigs and BigWigs:IsEnabled() then
	ns.RegisterPlugin("BigWigs_CoreEnabled")
end

-------------------------------------------------------------------------------
-- Registration
--

local announcers = {
	Blackheart = "Blackheart",
	GardensDayAnnouncer = "Queen Nightshade",
	LadyofThorns = "Lady of Thorns",
	Necromancer = "Necromancer",
	RavenLord = "Raven Lord",
	SnakeGod = "Snake God",
	SpiderQueen = "Spider Queen",
	Angel = "Angel",
	Demon = "Demon",
	Adjutant = "Adjutant",
	Arena = "Arena Announcer",
}

function ns.RegisterVoices()
	local locale = db.locale or "enUS"
	if loaded[locale] then return end

	loaded[locale] = true

	local lang = localeMap[locale]
	-- could localize all of the string, but changes would break sound settings so meh
	local key = "%s: Heroes of the Storm: %s"
	local path = "Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\%s\\%s_Countdown%dsec00.ogg"

	for file, name in next, announcers do
		BigWigsAPI:RegisterCountdown(key:format(lang, name), {
			path:format(locale, file, 1),
			path:format(locale, file, 2),
			path:format(locale, file, 3),
			path:format(locale, file, 4),
			path:format(locale, file, 5),
		})
	end
end

ns.RegisterVoices()
