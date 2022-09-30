extends Node


var charlist = {
	arron = {
		code = 'Arron',
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
		skilllist = ['fencing', 'lunge', 'sideslash', 'swift_s', 'parry', 'sword_mastery', 'termination', 'smoke_s'],
		dead = load("res://assets/images/Fight/Heroes/Arron/arron_death/arron_d.tres")
	},
	rose = {
		code = 'Rose',
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
			dead = load("res://assets/images/Fight/Heroes/Rose/rose_death/rose_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Rose/Rose_death/rouz_death_20.png"),
		},
		flavor = 'My loyal pet',
		hpmax = 40,
		hp_growth = 80,
		evasion = 0,
		hitrate = 100,
		damage = 35,
		unlocked = false,
		bonusres = ['slash', 'water', 'air', 'dark'],
		skilllist = ['swipe', 'fire_bolt', 'flash', 'deluge', 'renew', 'dispel', 'explosion', 'protect'],
	},
	erika = {
		code = 'Erika',
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
			dead = load("res://assets/images/Fight/Heroes/Erika/erika_death/erika_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Erika/Erika_death/Erika_death_16.png"),
		},
		flavor = 'An elven gal',
		hpmax = 45,
		hp_growth = 90,
		evasion = 0,
		hitrate = 100,
		damage = 32,
		unlocked = false,
		bonusres = ['water', 'light', 'pierce', 'earth'],
		skilllist = ['qshot', 'aarrow', 'eastrike', 'frost_arrow', 'arr_shower', 'nat_bless', 'heartseeker', 'charm'],
	},
	ember = {
		code = 'Ember',
		name = 'EMBER',
		icon = 'portrait/EmberNormal',
		combaticon = 'combat/ember_circle',
		image = 'emberhappy',
		animations = {
			idle = load("res://assets/images/Fight/Heroes/Ember/Ember_idle/Ember.tres"),
			hit = "Fight/Heroes/Ember/Fight_spritesFHD_0006s_0001_Ember_hit",
			attack = "Fight/Heroes/Ember/Fight_spritesFHD_0006s_0000_Ember_idle",
			idle_1 = "Fight/Heroes/Ember/Fight_spritesFHD_0006s_0002_Ember_idle",
			dead = load("res://assets/images/Fight/Heroes/Ember/ember_death/ember_d.tres"),
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
		skilllist = ['combo', 'firepunch', 'shockwave', 'uppercut', 'defend', 'dragon_protection', 'aegis', 'earthquake'],
	},
	rilu = {
		code = 'Rilu',
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
			dead = load("res://assets/images/Fight/Heroes/Rilu/Rilu_death/rilu_d.tres"),
			dead_1 = load("res://assets/images/Fight/Heroes/Rilu/rilu_death/rilu_d.tres"),
		},
		flavor = 'A dragon gal',
		hpmax = 55,
		hp_growth = 110,
		evasion = 0,
		hitrate = 100,
		damage = 28,
		unlocked = false,
		bonusres = ['dark', 'light', 'water', 'pierce'],
		skilllist = ['dark_orb', 'pale_mist', 'avalanche', 'soulthorns', 'dark_echoes', 'restoration', 'soul_beam', 'soul_prot'],
	},
	iola = {
		code = 'Iola',
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
		flavor = 'A dragon gal',
		hpmax = 40,
		hp_growth = 85,
		evasion = 0,
		hitrate = 100,
		damage = 25,
		unlocked = false,
		bonusres = ['bludgeon', 'dark', 'fire', 'air'],
		skilllist = ['holy_light', 'gustofwind', 'smash', 'cleansing', 'barrier', 'bless', 'sanctuary', 'purge'],
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
