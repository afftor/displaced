extends Node
#Game Settings
var TimePerDay = 120

enum {RES_MISS = 1, RES_HIT = 2, RES_CRIT = 4, RES_HITCRIT = 6}; 
enum {TR_HIT, TR_DEF, TR_TURN_S, TR_TURN_F, TR_DEATH, TR_DMG, TR_COMBAT_S, TR_COMBAT_F}

#Items
var RepairCostMultiplierEasy = 0.5
var RepairCostMultiplierMedium = 0.65
var RepairCostMultiplierHard = 0.8
var ItemEffectNaturalMultiplier = 0.15
#Heroes
var BaseHeroPrice = 100