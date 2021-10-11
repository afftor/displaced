extends Node
#Game Settings
var TimePerDay = 120
var NoScenes = false
var CombatAllyHpAlwaysVisible = true
var show_enemy_hp = false

enum {RES_MISS = 1, RES_HIT = 2, RES_CRIT = 4, RES_HITCRIT = 6};
enum {TR_CAST,TR_CAST_TARGET, TR_HIT, TR_DEF, TR_TURN_S, TR_TURN_GET, TR_TURN_F, TR_DEATH, TR_KILL, TR_DMG, TR_POSTDAMAGE, TR_POST_TARG, TR_SKILL_FINISH, TR_HEAL, TR_COMBAT_S, TR_COMBAT_F, TR_SHIELD_DOWN, TR_RES};
enum {TE_RES_NOACT, TE_RES_TICK, TE_RES_UPGRADE, TE_RES_REMOVE};
enum {TARGET_KEEP, TARGET_KEEPFIRST, TARGET_NOKEEP, TARGET_MOVEFIRST};
enum {NT_MELEE, NT_ANY, NT_ANY_NOREPEAT, NT_WEAK, NT_WEAK_MELEE, NT_BACK, NT_CASTER};
#Heroes
var MaxLevel = 5
var StartTraitPoints = 0
var TraitPointsPerLevel = 1

#list for stats with stored bonuses that use generic getter (not custom getter!!)
#to add them all :)
var bonuses_stat_list = ['damage']
#list for stats that do not uses bonuses system
#imho must include all of dmg_rel stats
var direct_access_stat_list = ['hp', 'alt_mana', 'taunt']
var resistlist = ['damage', 'slash', 'pierce', 'bludgeon', 'light', 'dark', 'air', 'water', 'earth', 'fire']
var status_list = ['burn', 'stun', 'chill', 'negative', 'poison', 'bleed']

#config flags
var ai_setup = 'off' # 'off' - no setup, 'old' - using data convertion, 'new' - pass data as is. obsolete
var new_stat_bonuses_syntax = false
#combat constants
var dmg_mod_list = ['hp', '+damage_hp', '-damage_hp']
const playerparty = [1, 2, 3]
const enemyparty = [4, 5, 6, 7, 8, 9]
const rows = {
	1:[1],
	2:[2],
	3:[3],
	4:[4,7],
	5:[5,8],
	6:[6,9],
}
const lines = {
	1 : [1,2,3],
	2 : [4,5,6],
	3 : [7,8,9]
}

var curve = [1.0]

var default_animations_duration = {
	attack = 0.6,
	hit = 0.6,
	dead = 0.5,#for npc only
	null: 0.5,
}
var default_animations_transition = {
	attack = 0.2,
	hit = 0.2,
	dead = 0.1,
	null: 0.5,
}
var default_animations_delay = {
	attack = 0.0,
	hit = 0.3,
	dead = 0,
	null: 0.5,
}

func _ready():
	fill_curve()
	print(curve)

func fill_curve():
	for i in range(14): curve.push_back(curve.back() + 0.25)
	for i in range(5): curve.push_back(curve.back() + 0.1)
	for i in range(26): curve.push_back(curve.back() + 0.02)


var gallery_singles_list = [
#	{path = "rose_sex_1", type = 'abg'},
#	{path = "villagenight", type = 'bg'},
	]


var hexcolordict = {
	red = '#ff5e5e',
	yellow = "#ffff00",
	brown = "#8B572A",
	gray = "#4B4B4B",
	gray_text_dialogue = "#90d4aa",
	green = '#00b700',
	white = '#ffffff',
	aqua = '#24ffdb',
	pink = '#f824ff',
	factor1 = '#ff5e5e',
	factor2 = '#f6922a',
	factor3 = '#4dff83',
	factor4 = '#13a40d',
	factor5 = '#25b8ff',
	factor6 = '#bc53ff',
	levelup_text_color = "#10ff10",
	k_yellow = "#f9e181",
	k_yellow_dark = "#99836f",
	k_gray = "#e0e0e0",
	k_green = "#51fe84",
	k_red = "#fe515d",
	magenta = "#ff84ff",
}
