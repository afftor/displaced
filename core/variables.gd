extends Node
#Game Settings
var TimePerDay = 120
var NoScenes = false
var CombatAllyHpAlwaysVisible = true
var show_enemy_hp = false

enum {RES_MISS = 1, RES_HIT = 2, RES_CRIT = 4, RES_HITCRIT = 6}; 
enum {TR_CAST,TR_CAST_TARGET, TR_HIT, TR_DEF, TR_TURN_S, TR_TURN_GET, TR_TURN_F, TR_DEATH, TR_KILL, TR_DMG, TR_POSTDAMAGE, TR_POST_TARG, TR_SKILL_FINISH, TR_HEAL, TR_COMBAT_S, TR_COMBAT_F, TR_SHIELD_DOWN, TR_DAY};
enum {TE_RES_NOACT, TE_RES_TICK, TE_RES_UPGRADE, TE_RES_REMOVE};
enum {TARGET_KEEP, TARGET_KEEPFIRST, TARGET_NOKEEP, TARGET_MOVEFIRST};
enum {NT_MELEE, NT_ANY, NT_ANY_NOREPEAT, NT_WEAK, NT_WEAK_MELEE, NT_BACK, NT_CASTER};
#Items
var RepairCostMultiplierEasy = 0.5
var RepairCostMultiplierMedium = 0.65
var RepairCostMultiplierHard = 0.8
var ItemEffectNaturalMultiplier = 0.15
#Heroes
var BaseHeroPrice = 100
var MaxLevel = 5
var StartTraitPoints = 0
var TraitPointsPerLevel = 1

#list for stats with stored bonuses that use generic getter (not custom getter!!)
#to add them all :)
var bonuses_stat_list = []
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

func _ready():
	fill_curve()
	print(curve)

func fill_curve():
	for i in range(14): curve.push_back(curve.back() + 0.25)
	for i in range(5): curve.push_back(curve.back() + 0.1)
	for i in range(26): curve.push_back(curve.back() + 0.02)
