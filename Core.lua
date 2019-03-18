-- luacheck: globals BigWigs BigWigsAPI

local _, ns = ...

-------------------------------------------------------------------------------
-- Locals
--

local L = ns.L

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
local defaultLocale = GetLocale()
if not localeMap[defaultLocale] then
	defaultLocale = "enUS"
end

local loaded = {}

-------------------------------------------------------------------------------
-- Options
--

local plugin = BigWigs:NewPlugin("HeroesVoices")
if not plugin then return end

plugin.defaultDB = {
	locale = defaultLocale
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
				get = function()
					return plugin.db.profile.locale
				end,
				set = function(_, value)
					plugin.db.profile.locale = value
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

function plugin:OnRegister()
	ns.RegisterVoices()
end

-------------------------------------------------------------------------------
-- Registration
--

local announcers = {
	-- Map
	Adjutant = "Adjutant",
	Angel = "Angel",
	Athena = "Athena",
	Blackheart = "Blackheart",
	Demon = "Demon",
	DrekTharA = "Drek'Thar",
	GardensDayAnnouncer = "Queen Nightshade",
	LadyofThorns = "Lady of Thorns",
	Necromancer = "Necromancer",
	RavenLord = "Raven Lord",
	SnakeGod = "Snake God",
	SpiderQueen = "Spider Queen",
	VanndarA = "Vanndar Stormpike",
	VolskayaA = "Volskaya",
	-- Brawl/Event
	Arena = "Arena",
	Commodore = "Commodore",
	-- LuchaA = "El Guapo", -- same for all languages
	MiraA = "Mira Han",
	Toy18A = "\"The Kid\"",
	-- Warcraft
	AlexstraszaA = "Alexstrasza",
	AnubarakAnnouncer = "Anub'arak",
	ArthasA = "Arthas",
	BrightwingA = "Brightwing",
	ETCA = "E.T.C.",
	FalstadA = "Falstad",
	GarroshA = "Garrosh",
	GazloweA = "Gazlowe",
	IllidanA = "Illidan",
	JainaA = "Jaina",
	KelthuzadA = "Kel'Thuzad",
	LiLiA = "Li Li",
	MaievA = "Maiev",
	MalfurionA = "Malfurion",
	MalganisA = "Mal'Ganis",
	MuradinA = "Muradin",
	MurkyA = "Murky",
	RehgarAnnouncer = "Rehgar",
	StitchesA = "Stitches",
	WhitemaneA = "Whitemane",
	YrelA = "Yrel",
	-- StarCraft
	Abathur = "Abathur",
	AlarakA = "Alarak",
	BlazeA = "Blaze",
	FenixA = "Fenix",
	SiegeTankA = "Sgt. Hammer",
	TassadarA = "Tassadar",
	TychusA = "Tychus",
	ZeratulA = "Zeratul",
	-- Diablo
	-- ButcherA = "Butcher", -- same for all languages
	DiabloA = "Diablo",
	DeckardA = "Deckard Cain",
	ImperiusA = "Imperius",
	MephistoA = "Mephisto",
	WitchDoctorA = "Nazeebo",
	BarbarianA = "Sonya",
	TyraelA = "Tyrael",
	DemonHunterA = "Valla",
	-- Overwatch
	DvaA = "D.Va",
	GenjiA = "Genji",
	HanzoA = "Hanzo",
	JunkratA = "Junkrat",
	-- Skins
	TyraelMechaA = "Mecha Tyrael",
	-- Nexus
	OrpheaA = "Orphea",
	-- Misc
	-- CloakenA = "Cloaken", -- same for all languages
}

function ns.RegisterVoices()
	local locale = plugin.db.profile.locale
	if loaded[locale] then return end

	loaded[locale] = true

	local lang = localeMap[locale]
	local path = "Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\%s\\%s_Countdown%dsec00.ogg"

	for k, v in next, announcers do
		local id = ("%s: Heroes of the Storm: %s"):format(lang, v) -- should be using k but I don't want to break everything D;
		local name = L.key:format(lang, L.heroes, L[k] or v)
		BigWigsAPI:RegisterCountdown(id, name, {
			path:format(locale, k, 1),
			path:format(locale, k, 2),
			path:format(locale, k, 3),
			path:format(locale, k, 4),
			path:format(locale, k, 5),
		})
	end

	-- Butcher (It's just grunts and growls)
	-- This is reversed from HotS so 2/1 are the more distinctive sounds
	local k, v = "ButcherA", "Butcher"
	local id = ("Heroes of the Storm: %s"):format(v)
	if not BigWigsAPI:HasCountdown(id) then
		BigWigsAPI:RegisterCountdown(id, L.key_short:format(L.heroes, L[k] or v), {
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_DismissBark02.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_Attack08.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_GetHitSmall02.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_GetHitSmall01.ogg",
			"Interface\\AddOns\\BigWigs_Countdown_HeroesOfTheStorm\\enUS\\ButcherA_VOX_GetHitSmall04.ogg",
		})
	end

	-- El Guapo (Spanish for all locales)
	local k, v = "LuchaA", "El Guapo"
	local id = ("Heroes of the Storm: %s"):format(v)
	if not BigWigsAPI:HasCountdown(id) then
		BigWigsAPI:RegisterCountdown(id, L.key_short:format(L.heroes, L[k] or v), {
			path:format("enUS", k, 1),
			path:format("enUS", k, 2),
			path:format("enUS", k, 3),
			path:format("enUS", k, 4),
			path:format("enUS", k, 5),
		})
	end

	-- Cloaken (English for all locales)
	local k, v = "CloakenA", "Cloaken"
	local id = ("Heroes of the Storm: %s"):format(v)
	if not BigWigsAPI:HasCountdown(id) then
		BigWigsAPI:RegisterCountdown(id, L.key_short:format(L.heroes, L[k] or v), {
			path:format("enUS", k, 1),
			path:format("enUS", k, 2),
			path:format("enUS", k, 3),
			path:format("enUS", k, 4),
			path:format("enUS", k, 5),
		})
	end
end
