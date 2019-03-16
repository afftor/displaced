extends Reference

var id
var name
var base
var race

var icon
var combaticon

var level = 1
var baseexp = 0 setget exp_set

var xpreward #for enemies

var hp = 0 setget hp_set
var hppercent = 100 setget hp_p_set
var hpmaxvalue = 0
var hpmax = 0 setget hp_max_set
var defeated = false
var mana = 0 setget mana_set
var manamax = 0
var damage = 0 setget damage_set, damage_get
var evasion = 0 setget eva_set
var hitrate = 0
var armor = 0 setget ,armor_get
var armorpenetration = 0
var mdef = 0 setget mdef_set
var speed = 0
var critchance = 5
var critmod = 1.5
var resistfire = 0
var resistearth = 0
var resistwater = 0
var resistair = 0
var shield = 0
var shieldtype = variables.S_FULL

var image
var portrait
var combatportrait
var gear = {helm = null, chest = null, gloves = null, boots = null, rhand = null, lhand = null, neck = null, ring1 = null, ring2 = null}

var skills = ['attack']
var traits = {} #{'trait':'state'}
var traitpoints = 0

var inactiveskills = []
var cooldowns = []

var buffs = [] #for display purpose ONLY, list of names 
#var passives = {skillhit = [], spellhit = [], anyhit = [], endturn = []} # combat passives
#var classpassives = {}

#effects new part
var static_effects = []
var temp_effects = []   #{'effect','time'}
var triggered_effects = []
var oneshot_effects = []
var area_effects = [] #{'effect', 'position'}
var own_area_effects = [] 
var timers = [] #{'effect', 'delay'}

var position setget set_position
var combatgroup
var price = 0
var loottable
var selectedskill = 'attack'
#var effects = {}
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
	hppercent = (hp*100)/hpmax()

func hp_max_set(value):
	hpmax = value
	set('hppercent', hppercent)

func hp_p_set(value):
	hppercent = clamp(value, 0, 100)
	set('hp', (hppercent * hpmax()) / 100)

func mana_set(value):
	mana = clamp(value, 0, manamax())
	if displaynode != null:
		displaynode.update_mana()

func exp_set(value):
	baseexp = value
	while baseexp > 100:
		baseexp -= 100
		levelup()

func eva_set(value):
	var delta = value - evasion
	if traits.keys().has('arch_trait') and traits['arch_trait']:
		hitrate += delta
	evasion = value

func mdef_set(value):
	var delta = value - mdef
	if traits.keys().has('mage_trait') and traits['mage_trait']:
		damage += delta * 0.5
	mdef = value

func armor_get():
	return max(0, armor)


func levelup():
	level += 1
	#add trait obtaining and other trait related stuff

func can_acq_trait(trait_code):
	if traits.keys().has(trait_code): return false
	var tmp = Traitdata.traitlist[trait_code]
	if tmp.req_class == 'all' or tmp.req_class == base: return true
	return false

func can_activate_trait(trait_code):
	if !traits.keys().has(trait_code): return false
	if traits[trait_code] == true: return false
	var tmp = Traitdata.traitlist[trait_code]
	if traitpoints >= tmp.cost: return true
	return false

func get_aval_traits():
	var res = []
	for t in Traitdata.traitlist:
		if can_acq_trait(t): res.push_back(t)
	return res

func get_lvup_traits(): #плохой код, я знаю
	var res = get_aval_traits()
	while res.size() > 3:
		var t = randi() % res.size() # в 3.1 обязательно заменить на randi_range, ещё можно сделать рарность трейтов...
		res.remove(t)
		pass
	return res
	pass

func activate_trait(trait_code):
	if !can_activate_trait(trait_code): return
	traits[trait_code] = true
	var tmp = Traitdata.traitlist[trait_code]
	traitpoints -= tmp.cost
	for e in tmp.effects:
		apply_effect(e)
	pass

func deactivate_trait(trait_code):
	if !traits.keys().has(trait_code): return
	if traits[trait_code] == false: return
	traits[trait_code] = false
	var tmp = Traitdata.traitlist[trait_code]
	traitpoints += tmp.cost
	for e in tmp.effects:
		remove_effect(e, 'once')
	pass

func add_trait(trait_code):
	if !can_acq_trait(trait_code): return
	traits[trait_code] = false

#func clear_oneshot():
#	for e in oneshot_effects:
#		remove_effect(e, 'once')
#	oneshot_effects.clear()
#	pass

func apply_atomic(effect): #can be name or dictionary
	var tmp
	if typeof(effect) == TYPE_STRING:
		tmp = Effectdata.atomic[effect]
	else:
		tmp = effect.duplicate()
	match tmp.type:
		'stat_s':
			self.set(tmp.stat, tmp.value)
		'stat_m':
			self.set(tmp.stat, get(tmp.stat) * tmp.value)
		'stat', 'stat_once':
			self.set(tmp.stat, get(tmp.stat) + tmp.value)
			pass
		'effect':
			apply_effect(tmp.effect)
			pass
		'temp_effect':
			apply_temp_effect(tmp.effect, tmp.duration, tmp.stack)
			pass
		'block_effect', 'delete_effect':
			remove_effect(tmp.effect, 'all')
			pass
		'damage':
			deal_damage(tmp.value, tmp.source)
		'buff':
			buffs.push_back(tmp.value)
		'timer':
			timers.push_back({effect = tmp.effect, delay = tmp.delay})
	pass

func remove_atomic(effect):
	var tmp
	if typeof(effect) == TYPE_STRING:
		tmp = Effectdata.atomic[effect]
	else:
		tmp = effect.duplicate()
	match tmp.type:
		'stat_m':
			self.set(tmp.stat, get(tmp.stat) / tmp.value)
		'stat':
			self.set(tmp.stat, get(tmp.stat) - tmp.value)
			pass
		'effect':
			remove_effect(tmp.effect, 'once')
			pass
		'block_effect':
			apply_effect(tmp.effect)
		'buff':
			buffs.remove(tmp.value)
	pass

func find_temp_effect(eff_code):
	var res = -1
	var tres = 9999999
	var nm = 0
	for i in range(temp_effects.size()):
		if temp_effects[i].effect != eff_code:continue
		nm += 1
		if temp_effects[i].time < tres: 
			tres = temp_effects[i].time
			res = i
		pass
	return {num = nm, index = res}
	pass


func apply_temp_effect(eff_code, duration = 1, stack = 1):
	var pos = find_min_temp_effect(eff_code)
	if pos.num < stack:
		temp_effects.push_back({effect = eff_code, time = duration})
		apply_effect(eff_code)
		pass
	else:
		temp_effects[pos.index].time = duration
	pass

func add_area_effect(eff_code):
	var effect = Effectdata.effect_table[eff_code]
	var area = []
	match effect.area:
		'back': if [1,2,3].has(position): area.push_back(position + 3)
		'line':
			if [1,2,3].has(position): area = [1,2,3]
			elif [4,5,6].has(position): area = [4,5,6]
			area.erase(position)
			pass
	#own_area_effects.push_back(effect.code)
	for pos in area:
		for h in state.heroes.values():
			h.add_ext_area_effect({effect = effect.value, position = pos})
		pass
	pass

func remove_area_effect(eff_code):
	var effect = Effectdata.effect_table[eff_code]
	var area = []
	match effect.area:
		'back': if [1,2,3].has(position): area.push_back(position + 3)
		'line':
			if [1,2,3].has(position): area = [1,2,3]
			elif [4,5,6].has(position): area = [4,5,6]
			area.erase(position)
			pass
	#own_area_effects.erase(effect.code)
	for pos in area:
		for h in state.heroes.values():
			h.remove_ext_area_effect({effect = effect.value, position = pos})
		pass
	pass

func add_ext_area_effect(dict):
	area_effects.push_back(dict)
	if dict.position == position: apply_effect(dict.effect)
	pass

func remove_ext_area_effect(dict):
	area_effects.erase(dict)
	if dict.position == position: remove_effect(dict.effect, 'once')
	pass

func set_position(new_pos):
	if new_pos == position: return
	#remove own area effects
	for e in own_area_effects:
		remove_area_effect(e)
		pass
	#remove ext area effects
	for e in area_effects:
		if e.position == position: remove_effect(e.effect)
		pass
	
	position = new_pos
	#reapply own area effects
	for e in own_area_effects:
		add_area_effect(e)
		pass
	#reapply ext area effects
	for e in area_effects:
		if e.position == position: apply_effect(e.effect)
		pass
	pass


func apply_effect(eff_code):
	var tmp = Effectdata.effect_table[eff_code]
	match tmp.type:
		'static':
			static_effects.push_back(eff_code)
			for ee in tmp.effects:
				apply_atomic(ee)
				pass
			pass
		'oneshot':
			#oneshot_effects.push_back(eff_code)
			for ee in tmp.effects:
				apply_atomic(ee)
				pass
			pass
		'trigger':
			triggered_effects.push_back(eff_code)
			pass
		'area':
			own_area_effects.push_back(eff_code)
			add_area_effect(eff_code)
			for ee in tmp.effects:
				apply_atomic(ee)
			pass
	pass

func remove_effect(eff_code, option = 'once'):
	var tmp = Effectdata.effect_table[eff_code]
	match tmp.type:
		'static':
			if option == 'once':
				static_effects.erase(eff_code)
				for ee in tmp.effects:
					remove_atomic(ee)
					pass
				pass
			else:
				while static_effects.has(eff_code):
					static_effects.erase(eff_code)
					for ee in tmp.effects:
						remove_atomic(ee)
						pass
					pass
				pass
			pass
#		'oneshot':
#			for ee in tmp.effects:
#				remove_atomic(ee)
#				pass
#			pass
		'trigger':
			if option == 'once':
				triggered_effects.erase(eff_code)
				pass
			else:
				while triggered_effects.has(eff_code):
					triggered_effects.erase(eff_code)
					pass
				pass
			pass
			pass
		'area':
			own_area_effects.erase(eff_code)
			remove_area_effect(eff_code)
			for ee in tmp.effects:
				remove_atomic(ee)
			pass
	pass

func update_temp_effects():
	for e in temp_effects:
		e.time -= 1
		if e.time < 0:
			remove_effect(e.effect)
			pass
	pass

func update_timers():
	for e in timers:
		e.delay -= 1
		if e.delay < 0:
			apply_effect(e.effect)
			pass
	pass

func basic_check(trigger):
	#clear_oneshot()
	for e in triggered_effects:
		var tmp = Effectdata.effect_table[e]
		if tmp.trigger != trigger: continue
		#check conditions
		var res = true
		for cond in tmp.conditions:
			res = res and input_handler.requirementcombatantcheck(cond, self)
			pass
		if !res: return
		#apply effect
		for ee in tmp.effects:
			apply_atomic(Effectdata.atomic[ee])
		pass
	#clear_oneshot()
	pass

func on_skill_check(skill, check): #skill has to be in constant form without metascripting. this part has to be done in conbat.gd in execute_skill
	#var tt = Skillsdata.skilllist[skill].copy()
	for e in triggered_effects:
		var tmp = Effectdata.effect_table[e]
		if tmp.trigger != check: continue
		#check conditions
		var res = true
		for cond in tmp.conditions:
			match cond.target:
				'skill':
					match cond.check:
						'type':
							res = res and (skill.skilltype == cond.value)
							pass
						'tag':
							res = res and skill.tags.has(cond.value)
							pass
						'result': res = res and (skill.hit_res & cond.value != 0)
					pass
				'caster':
					res = res and input_handler.requirementcombatantcheck(cond.value, skill.caster)
					pass
				'target':
					res = res and input_handler.requirementcombatantcheck(cond.value, skill.target)
					pass
				'chance':
					res = res and (randf()*100 < cond.value)
			pass
		if !res: return
		#apply effect
		
		for ee in tmp.effects:
			var eee = Effectdata.atomic[ee].duplicate()
			var rec
			#convert effect to constant form
			if eee.type == 'skill':
				eee.type = eee.new_type
				eee.value = skill.get(eee.value) * eee.mul
				pass
			match eee.target:
				'caster':
					rec = skill.caster
				'target':
					rec = skill.target
				'skill':
					rec = skill
			rec.apply_atomic(eee)
		pass
	pass



#func add_buff(buff):#= {caster, code, effects = [{value, stat}], tags, icon, duration}
#	buffs[buff.code] = buff
#	for i in buff.effects:
#		self[i.stat] += i.value
#
#func remove_buff(buff):
#	buff = buffs[buff]
#	for i in buff.effects:
#		self[i.stat] -= i.value
#	buffs.erase(buff.code)

func createfromenemy(enemy):
	var template = Enemydata.enemylist[enemy]
	base = enemy
	hpmax = template.basehp
	self.hp = hpmax
	manamax = template.basemana
	speed = template.speed
	mana = manamax
	skills = template.skills
	for i in template.resists:
		self['resist' + i] = template.resists[i]
	for i in ['damage','name','hitrate','evasion','armor','armorpenetration','mdef','speed','combaticon', 'aiposition', 'loottable', 'xpreward']:
		self[i] = template[i]
	if template.keys().has('traits'):
		for t in template.traits:
			traits[t] = true

func createfromclass(classid):
	var classtemplate = combatantdata.classlist[classid].duplicate()
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
#	var newtrait = createtrait(self, classtemplate.code)
#	traits.append(newtrait)
	if classtemplate.keys().has('traits'):
		for t in classtemplate.traits:
			traits[t] = true
	

func createfromname(charname):
	var nametemplate = combatantdata.charlist[charname]
	var classid = nametemplate.subclass
	var classtemplate = combatantdata.classlist[classid].duplicate()
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
	combaticon = nametemplate.combaticon
	image = nametemplate.image
	damage = classtemplate.damage
	hitrate = 80
	name = nametemplate.name


func checkequipmenteffects():
	pass
#		for i in passives.values():
#			if i.trigger == 'onequip':
#				checkpassive(i)

#
#func checkpassive(passive, change = true):
#	var prevresult = passive.enabled
#	var effect = globals.effects[passive.code]
#
#	var check = true
#	for i in effect.reqs:
#		if input_handler.requirementcombatantcheck(i, self) == false:
#			check = false
#
#
#	if prevresult != passive.enabled && change:
#		passive.enabled = check
#		for i in effect.effects:
#			if passive.enabled == false:
#				self[i.effect] -= i.value
#				passives.erase(effect.code)
#			elif passive.enabled == true:
#				self[i.effect] += i.value
#				passives.append(effect.code)
#
#	return check

#func applytrait(traitcode):
#	var trait = globals.traits[traitcode]
#	for i in trait.effects():
#		if i.trigger == 'onactive':
#			pass
#		else:
#			addpassiveeffect(i.triggereffect)


#func seteffect(passive):
#	var effect = globals.effects[passive.code]
#	var state = passive.enabled
#	for i in effect.effects:
#		if state == false:
#			self[i.effect] -= i.value
#			passives.erase(effect.code)
#		elif state == true:
#			self[i.effect] += i.value
#			passives.append(effect.code)

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
		#addpassiveeffect(i)
		#NEED REPLACING
		pass
	
	checkequipmenteffects()
#
#func addpassiveeffect(passive):
#	var effect = globals.effects[passive]
#	if !passives.has(effect.trigger):
#		passives[effect.trigger] = []
#	passives[effect.trigger].append(effect)
#
#func removepassiveeffect(passive):
#	passives[globals.effects[passive].trigger].erase(globals.effects[passive])

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
		#removepassiveeffect(i) 
		#NEED REPLACING
		pass
	#checkequipmenteffects()

func hitchance(target):
	var chance = hitrate - target.evasion
	if randf() <= chance/100.0:
		return true
	else:
		return false

func deal_damage(value, source):
	value *= damagemod
	value = round(value);
	if (shield > 0) and ((shieldtype & source) != 0):
		shield -= value
		if shield < 0:
			self.hp = hp + shield
			basic_check(variables.TR_DMG)
			shield = 0
		if shield == 0: basic_check(variables.TR_SHIELD_DOWN)
		pass
	else:
		self.hp = hp - value
		basic_check(variables.TR_DMG)
	pass

func heal(value):
	value = round(value);
	self.hp += value;
	basic_check(variables.TR_HEAL);
	pass

func death():
	#remove own area effects
	for e in own_area_effects:
		remove_area_effect(e)
		pass
	#trigger death triggers
	basic_check(variables.TR_DEATH)
	pass

func can_act():
	var res = true
	for e in static_effects:
		if Effectdata.effect_table[e].has('disable'): res = false
	for e in temp_effects:
		if Effectdata.effect_table[e.effect].has('disable'): res = false
	return res
	pass

func portrait():
	if icon != null:
		return images.portraits[icon]

func combat_portrait():
	if combaticon != null:
		return images.combatportraits[combaticon]

func portrait_circle():
	if combaticon != null:
		return images.circleportraits[combaticon]

func createtrait(data, type = 'starter'):
	var array = []
	for i in globals.traits.values():
		if i.type == type && (data.traits.has(i) == false):
			array.append([i.code, i.weight])
	return input_handler.weightedrandom(array)
