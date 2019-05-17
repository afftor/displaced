extends Node
#Game Settings
var TimePerDay = 120
var NoScenes = false
var CombatAllyHpAlwaysVisible = true

enum {RES_MISS = 1, RES_HIT = 2, RES_CRIT = 4, RES_HITCRIT = 6}; 
enum {TR_CAST,TR_CAST_TARGET, TR_HIT, TR_DEF, TR_TURN_S, TR_TURN_F, TR_DEATH, TR_KILL, TR_DMG, TR_POSTDAMAGE, TR_HEAL, TR_COMBAT_S, TR_COMBAT_F, TR_SHIELD_DOWN, TR_DAY};
enum {S_PHYS = 1, S_FIRE = 2, S_WATER = 4, S_AIR = 8, S_EARTH = 16, S_MAG = 30, S_FULL = 31}
enum {TE_RES_NOACT, TE_RES_TICK, TE_RES_UPGRADE, TE_RES_REMOVE}
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

#combat constants
var dmg_mod_list = ['hp', 'mana']
const playerparty = [1, 2, 3, 4, 5, 6]
const enemyparty = [7, 8, 9, 10, 11, 12]
const rows = {
	1:[1,4],
	2:[2,5],
	3:[3,6],
	4:[7,10],
	5:[8,11],
	6:[9,12],
} 
const lines = {
	1 : [1,2,3],
	2 : [4,5,6],
	3 : [7,8,9],
	4 : [10,11,12],
}