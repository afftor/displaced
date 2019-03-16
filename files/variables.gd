extends Node
#Game Settings
var TimePerDay = 120
var NoScenes = false

enum {RES_MISS = 1, RES_HIT = 2, RES_CRIT = 4, RES_HITCRIT = 6}; 
enum {TR_CAST, TR_HIT, TR_DEF, TR_TURN_S, TR_TURN_F, TR_DEATH, TR_KILL, TR_DMG, TR_HEAL, TR_COMBAT_S, TR_COMBAT_F, TR_SHIELD_DOWN};
enum {S_PHYS = 1, S_FIRE = 2, S_WATER = 4, S_AIR = 8, S_EARTH = 16, S_MAG = 30, S_FULL = 31}

#Items
var RepairCostMultiplierEasy = 0.5
var RepairCostMultiplierMedium = 0.65
var RepairCostMultiplierHard = 0.8
var ItemEffectNaturalMultiplier = 0.15
#Heroes
var BaseHeroPrice = 100
