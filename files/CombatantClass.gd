extends Node







var lootlist = {
	elvenratloot = {
		
		
	}
	
}

var classlist = {
	warrior = {
		code = 'warrior',
		name = tr("WARRIOR"),
		description = tr("WARRIORDESCRIPT"),
		gearsubtypes = ['dagger','sword','axe','spear','heavy','light'],
		basehp = 200,
		basemana = 25,
		speed = 50,
		damage = 15,
		skills = ['attack','slash'],
		learnableskills = [],
		icon = null,
	},
	mage = {
		code = 'mage',
		name = tr("MAGE"),
		description = tr("MAGEDESCRIPT"),
		gearsubtypes = ['rod','robe','dagger'],
		basehp = 100,
		basemana = 100,
		speed = 30,
		damage = 15,
		skills = ['attack', 'firebolt', 'concentrate'],
		learnableskills = [],
		icon = null,
	}
	
}

var charlist = {
	Arron = {
		code = 'Arron',
		name = 'Arron',
		icon = 'arron',
		image = 'Arron',
		subclass = 'warrior',
	},
	Rose = {
		code = 'Rose',
		name = 'Rose',
		icon = 'rose',
		image = 'Rose',
		subclass = 'mage',
	},
}

class combatant:
	var id
	var name
	var base
	
	var icon
	
	var level = 1
	var baseexp = 0 setget exp_set
	
	var xpreward #for enemies
	
	var hp = 0 setget hp_set
	var hppercent = 0
	var hpmaxvalue = 0
	var hpmax = 0
	var defeated = false
	var mana = 0 setget mana_set
	var manamax = 0
	var damage = 0 setget damage_set, damage_get
	var evasion = 0
	var hitrate = 0
	var armor = 0
	var armorpenetration = 0
	var mdef = 0
	var speed = 0
	var resistfire = 0
	var resistearth = 0
	var resistwater = 0
	var resistair = 0
	var image
	var portrait
	var gear = {helm = null, chest = null, gloves = null, boots = null, rhand = null, lhand = null, neck = null, ring1 = null, ring2 = null}
	var skills = ['attack']
	var traits = {}
	var traitpoints = 0
	var inactiveskills = []
	var cooldowns = []
	var buffs = {}
	var passives = {skillhit = [], spellhit = [], anyhit = [], endturn = []} # combat passives
	var classpassives = {}
	var position
	var price = 0
	var loottable
	var selectedskill = 'attack'
	var effects = {}
	#mods
	var damagemod = 1
	var hpmod = 1
	var manamod = 1
	var xpmod = 1
	
	var displaynode
	
	var detoriatemod = 1
	#ai
	var ai
	var aiposition
	var aimemory
	
	func damage_set(value):
		damage = value
	
	func damage_get():
		return damage * damagemod
	
	func hpmax():
		var value = ceil(hpmax*hpmod)
		hpmaxvalue = value
		return value
	
	func manamax():
		return ceil(manamax*manamod)
	
	func hp_set(value):
		hp = clamp(value, 0, hpmax())
		if displaynode != null:
			displaynode.update_hp()
		hppercent = hp/hpmax()*100
	
	func mana_set(value):
		mana = clamp(value, 0, manamax())
		if displaynode != null:
			displaynode.update_mana()
	
	func exp_set(value):
		baseexp = value
		while baseexp > 100:
			baseexp -= 100
			levelup()
		
	
	func levelup():
		level += 1
	
	func add_buff(buff):#= {caster, code, effects = [{value, stat}], tags, icon, duration}
		buffs[buff.code] = buff
		for i in buff.effects:
			self[i.stat] += i.value
	
	func remove_buff(buff):
		buff = buffs[buff]
		for i in buff.effects:
			self[i.stat] -= i.value
		buffs.erase(buff.code)
	
	func createfromenemy(enemy):
		var template = globals.enemylist[enemy]
		base = enemy
		hpmax = template.basehp
		self.hp = hpmax
		manamax = template.basemana
		speed = template.speed
		mana = manamax
		skills = template.skills
		for i in template.resists:
			self['resist' + i] = template.resists[i]
		for i in ['damage','name','hitrate','evasion','armor','armorpenetration','mdef','speed','icon', 'aiposition', 'loottable', 'xpreward']:
			self[i] = template[i]
		
	
	func createfromclass(classid):
		var classtemplate = globals.classes[classid].duplicate()
		id = state.heroidcounter
		state.heroidcounter += 1
		base = classtemplate.code
		hpmax = classtemplate.basehp
		self.hp = hpmax
		manamax = classtemplate.basemana
		mana = manamax
		speed = classtemplate.speed
		skills = classtemplate.skills
		damage = classtemplate.damage
		hitrate = 85
		price = variables.BaseHeroPrice
		
		name = combatantdata.namesarray[randi()%combatantdata.namesarray.size()]
		
		var newtrait = createtrait(self, 'starter')
		
		traits.append(newtrait)
		
	
	func createfromname(charname):
		var nametemplate = globals.characters[charname]
		var classid = nametemplate.subclass
		var classtemplate = globals.classes[classid].duplicate()
		id = state.heroidcounter
		state.heroidcounter += 1
		base = classtemplate.code
		hpmax = classtemplate.basehp
		speed = classtemplate.speed
		self.hp = hpmax
		manamax = classtemplate.basemana
		mana = manamax
		skills = classtemplate.skills
		icon = nametemplate.icon
		image = nametemplate.image
		damage = classtemplate.damage
		hitrate = 80
		name = nametemplate.name
	
	
	func checkequipmenteffects():
		pass
#		for i in passives.values():
#			if i.trigger == 'onequip':
#				checkpassive(i)
	

	func checkpassive(passive, change = true):
		var prevresult = passive.enabled
		var effect = globals.effects[passive.code]
		
		var check = true
		for i in effect.reqs:
			if input_handler.requirementcombatantcheck(i, self) == false:
				check = false
		
		
		if prevresult != passive.enabled && change:
			passive.enabled = check
			for i in effect.effects:
				if passive.enabled == false:
					self[i.effect] -= i.value
					passives.erase(effect.code)
				elif passive.enabled == true:
					self[i.effect] += i.value
					passives.append(effect.code)
		
		return check
	
	func applytrait(traitcode):
		var trait = globals.traits[traitcode]
		for i in trait.effects():
			if i.trigger == 'onactive':
				pass
			else:
				addpassiveeffect(i.triggereffect)
	
	
	func seteffect(passive):
		var effect = globals.effects[passive.code]
		var state = passive.enabled
		for i in effect.effects:
			if state == false:
				self[i.effect] -= i.value
				passives.erase(effect.code)
			elif state == true:
				self[i.effect] += i.value
				passives.append(effect.code)
	
	func equip(item):
		
		for i in item.multislots:
			if gear[i] != null:
				unequip(state.items[gear[i]])
		
		
		for i in item.availslots:
			if gear[i] != null:
				unequip(state.items[gear[i]])
			gear[i] = item.id
		
		
		item.owner = id
		#adding bonuses
		for i in item.bonusstats:
			self[i] += item.bonusstats[i]
		for i in item.effects:
			addpassiveeffect(i)
		
		
		checkequipmenteffects()
	
	func addpassiveeffect(passive):
		var effect = globals.effects[passive]
		if !passives.has(effect.trigger):
			passives[effect.trigger] = []
		passives[effect.trigger].append(effect)
	
	func removepassiveeffect(passive):
		passives[globals.effects[passive].trigger].erase(globals.effects[passive])
	
	func unequip(item):
		
		#removing links
		item.owner = null
		for i in gear:
			if gear[i] == item.id:
				gear[i] = null
		
		#removing bonuses
		for i in item.bonusstats:
			self[i] -= item.bonusstats[i]
		
		for i in item.effects:
			removepassiveeffect(i)
		
		checkequipmenteffects()
	
	func hitchance(target):
		var chance = hitrate - target.evasion
		if randf() <= chance/100:
			return true
		else:
			return false
	
	
	
	func death():
		pass
	
	func portrait():
		if icon != null:
			return images.combatportraits[icon]
	
	func portrait_circle():
		if icon != null:
			return images.circleportraits[icon]
	
	func createtrait(data, type = 'starter'):
		var array = []
		for i in globals.traits.values():
			if i.type == type && data.traits.has(i) == false:
				array.append([i.code, i.weight])
		return input_handler.weightedrandom(array)




var namesarray = ['name1','name2','name3','name4','name5']



var traitlist = {
	fencer = { #+20 hit when using sword
		code = 'fencer',
		name = tr("FENCER"),
		description = tr("FENCERDESCRIPT"),
		effects = ['fencer'],
		type = 'fighter',
		weight = 1,
		},
	destroyer = { #+20% dmg, equipment breaks 25% faster
		code = 'destroyer',
		name = tr("DESTROYER"),
		description = tr("DESTROYERDESCRIPT"),
		effects = ["destroyer"],
		type = 'starter',
		weight = 1,
		},
	speedster = { #+20% speed, -15 hit
		code = 'speedster',
		name = tr("SPEEDSTER"),
		description = tr("SPEEDSTERDESCRIPT"),
		effects = ['speedster'],
		type = 'starter',
		weight = 1,
		},
	slayer = { #+15 armorpen, -20% hp
		code = 'slayer',
		name = tr("SLAYER"),
		description = tr("SLAYERDESCRIPT"),
		effects = ['slayer'],
		type = 'starter',
		weight = 1,
		},
	brute = { #+20%hp, -20 evasion
		code = 'brute',
		name = tr("BRUTE"),
		description = tr("BRUTEDESCRIPT"),
		effects = ['brute'],
		type = 'starter',
		weight = 1,
		},
	arcane = { #+15 mdef, -15% hp
		code = 'arcane',
		name = tr("ARCANE"),
		description = tr("ARCANEDESCRIPT"),
		effects = ['arcane'],
		type = 'starter',
		weight = 1,
		},
	precise = { #+20 hit, -15 armor
		code = 'precise',
		name = tr("PRECISE"),
		description = tr("PRECISEDESCRIPT"),
		effects = ['precise'],
		type = 'starter',
		weight = 1,
		},
	resourceful = { #+drop, -15 dmg, hp
		code = 'resourceful',
		name = tr("RESOURCEFUL"),
		description = tr("RESOURCEFULDESCRIPT"),
		effects = ['resourceful', 'resourcefulaftercombat'],
		type = 'starter',
		weight = 1,
		},
	elusive = { #+dodge, -mdef
		code = 'elusive',
		name = tr("ELUSIVE"),
		description = tr("ELUSIVEDESCRIPT"),
		effects = ['elusive'],
		type = 'starter',
		weight = 1,
		},
	thick = { #+armor, -hp after combat
		code = 'thick',
		name = tr("THICK"),
		description = tr("THICKDESCRIPT"),
		effects = ['thick', 'thickaftercombat'],
		type = 'starter',
		weight = 1,
		},
	bookworm = { #+mana, -damage
		code = 'bookworm',
		name = tr("BOOKWORM"),
		description = tr("BOOKWORMDESCRIPT"),
		effects = ['bookworm'],
		type = 'starter',
		weight = 1,
		},
	}




var effectlist = {
	fencer = {
		code = 'fencer',
		trigger = 'onequip',
		reqs = [{type = 'gear',slot = 'any', operant = 'eq', name = 'subtype', value = 'sword'}],
		effects = [{effect = 'hitrate', value = 20}],
	},
	destroyer = {
		code = 'destroyer',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'damagemod', value = 0.2},{effect = 'detoriatemod', value = 0.25}],
	},
	speedster = {
		code = 'speedster',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'speed', value = 20},{effect = 'hitrate', value = -15}],
	},
	slayer = {
		code = 'slayer',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'armorpenetration', value = 15},{effect = 'hpmod', value = -0.2}],
	},
	brute = {
		code = 'brute',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'hpmod', value = 0.2},{effect = 'evasion', value = -20}],
	},
	arcane = {
		code = 'arcane',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'hpmod', value = -0.15},{effect = 'mdef', value = 15}],
	},
	precise = {
		code = 'precise',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'hitrate', value = 20},{effect = 'armor', value = -15}],
	},
	resourceful = {
		code = 'resourceful',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'damagemod', value = -15},{effect = 'hpmod', value = -0.15}],
	},
	resourcefulaftercombat = {
		code = 'resourcefulaftercombat',
		trigger = 'aftercombatglobal',
		reqs = [],
		effects = [{effect = 'droprate', value = 15}],
	},
	elusive = {
		code = 'elusive',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'mdef', value = -15},{effect = 'evasion', value = 20}],
	},
	thick = {
		code = 'thick',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'armor', value = 20},{effect = 'mdef', value = 15}],
	},
	thickaftercombat = {
		code = 'thickaftercombat',
		trigger = 'aftercombatself',
		reqs = [],
		effects = [{effect = 'hp', value = 5}],
	},
	bookworm = {
		code = 'bookworm',
		trigger = 'always',
		reqs = [],
		effects = [{effect = 'manamod', value = 20},{effect = 'damagemod', value = -15}],
	},
	
}
