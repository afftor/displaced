extends Node

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
	
	
	#TraitEffects
	
	
}

var combateffects = {
#traits
beastdamage = {effect = 'skillmod', effectvalue = {type = "damagemod", value = ['0.2'], targetreq = {type = 'stats', name = 'race', operant = 'eq', value = 'animal'}}},
protectbeast = {effect = 'skillmod', effectvalue = {type = "damagemod", value = ['-0.2'], targetreq = {type = 'stats', name = 'race', operant = 'eq', value = 'animal'}}},

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