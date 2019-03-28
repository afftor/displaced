extends Node
var S_Skill = preload("res://files/scripts/short_skill.gd");

var skilllist = {
	attack = {
		code = 'attack',
		name = tr("SKILLATTACK"),
		description = tr("SKILLATTACKDESCRIPT"),
		icon = load("res://assets/images/iconsskills/defaultattack.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "weapon",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage'],
		cooldown = 0,
		manacost = 0,
		casteffects = [],
		
		hidden = false,
		sfx = [{code = 'casterattack', target = 'caster', period = 'windup'},{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = 'strike', hittype = 'bodyarmor'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	#mage
	firebolt = {
		code = 'firebolt',
		name = tr("SKILLFIREBOLT"),
		description = tr("SKILLFIREBOLTDESCRIPT"),
		icon = load("res://assets/images/iconsskills/firebolt.png"),
		
		damagetype = "fire",
		skilltype = 'spell',
		userange = "any",
		targetpattern = 'row',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage','*1.1'],
		cooldown = 0,
		manacost = 5,
		casteffects = [],
		
		hidden = false,
		sfx = [{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = 'firebolt', strike = null, hit = 'firehit', hittype = 'absolute'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	minorheal = {
		code = 'minorheal',
		name = tr("SKILLMINORHEAL"),
		description = tr("SKILLMINORHEALDESCRIPT"),
		icon = load("res://assets/images/iconsskills/lesserheal.png"),
		
		damagetype = "magic",
		
		skilltype = 'spell',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['ally','self'],
		reqs = [],
		tags = ['heal'],
		value = ['50'],
		cooldown = 0,
		manacost = 10,
		casteffects = [],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'heal', hit = null, hittype = 'absolute'},
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	concentrate = {
		code = 'concentrate',
		name = tr("SKILLCONCENTRATE"),
		description = tr("SKILLCONCENTRATEDESCRIPT"),
		icon = load("res://assets/images/iconsskills/meditate.png"),
		
		damagetype = "magic",
		
		skilltype = 'spell',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['self'],
		reqs = [],
		tags = ['mana'],
		value = ['0'],
		cooldown = 0,
		manacost = 0,
		casteffects = ['e_s_restoremana20'],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'heal', hit = null, hittype = 'absolute'},
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	firestorm = { #new, to overlook
		code = 'firestorm',
		name = tr("SKILLFIRESTORM"),
		description = tr("SKILLFIREBOLTDESCRIPT"),
		icon = load("res://assets/images/iconsskills/firestorm.png"),
		
		damagetype = "fire",
		skilltype = 'spell',
		userange = "any",
		targetpattern = 'all',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage','*1.1'],
		cooldown = 0,
		manacost = 5,
		casteffects = [],
		
		hidden = false,
		sfx = [{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = 'firebolt', strike = null, hit = 'firehit', hittype = 'absolute'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	#archer
	windarrow = {
		code = 'windarrow',
		name = tr("SKILLWINDARROW"),
		description = tr("SKILLWINDARROWDESCRIPT"),
		icon = load("res://assets/images/iconsskills/windarrow.png"),
		
		damagetype = "air",
		skilltype = 'skill',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [{type = 'gear', slot = 'any', name = 'geartype', operant = 'eq', value = 'bow'}],
		tags = [],
		value = ['caster.damage','*1.3'],
		cooldown = 2,
		manacost = 7,
		casteffects = [],
		
		hidden = false,
		sfx = [{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = null, hittype = 'absolute'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	heavyshot = { #new, to overlook
		code = 'heavyshot',
		name = tr("SKILLSTRONGSHOT"),
		description = tr("SKILLSTRONGSHOTDESCRIPT"),
		icon = load("res://assets/images/iconsskills/heavyshot.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [{type = 'gear', slot = 'any', name = 'geartype', operant = 'eq', value = 'bow'}],
		tags = [],
		value = ['caster.damage','*1.3'],
		cooldown = 2,
		manacost = 7,
		casteffects = ['e_s_stun'],
		
		hidden = false,
		sfx = [{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = null, hittype = 'absolute'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	arrowshower = { #new, to overlook
		code = 'arrowshower',
		name = tr("SKILLARROWSHOWER"),
		description = tr("SKILLARROWSHOWERDESCRIPT"),
		icon = load("res://assets/images/iconsskills/arrowshower.png"),
		
		damagetype = "air",
		skilltype = 'skill',
		userange = "any",
		targetpattern = 'all',
		allowedtargets = ['enemy'],
		reqs = [{type = 'gear', slot = 'any', name = 'geartype', operant = 'eq', value = 'bow'}],
		tags = [],
		value = ['caster.damage','*1.3'],
		cooldown = 2,
		manacost = 7,
		casteffects = [],
		
		hidden = false,
		sfx = [{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = null, hittype = 'absolute'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	#brawler
	tackle = { #not used now. intended?
		code = 'tackle',
		name = tr("SKILLTACKLE"),
		description = tr("SKILLTACKLEDESCRIPT"),
		icon = load("res://assets/images/iconsskills/tackle.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "melee",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage','*0.5'],
		cooldown = 0,
		manacost = 10,
		casteffects = [
#			{period = 'onhit',
#			target = 'target', 
#			effect = 'stun',
#			chance = 0.5,
#			reqs = null,
#			}
			'e_s_stun05'
		],
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = null, hittype = 'bodyarmor'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	cripple = { #new, to overlook
		code = 'cripple',
		name = tr("SKILLCRIPPLE"),
		description = tr("SKILLCRIPPLEDESCRIPT"),
		icon = load("res://assets/images/iconsskills/cripple.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "melee",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage','*0.5'],
		cooldown = 0,
		manacost = 10,
		casteffects = [
			'e_s_cripple'
		],
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = null, hittype = 'bodyarmor'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},

	comboattack = {
		code = 'comboattack',
		name = tr("SKILLCOMBOATTACK"),
		description = tr("SKILLCOMBOATTACKDESCRIPT"),
		icon = load("res://assets/images/iconsskills/comboattack.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "weapon",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage'],
		cooldown = 0,
		manacost = 0,
		casteffects = [],
		repeat = 3,
		
		hidden = false,
		sfx = [{code = 'casterattack', target = 'caster', period = 'windup'},{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = 'strike', hittype = 'bodyarmor'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},

	slash = {
		code = 'slash',
		name = tr("SKILLSLASH"),
		description = tr("SKILLSLASHDESCRIPT"),
		icon = load("res://assets/images/iconsskills/slash.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "melee",
		targetpattern = 'line',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage','*1.2'],
		cooldown = 0,
		manacost = 20,
		casteffects = [],
		
		hidden = false,
		sfx = [{code = 'casterattack', target = 'caster', period = 'windup'},{code = 'targetattack', target = 'target', period = 'predamage'}],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = 'strike', hittype = 'bodyarmor'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	
	

	
	#items
	steakheal = {
		code = 'steakheal',
		name = '',
		description = '',
		icon = null,
		
		damagetype = "food",
		
		skilltype = 'item',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['ally', 'self'],
		reqs = [],
		tags = ['heal'],
		value = ['50'],
		cooldown = 0,
		manacost = 0,
		casteffects = [],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'heal', hit = null, hittype = 'absolute'},
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	bluegrass = { #new, to overlook
		code = 'bluegrass',
		name = '',
		description = '',
		icon = null,
		
		damagetype = "food",
		
		skilltype = 'item',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['ally', 'self'],
		reqs = [],
		tags = ['heal'],
		value = ['0'],
		chance = 100,
		evade = 0,
		critchance = 0,
		cooldown = 0,
		manacost = 0,
		casteffects = ['e_i_restoremana25'],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'heal', hit = null, hittype = 'absolute'},
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	elixir = { #new, to overlook
		code = 'elixir',
		name = '',
		description = '',
		icon = null,
		
		damagetype = "food",
		
		skilltype = 'item',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['ally', 'self'],
		reqs = [],
		tags = ['heal'],
		chance = 100,
		evade = 0,
		value = ['0'],
		cooldown = 0,
		manacost = 0,
		casteffects = ['e_i_elixir'],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'heal', hit = null, hittype = 'absolute'},
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},

	barrier2 = { #new, to overlook
		code = 'barrier2',
		name = '',
		description = '',
		icon = null,
		
		damagetype = "food",
		
		skilltype = 'item',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['ally', 'self'],
		reqs = [],
		tags = ['heal'],
		chance = 100,
		evade = 0,
		value = ['0'],
		cooldown = 0,
		manacost = 0,
		casteffects = ['e_i_barrier2'],
	
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = null, hit = null, hittype = 'absolute'},
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	barrier3 = { #new, to overlook
		code = 'barrier3',
		name = '',
		description = '',
		icon = null,
		
		damagetype = "food",
		
		skilltype = 'item',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['ally', 'self'],
		reqs = [],
		tags = ['heal'],
		chance = 100,
		evade = 0,
		value = ['0'],
		cooldown = 0,
		manacost = 0,
		casteffects = ['e_i_barrier3'],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = null, hit = null, hittype = 'absolute'},
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	
	#monsters
	spider = { #new, to overlook
		code = 'spider',
		name = tr("SKILLSPIDER"),
		description = tr("SKILLSPIDERDESCRIPT"),
		icon = load("res://assets/images/iconsskills/cripple.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "melee",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['caster.damage','*0.5'],
		cooldown = 0,
		manacost = 10,
		casteffects = [
			'e_s_spidernoarmor'
		],
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = 'strike', hittype = 'bodyarmor'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	fairy = { #new, to overlook
		code = 'faery',
		name = tr("SKILLFAIRY"),
		description = tr("SKILLFAIRYDESCRIPT"),
		icon = load("res://assets/images/iconsskills/cripple.png"),
		
		damagetype = "weapon",
		skilltype = 'skill',
		userange = "melee",
		targetpattern = 'single',
		allowedtargets = ['enemy'],
		reqs = [],
		tags = [],
		value = ['0'],
		cooldown = 0,
		manacost = 10,
		casteffects = [
			'e_s_faery'
		],
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = 'strike', hittype = 'bodyarmor'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	summontreant = {
		code = 'summontreant',
		name = tr("SKILLSUMMONTREANT"),
		description = tr("SKILLSUMMONTREANTDESCRIPT"),
		icon = load("res://assets/images/iconsskills/cripple.png"),
		
		damagetype = "summon",
		
		skilltype = 'spell',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['self'],
		reqs = [],
		tags = [],
		value = ['treant', 2],
		cooldown = 2,
		manacost = 0,
		casteffects = ['e_s_restoremana20'],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sounddata = {initiate = null, strike = 'weapon', hit = 'strike', hittype = 'absolute'},
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
}


var buffdict = {
	stun = {code = 'stun', icon = 'stun', name = tr("STUN"), description = tr("STUNDESCRIPT")},
	
}

func makebuff(caster, buffcode):
	var newbuff = buffdict[buffcode].duplicate()
	newbuff.caster = caster

func restoremana(data):
	data.target.mana += data.value

func stun(data):
	var newbuff = makebuff(data.caster, 'stun')
	newbuff.duration = 1
	data.target.effects[newbuff.code] = newbuff
