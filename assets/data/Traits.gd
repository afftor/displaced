extends Node


#NEW PART, not fully filled

var traitlist = {
	beastbonusdamage = {
		code = 'beastbonusdamage',
		name = '',
		description = tr('TRAITBEASTBONUSDAMAGE'),
		icon = load("res://assets/images/traits/beastdamage.png"),
		cost = 1,
		price = 100,
		hidden = false, #is not displayed at all
		effects = ['e_tr_dmgbeast']
	},
	beastbonusresist = {
		code = 'beastbonusresist',
		name = '',
		description = tr('TRAITBEASTBONUSRESIST'),
		icon = load("res://assets/images/traits/beastresist.png"),
		cost = 1,
		price = 100,
		hidden = false, #is not displayed at all
		effects = ['e_tr_nodmgbeast']
	},
	bonusexp = {
		code = 'bonusexp',
		name = '',
		description = tr('TRAITBEASTBONUSEXP'),
		icon = load("res://assets/images/traits/experience.png"),
		cost = 1,
		price = 200,
		hidden = false, #is not displayed at all
		effects = ['e_tr_fastlearn']
	},
	bonushit = {
		code = 'bonushit',
		name = '',
		description = tr('TRAITBONUSHIT'),
		icon = load("res://assets/images/traits/hitrate.png"),
		cost = 1,
		price = 150,
		hidden = false, #is not displayed at all
		effects = ['e_tr_hitrate']
	},
	bonusevasion = {
		code = 'bonusevasion',
		name = '',
		description = tr('TRAITBONUSEVASION'),
		icon = load("res://assets/images/traits/dodge.png"),
		cost = 1,
		price = 200,
		hidden = false, #is not displayed at all
		effects = ['e_tr_ev10']
	},
	bonusevasionplus = {
		code = 'bonusevasionplus',
		name = '',
		description = tr('TRAITBONUSEVASIONPLUS'),
		icon = load("res://assets/images/traits/dodgeplus.png"),
		cost = 1,
		price = 250,
		hidden = false, #is not displayed at all
		effects = ['e_tr_ev15']
	},
	bonuscrit = {
		code = 'bonuscrit',
		name = '',
		description = tr('TRAITBONUSCRIT'),
		icon = load("res://assets/images/traits/critrate.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_crit']
	},
	bonusresist = {
		code = 'bonusresist',
		name = '',
		description = tr('TRAITBONUSRESIST'),
		icon = load("res://assets/images/traits/allresist.png"),
		cost = 1,
		price = 250,
		hidden = false, #is not displayed at all
		effects = ['e_tr_resist']
	},
	bonusarmor = {
		code = 'bonusarmor',
		name = '',
		description = tr('TRAITBONUSARMOR'),
		icon = load("res://assets/images/traits/armor.png"),
		cost = 1,
		price = 200,
		hidden = false, #is not displayed at all
		effects = ['e_tr_armor']
	},
	bonusspeed = {
		code = 'bonusspeed',
		name = '',
		description = tr('TRAITBONUSSPEED'),
		icon = load("res://assets/images/traits/speed.png"),
		cost = 1,
		price = 200,
		hidden = false, #is not displayed at all
		effects = ['e_tr_speed']
	},
	bonushpmax = {
		code = 'bonushpmax',
		name = '',
		description = tr('TRAITBONUSHPMAX'),
		icon = load("res://assets/images/traits/health.png"),
		cost = 1,
		price = 200,
		hidden = false, #is not displayed at all
		effects = ['e_tr_hpmax']
	},
	bonusregen = {
		code = 'bonusregen',
		name = '',
		description = tr('TRAITBONUSREGEN'),
		icon = load("res://assets/images/traits/hprecovery.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_regen']
	},
	dodgedebuff = {
		code = 'dodgedebuff',
		name = '',
		description = tr('TRAITDODGEDEBUFF'),
		icon = load("res://assets/images/traits/dodgedebuff.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_noevade']
	},
	grouparmor = {
		code = 'grouparmor',
		name = '',
		description = tr('TRAITGROUPARMOR'),
		icon = load("res://assets/images/traits/armorgroup.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_areaprot', 'e_tr_prot']
	},
	doubleheal = {
		code = 'doubleheal',
		name = '',
		description = tr('TRAITDOUBLEHEAL'),
		icon = load("res://assets/images/traits/healthskillsdouble.png"),
		cost = 1,
		price = 200,
		hidden = false, #is not displayed at all
		effects = ['e_tr_healer']
	},
	speedondamage = {
		code = 'speedondamage',
		name = '',
		description = tr('TRAITSPEEDONDAMAGE'),
		icon = load("res://assets/images/traits/speedondamage.png"),
		cost = 1,
		price = 250,
		hidden = false, #is not displayed at all
		effects = ['e_tr_react']
	},
	spellcritbonus = {
		code = 'spellcritbonus',
		name = '',
		description = tr('TRAITSPELLCRITBONUS'),
		icon = load("res://assets/images/traits/spellcritbonus.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_magecrit']
	},
	speeddebuff = {
		code = 'speeddebuff',
		name = '',
		description = tr('TRAITSPEEDDEBUFF'),
		icon = load("res://assets/images/traits/speeddebuf.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_slowarrow']
	},
	bowextradamage = {
		code = 'bowextradamage',
		name = '',
		description = tr('TRAITBOWEXTRADAMAGE'),
		icon = load("res://assets/images/traits/bowextradamage.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_killer']
	},
	critarmorignore = {
		code = 'critarmorignore',
		name = '',
		description = tr('TRAITCRITARMORIGNORE'),
		icon = load("res://assets/images/traits/armorignore.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_rangecrit']
	},
	dodgegroup = {
		code = 'dodgegroup',
		name = '',
		description = tr('TRAITDODGEGROUP'),
		icon = load("res://assets/images/traits/dodgegroup.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_areaspeed', 'e_tr_speed_icon']
	},
	resistdebuff = {
		code = 'resistdebuff',
		name = '',
		description = tr('TRAITRESISTDEBUFF'),
		icon = load("res://assets/images/traits/resistdebuf.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_noresist']
	},
	firedamagebonus = {
		code = 'firedamagebonus',
		name = '',
		description = tr('TRAITFIREDAMAGEBONUS'),
		icon = load("res://assets/images/traits/firedamagebonus.png"),
		cost = 1,
		price = 300,
		hidden = false, #is not displayed at all
		effects = ['e_tr_firefist']
	},
	#characters
	rose = {
		code = 'rose',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_rose']
	},
	#class passives
	arch_trait = {
		code = 'arch_trait',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = []
	},
	mage_trait = {
		code = 'mage_trait',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = []
	},
	necro_trait = {
		code = 'necro_trait',
		name = '',
		description = '',
		icon = load("res://assets/images/traits/firedamagebonus.png"),#for test
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_rilu']
	},
	#monsters
	el_heal = {
		code = 'el_heal',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_elheal']
	},
	dw_fury = {
		code = 'dw_fury',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_dwarwenbuf']#, 'e_tr_dwarwenclear']
	},
	treant_barrier = {
		code = 'treant_barrier',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_treant_barrier']
	},
	unstable = {
		code = 'unstable',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_unstable']
	},
	dwking_enrage1 = {
		code = 'dwking_enrage1',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_bloodlust']
	},
	dwking_enrage2 = {
		code = 'dwking_enrage2',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_rage', 'e_dispel_rage']
	},
	dw_enrage = {
		code = 'dw_enrage',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_rage_1', 'e_dispel_rage']
	},
	wounds = {
		code = 'wounds',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_tr_wound']
	},
	test = {
		code = 'test',
		name = '',
		description = '',
		icon = null,
		cost = 0,
		hidden = false, #is not displayed at all
		effects = ['e_test_trigger']
	},
};
