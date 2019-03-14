extends Node
var S_Skill = preload("res://files/scripts/short_skill.gd");

var skilllist = {
	attack = {
		code = 'attack',
		name = tr("ATTACK"),
		description = tr("ATTACKDESCRIPT"),
		icon = null,
		
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
		sound = null,
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	firebolt = {
		code = 'firebolt',
		name = tr("FIREBOLT"),
		description = tr("FIREBOLTDESCRIPT"),
		icon = null,
		
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
		sound = null,
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	windarrow = {
		code = 'windarrow',
		name = tr("WINDARROW"),
		description = tr("WINDARROWDESCRIPT"),
		icon = null,
		
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
		sound = null,
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	
	tackle = { #not used now. intended?
		code = 'tackle',
		name = tr("TACKLE"),
		description = tr("TACKLEDESCRIPT"),
		icon = null,
		
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
		sound = null,
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	slash = {
		code = 'slash',
		name = tr("SLASH"),
		description = tr("SLASHDESCRIPT"),
		icon = null,
		
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
		sound = null,
		
		aipatterns = ['attack'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
		
	},
	
	minorheal = {
		code = 'minorheal',
		name = tr("MINORHEAL"),
		description = tr("MINORHEALDESCRIPT"),
		icon = null,
		
		damagetype = "magic",
		
		skilltype = 'spell',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['ally'],
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
		sound = null,
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	concentrate = {
		code = 'concentrate',
		name = tr("CONCENTRATE"),
		description = tr("MCONCENTRATEDESCRIPT"),
		icon = null,
		
		damagetype = "magic",
		
		skilltype = 'spell',
		userange = "any",
		targetpattern = 'single',
		allowedtargets = ['self'],
		reqs = [],
		tags = [],
		value = ['0'],
		cooldown = 0,
		manacost = 0,
		casteffects = ['e_s_restoremana20'],
		
		hidden = false,
		sfx = [],
		sfxcaster = null,
		sfxtarget = null,
		sound = null,
		
		aipatterns = ['heal'],
		aitargets = '1ally',
		aiselfcond = 'any',
		aitargetcond = 'any',
		aipriority = 2,
	},
	
	
	steakheal = { #not used now. intended?
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
		sound = null,
		
		aipatterns = ['heal'],
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
