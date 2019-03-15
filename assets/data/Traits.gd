extends Node


#NEW PART, not fully filled

var traitlist = {
	damagebeast = {
		code = 'damagebeast',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_dmgbeast']
	},
	nodamagebeast = {
		code = 'nodamagebeast',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_nodmgbeast']
	},
	fastlearn = {
		code = 'fastlearn',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_fastlearn']
	},
	hitrate = {
		code = 'hitrate',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_hitrate']
	},
	ev10 = {
		code = 'ev10',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_ev10']
	},
	ev15 = {
		code = 'ev15',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_ev15']
	},
	crit = {
		code = 'fastlearn',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_crit']
	},
	resist = {
		code = 'resist',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_resist']
	},
	armor = {
		code = 'armor',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_armor']
	},
	speed = {
		code = 'speed',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_speed']
	},
	hpmax = {
		code = 'hpmax',
		name = '',
		description = '',
		icon = null,
		req_class = 'all',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_crit']
	},
	regen = {
		code = 'regen',
		name = '',
		description = '',
		icon = null,
		req_class = 'warrior',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_regen']
	},
	noevade = {
		code = 'noevade',
		name = '',
		description = '',
		icon = null,
		req_class = 'warrior',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_noevade']
	},
	areaprot = {
		code = 'areaprot',
		name = '',
		description = '',
		icon = null,
		req_class = 'warrior',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_areaprot', 'e_tr_prot']
	},
	healer = {
		code = 'healer',
		name = '',
		description = '',
		icon = null,
		req_class = 'mage',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_healer']
	},
	react = {
		code = 'react',
		name = '',
		description = '',
		icon = null,
		req_class = 'mage',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_react']
	},
	magecrit = {
		code = 'magecrit',
		name = '',
		description = '',
		icon = null,
		req_class = 'mage',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_magecrit']
	},
	slowarrow = {
		code = 'slowarrow',
		name = '',
		description = '',
		icon = null,
		req_class = 'archer',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_slowarrow']
	},
	killer = {
		code = 'killer',
		name = '',
		description = '',
		icon = null,
		req_class = 'archer',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_killer']
	},
	rangecrit = {
		code = 'rangecrit',
		name = '',
		description = '',
		icon = null,
		req_class = 'archer',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_rangecrit']
	},
	areaspeed = {
		code = 'areaspeed',
		name = '',
		description = '',
		icon = null,
		req_class = 'brawler',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_areaspeed', 'e_tr_speed_icon']
	},
	noresist = {
		code = 'noresist',
		name = '',
		description = '',
		icon = null,
		req_class = 'brawler',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_noresist']
	},
	firefist = {
		code = 'firefist',
		name = '',
		description = '',
		icon = null,
		req_class = 'brawler',
		cost = 1,
		hidden = false, #is not displayed at all
		non_editable = false, #displayed but can not be deactivated
		effects = ['e_tr_firefist']
	},
	#class passives
	arch_trait = {
		code = 'arch_trait',
		name = '',
		description = '',
		icon = null,
		req_class = 'auto',
		cost = 0,
		hidden = false, #is not displayed at all
		non_editable = true, #displayed but can not be deactivated
		effects = []
	},
	mage_trait = {
		code = 'mage_trait',
		name = '',
		description = '',
		icon = null,
		req_class = 'auto',
		cost = 0,
		hidden = false, #is not displayed at all
		non_editable = true, #displayed but can not be deactivated
		effects = []
	},
	#monsters
	el_heal = {
		code = 'el_heal',
		name = '',
		description = '',
		icon = null,
		req_class = 'monster',
		cost = 0,
		hidden = false, #is not displayed at all
		non_editable = true, #displayed but can not be deactivated
		effects = ['e_tr_elheal']
	},
	dw_fury = {
		code = 'dw_fury',
		name = '',
		description = '',
		icon = null,
		req_class = 'monster',
		cost = 0,
		hidden = false, #is not displayed at all
		non_editable = true, #displayed but can not be deactivated
		effects = ['e_tr_dwarwenbuf', 'e_tr_dwarwenclear']
	},
};