extends Node


var charlist = {
	arron = {
		code = 'arron',
		name = 'ARRON',
		icon = 'portrait/ArronNormal',
		combaticon = 'combat/arron_circle',
		image = 'Arron',
		animations = {
			idle = load("res://assets/images/Fight/Heroes/Arron/Arron_idle/Arron.tres"),
			hit = "Fight/Heroes/Arron/Fight_spritesFHD_0005s_0000_Arron_hit",
			attack = "Fight/Heroes/Arron/Fight_spritesFHD_0005s_0001_Arron_at",
			idle_1 = "Fight/Heroes/Arron/Fight_spritesFHD_0005s_0002_Arron_idle",
			dead = load("res://assets/images/Fight/Heroes/Arron/arron_death/arron_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Arron/arron_death/Arron-5_only death_10.png"),
		},
		flavor = 'The honorable me',
		hpmax = 50,
		hp_growth = 100,
		evasion = 0,
		hitrate = 100,
		damage = 30,
		unlocked = true,
		bonusres = ['slash', 'light', 'fire', 'earth'],
		skilllist = {'fencing':1, 'parry':3, 'lunge':4, 'sword_mastery':8, 'sideslash':10, 'termination':10, 'swift_s':14, 'smoke_s':18},
		dead = load("res://assets/images/Fight/Heroes/Arron/arron_death/arron_d.tres")
	},
	rose = {
		code = 'rose',
		name = 'ROSE',
		icon = 'portrait/RoseNormal',
		combaticon = 'combat/rose_circle',
		image = 'Rose',
		animations = {
			idle = load("res://assets/images/Fight/Heroes/Rose/Rose_idle/Rose.tres"),
			hit = "Fight/Heroes/Rose/Rouz_crop_0001_Rouz_hit",
			attack = "Fight/Heroes/Rose/Rouz_crop_0003_Rouz_at",
			special = "Fight/Heroes/Rose/Rouz_crop_0002_Rouz_cast",
#			idle_1 = "Fight/Heroes/Rose/Rouz_crop_0000_Rouz_idle", # wrong sprite size
			idle_1 = load("res://assets/images/Fight/Heroes/Rose/Rose_idle/Rouz_idle_00.png"),
			dead = load("res://assets/images/Fight/Heroes/Rose/Rose_death/rose_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Rose/Rose_death/rouz_death_20.png"),
		},
		flavor = 'My loyal pet',
		hpmax = 40,
		hp_growth = 80,
		evasion = 0,
		hitrate = 100,
		damage = 35,
		unlocked = true,
		bonusres = ['slash', 'water', 'air', 'dark'],
		skilllist = {'fire_bolt':1, 'renew':3, 'swipe':5, 'deluge':8, 'dispel':8, 'explosion':10, 'flash':12,  'protect':16},
	},
	erika = {
		code = 'erika',
		name = 'ERIKA',
		icon = 'portrait/ErikaNormal',
		combaticon = 'combat/erika_circle',
		image = 'erika',
		animations = {
			idle = load("res://assets/images/Fight/Heroes/Erika/Erika_idle/Erika.tres"),
			hit = "Fight/Heroes/Erika/Erika_crop_0000_Erika_hit",
			attack = "Fight/Heroes/Erika/Erika_crop_0002_Erika_at",
#			idle_1 = "Fight/Heroes/Erika/Erika_crop_0001_Erika_-idle",
			idle_1 = load("res://assets/images/Fight/Heroes/Erika/Erika_idle/Erika-animation_02.png"),
			dead = load("res://assets/images/Fight/Heroes/Erika/Erika_death/erika_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Erika/Erika_death/Erika_death_16.png"),
		},
		flavor = 'An elven gal',
		hpmax = 45,
		hp_growth = 90,
		evasion = 0,
		hitrate = 100,
		damage = 32,
		unlocked = false,
		traits = ['erica_nature_bless'],
		bonusres = ['water', 'light', 'pierce', 'earth'],
		skilllist = {'aarrow':1, 'qshot':4, 'arr_shower':6, 'nat_bless':8, 'charm':10,  'eastrike':12, 'frost_arrow':14, 'heartseeker':15},
	},
	ember = {
		code = 'ember',
		name = 'EMBER',
		icon = 'portrait/EmberNormal',
		combaticon = 'combat/ember_circle',
		image = 'emberhappy',
		animations = {
			idle = load("res://assets/images/Fight/Heroes/Ember/Ember_idle/Ember.tres"),
			hit = "Fight/Heroes/Ember/Fight_spritesFHD_0006s_0001_Ember_hit",
			attack = "Fight/Heroes/Ember/Fight_spritesFHD_0006s_0000_Ember_idle",
			idle_1 = "Fight/Heroes/Ember/Fight_spritesFHD_0006s_0002_Ember_idle",
			dead = load("res://assets/images/Fight/Heroes/Ember/Ember_death/ember_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Ember/Ember_death/Ember_death_24.png"),
		},
		flavor = 'A dragon gal',
		hpmax = 80,
		hp_growth = 120,
		evasion = 0,
		hitrate = 100,
		damage = 29,
		unlocked = false,
		bonusres = ['bludgeon', 'air', 'fire', 'earth'],
		skilllist = {'firepunch':1, 'defend':3, 'combo':6, 'uppercut':8, 'shockwave':12, 'earthquake':12, 'dragon_protection':14, 'aegis':18},
	},
	rilu = {
		code = 'rilu',
		name = 'RILU',
		icon = 'portrait/RiluNormal',
		combaticon = 'combat/rilu_circle',
		image = 'emberhappy',
		animations = {
			idle = load("res://assets/images/Fight/Heroes/Rilu/Rilu_idle/Rilu.tres"),
			hit = "Fight/Heroes/Rilu/Fight_spritesFHD_0004s_0000_Rilu_hit",
			attack = "Fight/Heroes/Rilu/Fight_spritesFHD_0004s_0002_Rilu_at",
#			idle_1 = "Fight/Heroes/Rilu/Fight_spritesFHD_0004s_0001_Rilu_idle",
			idle_1 = load("res://assets/images/Fight/Heroes/Rilu/Rilu_idle/Rilu_idle_00.png"),
			dead = load("res://assets/images/Fight/Heroes/Rilu/rilu_death/rilu_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Rilu/rilu_death/rilu_d.tres"),
		},
		flavor = 'A dead gal... Undead actually.',
		hpmax = 55,
		hp_growth = 110,
		evasion = 0,
		hitrate = 100,
		damage = 28,
		unlocked = false,
		traits = ['necro_trait'],
		bonusres = ['dark', 'light', 'water', 'pierce'],
		skilllist = {'dark_orb':1, 'dark_echoes':8, 'avalanche':10, 'soul_beam':12, 'pale_mist':13, 'restoration':14, 'soulthorns':16, 'soul_prot':16},
	},
	iola = {
		code = 'iola',
		name = 'IOLA',
		icon = 'portrait/Iola',
		combaticon = 'combat/iola_circle',
		image = 'emberhappy',
		animations = {
			idle = load("res://assets/images/Fight/Heroes/Iola/Iola_idle/Iola.tres"),
			hit = "Fight/Heroes/Iola/Iola_crop_0000_Iola_hit",
			attack = "Fight/Heroes/Iola/Iola_crop_0001_Iola_cast",
#			idle_1 = "Fight/Heroes/Iola/Iola_crop_0002_Iola_crop",
			idle_1 = load("res://assets/images/Fight/Heroes/Iola/Iola_idle/Iola_idle_00.png"),
			dead = load("res://assets/images/Fight/Heroes/Iola/iola_death/iola_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Iola/iola_death/iola_death_19.png"),
		},
		flavor = 'A cult gal',
		hpmax = 40,
		hp_growth = 85,
		evasion = 0,
		hitrate = 100,
		damage = 25,
		unlocked = false,
		bonusres = ['bludgeon', 'dark', 'fire', 'air'],
		skilllist = {'holy_light':1, 'barrier':8, 'gustofwind':10, 'sanctuary':10, 'smash':12, 'cleansing':14, 'bless':16, 'purge':20},
	},
}

func _ready():
	resources.preload_res('sound/slash') #default
	yield(preload_icons(), 'completed')
	print("Character icons preloaded")


func preload_icons():
	for ch in charlist.values():
#		if b.icon.begins_with("res:"): continue
		resources.preload_res(ch.icon)
		resources.preload_res(ch.combaticon)
		resources.preload_res(ch.image)
		for an in ch.animations.values():
			if an is AnimatedTexAutofill:
				an.fill_frames()
			elif an is String:
				resources.preload_res(an)
	if resources.is_busy(): yield(resources, "done_work")
