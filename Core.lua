
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
L.title = "Countdown: Heroes of the Storm"
L.language = "Language"
L.locale_warning = "You've changed your language! Normally only one set of voices is used, but each language you change to will remain listed until you reload your UI."
-- varies for asian locales
L.heroes = "Heroes of the Storm"
L.key = "%s: %s: %s"
L.key_short = "%s: %s"
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
		name = L.title,
		options = {
			name = L.title,
			type = "group",
			args = {
				locale = {
					name = L.language,
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
					name = "\n" .. L.locale_warning,
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

	ns.RegisterVoices()

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
	-- Map
	Adjutant = "Adjutant",
	Angel = "Angel",
	Blackheart = "Blackheart",
	Demon = "Demon",
	GardensDayAnnouncer = "Queen Nightshade",
	LadyofThorns = "Lady of Thorns",
	Necromancer = "Necromancer",
	RavenLord = "Raven Lord",
	SnakeGod = "Snake God",
	SpiderQueen = "Spider Queen",
	-- Brawl
	Athena = "Athena",
	Arena = "Arena",
	Commodore = "Commodore",
	-- Warcraft
	AnubarakAnnouncer = "Anub'arak",
	ArthasA = "Arthas",
	BrightwingA = "Brightwing",
	ETCA = "E.T.C.",
	FalstadA = "Falstad",
	GarroshA = "Garrosh",
	GazloweA = "Gazlowe",
	IllidanA = "Illidan",
	LiLiA = "Li Li",
	MalfurionA = "Malfurion",
	MuradinA = "Muradin",
	MurkyA = "Murky",
	RehgarAnnouncer = "Rehgar",
	StitchesA = "Stitches",
	-- StarCraft
	Abathur = "Abathur",
	SiegeTankA = "Sgt. Hammer",
	TassadarA = "Tassadar",
	TychusA = "Tychus",
	ZeratulA = "Zeratul",
	-- Diablo
	ButcherA = "Butcher",
	DiabloA = "Diablo",
	WitchDoctorA = "Nazeebo",
	BarbarianA = "Sonya",
	DemonHunterA = "Valla",
	-- Overwatch
	DvaA = "D.Va",
	GenjiA = "Genji",
}

function ns.RegisterVoices()
	local locale = db.locale or "enUS"
	if loaded[locale] then return end

	loaded[locale] = true

	local lang = localeMap[locale]
	local path = "Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\%s\\%s_Countdown%dsec00.ogg"

	for k, v in next, announcers do
		if k ~= "ButcherA" then
			local id = ("%s: %s: %s"):format(lang, "Heroes of the Storm", v) -- should be using k but I don't want to break everything D;
			local name = L.key:format(lang, L.heroes, L[k] or v)
			BigWigsAPI:RegisterCountdown(id, name, {
				path:format(locale, k, 1),
				path:format(locale, k, 2),
				path:format(locale, k, 3),
				path:format(locale, k, 4),
				path:format(locale, k, 5),
			})
		end
	end

	-- Special case Butcher (It's just grunts and growls)
	-- This is reversed from HotS so 2/1 are the more distinctive sounds
	local butcher = "Heroes of the Storm: Butcher"
	if not BigWigsAPI:HasCountdown(butcher) then
		BigWigsAPI:RegisterCountdown(butcher, L.key_short:format(L.heroes, L.ButcherA or "Butcher"), {
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_DismissBark02.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_Attack08.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_GetHitSmall02.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_GetHitSmall01.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_GetHitSmall04.ogg",
		})
	end
end
