extends Node
#Game Settings
var TimePerDay = 120
var NoScenes = false
var CombatAllyHpAlwaysVisible = true
var show_enemy_hp = false

enum {RES_MISS = 1,#0b001
	RES_HIT = 2,#0b010
	RES_CRIT = 4,#0b100
	RES_HITCRIT = 6};#0b110, means both RES_HIT and RES_CRIT
#trigger events for process_event() functions
#concepts of metaskill and applicable skill are described in use_skill() function of main combat script
enum {TR_CAST,#on skill cast, befor even target refining and any true actions
#	TR_CAST_TARGET,#seems to be not in use
	TR_HIT,#for applicable skill and caster befor actual damage on target, but after all preparations for it
	TR_DEF,#same moment, but for target
	TR_TURN_S,#on new turn start for every players's chars and enemy in combat, except for defeated
	TR_TURN_GET,#on char gets to make turn (to act)
	TR_TURN_F,#on char finishing turn (action), if still alive. Takes place even if char can't act in this turn for some reason
	TR_DEATH,#on char's death
	TR_KILL,#occurs for caster on death of each target. Occurs also for metaskill, but only once, even if it killed multiple targets
	TR_DMG,#on char receiving any actual damage (hp reduction)
	TR_POSTDAMAGE,#occurs for caster and applicable skill right after damage should have been done
	TR_POST_TARG,#same moment, but for target, and only if it hasn't been killed
	TR_SKILL_FINISH,#for metaskill and caster, on skill's main body has been finished. It occurs befor any follow-up or queued skills and befor any win-lose analysis
	TR_HEAL,#on char been actually healed (hp increase)
	TR_COMBAT_S,#on char's group been formed at start of combat. Occurs for all player's char at combat start, and for enemies of the wave at wave's start
	TR_COMBAT_F,#occurs for every char on battlefield on very finish of combat (window closure): at loss, at runaway and on reward claiming after victory
	TR_SHIELD_DOWN,#on char's shield been depleted to 0
	TR_RES,#on char's resurrection
	TR_RESERVE#on hero moving to reserve
	};
enum {TE_RES_NOACT, TE_RES_TICK, TE_RES_UPGRADE, TE_RES_REMOVE};
enum {TARGET_KEEP, TARGET_KEEPFIRST, TARGET_NOKEEP, TARGET_MOVEFIRST};
enum {NT_MELEE, NT_ANY, NT_ANY_NOREPEAT, NT_WEAK, NT_WEAK_MELEE, NT_BACK, NT_CASTER};
enum {SEQ_NONE, SEQ_SCENE_STARTED}
enum {CURTAIN_BATTLE, CURTAIN_SCENE}
#Heroes
var MaxLevel = 40
var StartTraitPoints = 0
var TraitPointsPerLevel = 1

#enemies
var EasyDiffMul = 0.7

#list for stats with stored bonuses that use generic getter (not custom getter!!)
#to add them all :)
var bonuses_stat_list = ['damage', 'hitrate', 'hpmax', 'evasion', 'critchance']
#list for stats that do not uses bonuses system
#imho must include all of dmg_rel stats
var direct_access_stat_list = ['hp', 'alt_mana', 'taunt', 'shield']

#------------------resist section---------------------
#consider to move it to separate singleton
#resistlist and status_list are separate for logic reason, but there must be no duplicate entries for presentation reason
var resistlist = ['damage', 'slash', 'pierce', 'bludgeon', 'light', 'dark', 'air', 'water', 'earth', 'fire']
var status_list = ['burn', 'stun', 'chill', 'negative', 'poison', 'bleed']
var resist_data = {
	#resistlist
	damage = {
		name = 'RESIST_DAMAGE',
		icon = preload('res://assets/images/iconsskills/defaultattack.png'),
		type = 'damage'
	},
	slash = {
		name = 'RESIST_SLASH',
		icon = preload('res://assets/images/iconsskills/source_slash.png'),
		type = 'damage'
	},
	pierce = {
		name = 'RESIST_PIERCE',
		icon = preload('res://assets/images/iconsskills/source_pierce.png'),
		type = 'damage'
	},
	bludgeon = {
		name = 'RESIST_BLUDGEON',
		icon = preload('res://assets/images/iconsskills/source_bludgeon.png'),
		type = 'damage'
	},
	light = {
		name = 'RESIST_LIGHT',
		icon = preload('res://assets/images/iconsskills/source_light.png'),
		type = 'damage'
	},
	dark = {
		name = 'RESIST_DARK',
		icon = preload('res://assets/images/iconsskills/source_dark.png'),
		type = 'damage'
	},
	air = {
		name = 'RESIST_AIR',
		icon = preload('res://assets/images/iconsskills/source_air.png'),
		type = 'damage'
	},
	water = {
		name = 'RESIST_WATER',
		icon = preload('res://assets/images/iconsskills/source_water.png'),
		type = 'damage'
	},
	earth = {
		name = 'RESIST_EARTH',
		icon = preload('res://assets/images/iconsskills/source_earth.png'),
		type = 'damage'
	},
	fire = {
		name = 'RESIST_FIRE',
		icon = preload('res://assets/images/iconsskills/source_fire.png'),
		type = 'damage'
	},
	#status_list
	burn = {
		name = 'RESIST_BURN',
		icon = preload('res://assets/images/iconsskills/rose_4.png'),
		type = 'status'
	},
	stun = {
		name = 'RESIST_STUN',
		icon = preload('res://assets/images/iconsskills/iola_6.png'),
		type = 'status'
	},
	chill = {
		name = 'RESIST_CHILL',
		icon = preload('res://assets/images/iconsskills/erika_5.png'),
		type = 'status'
	},
	negative = {
		name = 'RESIST_NEGATIVE',
		icon = preload('res://assets/images/iconsskills/rose_3.png'),
		type = 'status'
	},
	poison = {
		name = 'RESIST_POISON',
		icon = preload('res://assets/images/iconsskills/Debilitate.png'),
		type = 'status'
	},
	bleed = {
		name = 'RESIST_BLEED',
		icon = preload('res://assets/images/iconsskills/arron_3.png'),
		type = 'status'
	},
}
#var max_resist_name_size :int = 0

func get_resist_data(resist :String) ->Dictionary:
	assert(resist_data.has(resist), "resist_data has no entry for %s!" % resist)
	return resist_data[resist]

func check_resist_integrity():
	for entry in resistlist:
		assert(!status_list.has(entry), "resistlist and status_list has duplicates!")
	for entry in resistlist + status_list:
		assert(resist_data.has(entry), "resist_data has no icon for %s!" % entry)

#seems useless, because image tends to be too small to fit in text
#func damage_tag_process(input_str :String, img_height :int) ->String:
#	for i in range(10000):#no more then 10000 tags?
#		if !("[d:" in input_str):
#			break
#		var tag_start = input_str.find("[d:")
#		var tag_end = input_str.find("]", tag_start)
#		var tag = input_str.substr(tag_start, tag_end - tag_start + 1)
#		var damage_type = tag.substr(3, tag.length() - 4)
#		var img = "[img=%sx%s]%s[/img]" % [img_height, img_height, get_resist_data(damage_type).icon.resource_path]
#		input_str = input_str.replace(tag, img)
#	return input_str

#func calc_max_resist_name_size():
#	for id in resist_data:
#		var name_size = tr(resist_data[id].name).length()
#		if name_size > max_resist_name_size:
#			max_resist_name_size = name_size
#---------------------------------

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
	ultimate = 2.0,
	use = 0.6,
	cast = 0.6,
	special = 0.6,
	hit = 0.6,
	dead = 1.4,#for npc only
	null: 0.5,
}
var default_animations_transition = { #those are not added to duration
	attack = 0.2,
	ultimate = 0.2,
	use = 0.2,
	cast = 0.2,
	special = 0.2,
	hit = 0.2,
	dead = 0.5,
	null: 0.5,
}
var default_animations_delay = {
	attack = 0.0,
	ultimate = 0.0,
	use = 0.0,
	cast = 0.0,
	special = 0.0,
	hit = 0.0,
	dead = 0,
	null: 0.5,
}

var default_animations_after_delay = { #generally should be negative, but not overexeeding delay + duration
	attack = -0.4,
	ultimate = -0.4,
	use = -0.4,
	cast = -0.4,
	special = -0.4,
	hit = 0.0,
	dead = 0,
	null: 0.0,
}

func _ready():
	fill_curve()
	print(curve)
	check_resist_integrity()
#	calc_max_resist_name_size()

func fill_curve():
	for i in range(14): 
		curve.push_back(curve.back() * 1.15)#old 1.25
	for i in range(5): 
		curve.push_back(curve.back() * 1.08)#old 1.1
	for i in range(26): 
		curve.push_back(curve.back() * 1.02)


#var gallery_singles_list = [
#	{path = "rose_sex_1", type = 'abg'},
#	{path = "villagenight", type = 'bg'},
#	]


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
	levelup_text_color = "#10ff10",
	k_yellow = "#f9e181",
	k_yellow_dark = "#99836f",
	k_gray = "#e0e0e0",
	k_green = "#51fe84",
	k_red = "#fe515d",
	magenta = "#ff84ff",
	
	highlight_blue = "#4afffe",
	light_grey = "#dedede",
	dark_grey = "#8b8b8b",
}

const autosave_name = "autosave"
