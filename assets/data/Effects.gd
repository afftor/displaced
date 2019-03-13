extends Node
#old part, to replace
var effects = {
	gobmetalhandle = {descript = tr("GOBMETALHANDLEDESCRIPT"), code = 'gobmetalhandle', textcolor = 'yellow', trigger = 'skillhit', triggereffect = 'gobmetalhandleffect'},
	elfmetalhandle = {descript = tr("ELFMETALHANDLEDESCRIPT"), code = 'elfmetalhandle', textcolor = 'yellow', trigger = 'skillhit', triggereffect = 'elfmetalhandleffect'},
	gobmetalblade = {descript = tr("GOBMETALBLADEDESCRIPT"), code = 'gobmetalblade', textcolor = 'yellow', trigger = 'skillhit', triggereffect = 'gobmetalbladeeffect'},
	elfmetalblade = {descript = tr("ELFMETALBLADEDESCRIPT"), code = 'elfmetalblade', textcolor = 'yellow', trigger = 'skillhit', triggereffect = 'elfmetalbladeeffect'},
	elfwoodrod = {descript = tr("ELFWOODRODDESCRIPT"), code = 'elfwoodrod', textcolor = 'yellow', trigger = 'endcombat',triggereffect = 'elfwoodrodeffect'},
	gobmetalrod = {descript = tr("GOBMETALRODDESCRIPT"), code = 'gobmetalrod', textcolor = 'yellow', trigger = 'spellhit', triggereffect = 'gobmetalrodeffect'},
	bonerod = {descript = tr("BONERODDESCRIPT"), code = 'bonerod', textcolor = 'yellow', trigger = 'spellhit', triggereffect = 'bonerodeffect'},
	bonebow = {descript = tr("BONEBOWDESCRIPT"), code = 'bonebow', textcolor = 'yellow', trigger = 'skillhit', triggereffect = 'boneboweffect'},
	
	natural = {name = tr("NATURAL"), code = 'natural', descript = tr("NATURALEFFECTDESCRIPT"), textcolor = 'brown', trigger = 'custom', tags = []},
	brittle = {name = tr("BRITTLE"), code = 'brittle', descript = tr("BRITTELEFFECTDESCRIPT"), textcolor = 'gray', tags = []},
	
}

var combateffects = {
#traits
beastdamage = {effect = 'skillmod', effectvalue = {type = "damagemod", value = ['0.2'], targetreq = {type = 'stats', name = 'race', operant = 'eq', value = 'animal'}}},


#items
gobmetalhandleeffect = {effect = 'skillmod', effectvalue = {type = 'damagemod', value = ['0.15']}, targetreq = {type = 'stats', name = 'hppercent', operant = 'lte', value = 25}},
elfmetalhandleeffect = {effect = 'gainstat', receiver = 'caster', effectvalue = {type = 'mana', value = ['1']}},
boneboweffect = {effect = 'gainstat', receiver = 'caster', effectvalue = {type = 'hp', value = ['1']}},
gobmetalbladeeffect = {effect = 'extradamage', receiver = 'target', effectvalue = {type = 'global', element = 'earth', value = ['caster.level']}},
elfmetalbladeeffect = {effect = 'skillmod', effectvalue = {type = 'damage', value = ['10']}, targetreq = {type = 'stats', name = 'hppercent', operant = 'gte', value = 100}},
elfwoodrodeffect = {effect = 'gainstat', receiver = 'caster', effectvalue = {type = 'mana', value = ['manamax','*0.1']}},
gobmetalrodeffect = {effect = 'buff', receiver = 'target', effectvalue = {code = 'gobrodspeeddebuf',effects = [{stat = 'speed', value = ['-10']}], duration = 1, tags = []}},
bonerodeffect = {effect = 'gainstat', receiver = 'caster', effectvalue = {type = 'hp', value = ['hpmax','*0.03']}},

}

#new part
var effect_table = {
	#traits
	e_tr_dmgbeast = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [
			{target = 'target', value = {type = 'race', value = 'animal' } }
		],
		effects = [{type = 'param_m', stat = 'value', value = 1.2, target = 'skill'}]
	},
	e_tr_nodmgbeast = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [
			{target = 'caster', value = {type = 'race', value = 'animal' } }
		],
		effects = [{type = 'param_m', stat = 'value', value = 0.8, target = 'skill'}]
	},
	e_tr_fastlearn = { #no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [{type = 'stat', stat = 'xpmod', value = 0.15}]
	},
	e_tr_hitrate = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [{type = 'stat', stat = 'hitrate', value = 10}]
	},
	e_tr_ev10 = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [{type = 'stat', stat = 'evasion', value = 10}]
	},
	e_tr_ev15 = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [{type = 'stat', stat = 'evasion', value = 15}]
	},
	e_tr_crit = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [{type = 'stat', stat = 'critchance', value = 10}]
	},
	e_tr_resist = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [
			{type = 'stat', stat = 'resistfire', value = 10},
			{type = 'stat', stat = 'resistair', value = 10},
			{type = 'stat', stat = 'resistwater', value = 10},
			{type = 'stat', stat = 'resistearth', value = 10},
		]
	},
	e_tr_armor = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [{type = 'stat', stat = 'armor', value = 5}]
	},
	e_tr_hpmax = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [{type = 'stat', stat = 'hpmax', value = 25}]
	},
	e_tr_speed = {#no icon for buff as this is the only effect of trait. version with icon exists too
		type = 'static',
		effects = [{type = 'stat', stat = 'speed', value = 10}]
	},
	e_tr_regen = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'trigger',
		trigger = variables.TR_TURN_F,
		conditions = [],
		effects = [{type = 'stat_once', stat = 'hppercent', value = 5}]
	},
	e_tr_noevade = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [],
		effects = ['noevade10']
	},
	e_tr_prot = {
		type = 'static',
		effects = ['prot_icon', {type = 'stat', stat = 'armor', value = 10}]
	},
	e_tr_areaprot = {
		type = 'area',
		area = 'back',
		value = 'e_tr_prot',
		effects = ['area_prot_icon']
	},
	e_tr_healer = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [{target = 'skill', check = 'tag', value = 'heal'}],
		effects = [{type = 'skill', new_type = 'stat_once', target = 'caster', stat = 'hp', value = 'value', mul = 0.5}]
	},
	e_tr_react = {
		type = 'trigger',
		trigger = variables.TR_DMG,
		conditions = [],
		effects = ['react']
	},
	e_tr_magecrit = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [{target = 'skill', check = 'result', value = variables.RES_CRIT}],
		effects = [
			{type = 'skill', new_type = 'stat_once', target = 'caster', stat = 'mana', value = 'manacost', mul = 1}, 
			'magecrit_once'
		]
	},
	e_tr_slowarrow = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [{target = 'skill', check = 'result', value = variables.RES_HITCRIT}],
		effects = ['slowarrow']
	},
	e_tr_killer = {
		type = 'trigger',
		trigger = variables.TR_KILL,
		effects = ['killer', 'clear_killer', 'killer_once']
	},
	e_tr_rangecrit = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [
			{target = 'skill', check = 'result', value = variables.RES_CRIT} 
		],
		effects = [{type = 'param', stat = 'armor_p', value = 100000, target = 'skill'}]
	},
	e_tr_speed_icon = {
		type = 'static',
		effects = ['speed_icon', {type = 'stat', stat = 'speed', value = 10}]
	},
	e_tr_areaspeed = {
		type = 'area',
		area = 'line',
		value = 'e_tr_speed_icon',
		effects = ['area_speed_icon']
	},
	e_tr_noresist = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [],
		effects = ['noresist']
	},
	#skills
	e_s_stun05 = {
		type = 'oneshot',
		trigger = variables.TR_HIT,
		conditions = [
			{target = 'skill', check = 'result', value = variables.RES_HITCRIT},
			{target = 'chance', value = 50}
		],
		effects = ['stun1']
	},
	e_s_restoremana20 = {
		type = 'oneshot',
		trigger = variables.TR_CAST,
		effect = [{type = 'stat_once', stat = 'mana', value = 20}]
	},
	#weapon
	#item
	#secondary
	e_stun = {
		type = 'static',
		disable = true,
		effects = ['stun_icon']
	},
	e_noevade10 = {
		type = 'static',
		effects = ['noevade_icon', {type = 'stat', stat = 'evasion', value = -10}]
	},
	e_react = {
		type = 'static',
		effects = ['react_icon', {type = 'stat', stat = 'speed', value = 20}]
	},
	e_magecrit_once = {#ensure one triggering of magecrit per cast, potential unsafe construction (works only because after skill activating player can't deactivate and activate traits) do not copy this pattern for blocking effects for more than 0 time
		type = 'static',
		effects = [{type = 'block_effect', effect = 'e_tr_magecrit'}]
	},
	e_slowarrow = {
		type = 'static',
		effects = ['slowarrow', 
			{type = 'stat', stat = 'evasion', value = -10},
			{type = 'stat', stat = 'speed', value = -10}]
	},
	e_killer = {
		type = 'static',
		effects = ['tr_killer', 'killer_icon']
	},
	e_t_kiler = {
		type = 'trigger',
		trigger = variables.TR_HIT,
		conditions = [],
		effects = [
			{type = 'param_m', stat = 'value', value = 2, target = 'skill'},
			'clear_killer']
	},
	e_killer_once = {#ensure one triggering of magecrit per cast, potential unsafe construction (works only because after skill activating player can't deactivate and activate traits) do not copy this pattern for blocking effects for more than 0 time
		type = 'static',
		effects = [{type = 'block_effect', effect = 'e_tr_killer'}]
	},
	e_noresist = {#no icon for buff as this is the only effect of trait. can add if reqired
		type = 'static',
		effects = [
			{type = 'stat', stat = 'resistfire', value = -15},
			{type = 'stat', stat = 'resistair', value = -15},
			{type = 'stat', stat = 'resistwater', value = -15},
			{type = 'stat', stat = 'resistearth', value = -15},
			'noresist_icon'
		]
	},
};

var atomic = {
	#icons
	stun_icon = {type = 'buff', value = 'stun'},
	noevade_icon = {type = 'buff', value = 'noevade'},
	prot_icon = {type = 'buff', value = 'prot10'},
	area_prot_icon = {type = 'buff', value = 'area_prot'},
	react_icon = {type = 'buff', value = 'react'},
	killer_icon = {type = 'buff', value = 'killer'},
	speed_icon = {type = 'buff', value = 'speed'},
	area_speed_icon = {type = 'buff', value = 'area_speed'},
	noresist_icon = {type = 'buff', value = 'noresist'},
	#add effect
	stun1 = {type = 'temp_effect', target = 'target', effect = 'e_stun', duration = 1, stack = 10},
	noevade10 = {type = 'temp_effect', target = 'target', effect = 'e_noevade10', duration = 2, stack = 1},
	react = {type = 'temp_effect', effect = 'e_react', duration = 2, stack = 1},
	magecrit_once = {type = 'temp_effect', target = 'caster', effect = 'e_magecrit_once', duration = 0, stack = 1},
	slowarrow = {type = 'temp_effect', target = 'target', effect = 'e_slowarrow', duration = 2, stack = 2},
	killer = {type = 'effect', effect = 'e_killer'},
	tr_killer = {type = 'effect', effect = 'e_t_killer'},
	clear_kiler = {type = 'delete_effect', effect = 'e_killer'},
	killer_once = {type = 'temp_effect', effect = 'e_killer_once', duration = 0, stack = 1},
	noresist = {type = 'temp_effect', target = 'target', effect = 'e_noresist', duration = 1, stack = 1},
};
#needs filling
var buffs = {
	#code = {icon, description}
	stun = {icon = Null, description = null},
	noevade = {icon = Null, description = null},
	prot10 = {icon = Null, description = null},
	area_prot = {icon = Null, description = null}, #marks owner of area protection effect
	react = {icon = Null, description = null},
	slowarrow = {icon = Null, description = null},
	killer = {icon = Null, description = null},
	speed = {icon = Null, description = null},
	area_speed = {icon = Null, description = null}, #marks owner of area speed effect
	noresist = {icon = Null, description = null},
};