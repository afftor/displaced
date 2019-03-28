extends Reference

var id
var name
var namebase
var base
var race

var icon
var combaticon

var level = 1
var recentlevelups = 0
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
var shield = 0 setget set_shield;
var shieldtype = variables.S_FULL setget set_shield_t;

var flavor

var image
var portrait
var combatportrait
var gear = {helm = null, chest = null, gloves = null, boots = null, rhand = null, lhand = null, neck = null, ring1 = null, ring2 = null}

var skills = ['attack']
var traits = {} #{'trait':'state'}
var traitpoints = 5

var inactiveskills = []
var cooldowns = []

var bodyhitsound = 'flesh' #for sound effect calculations

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
var combatgroup = 'ally'
var price = 0
var loottable
var selectedskill = 'attack'
#var effects = {}
#mods
var damagemod = 1
var hpmod = 1 setget hpmod_set
var manamod = 1
var xpmod = 1

var displaynode = null

var detoriatemod = 1
#ai
var ai
var aiposition
var aimemory
var taunt = null;

func set_shield(value):
	shield = value;
	if displaynode != null:
		displaynode.update_shield()
	pass

func set_shield_t(value):
	shieldtype = value;
	if displaynode != null:
		displaynode.update_shield()
	pass

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

func hpmod_set(value):
	hpmod = value;
	hpmax();
	set('hp', (hppercent * hpmax()) / 100)

func hp_set(value):
	hp = clamp(round(value), 0, hpmax())
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
	mana = clamp(round(value), 0, manamax())
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
	recentlevelups += 1
	
	var baseclass = combatantdata.classlist[base]
	for i in baseclass.learnableskills:
		if skills.has(i) == false && level >= baseclass.learnableskills[i]:
			skills.append(i)
	
	#add trait obtaining and other trait related stuff

func can_acq_trait(trait_code):
	if traits.keys().has(trait_code): return false
	var tmp = Traitdata.traitlist[trait_code]
	if tmp.req_class.has('all') or tmp.req_class.has(base): return true
	return false

func can_activate_trait(trait_code):
	if !traits.keys().has(trait_code):
		print("no trait")
		return false
	if traits[trait_code] == true:
		print('already active')
		return false
	var tmp = Traitdata.traitlist[trait_code]
	if traitpoints >= tmp.cost:
		return true
	else:
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
		'effect':
			apply_effect(tmp.effect)
		'temp_effect':
			apply_temp_effect(tmp.effect, tmp.duration, tmp.stack)
		'block_effect', 'delete_effect':
			remove_effect(tmp.effect, 'all')
		'damage':
			deal_damage(tmp.value, tmp.source)
		'buff':
			buffs.push_back(tmp.value)
		'timer':
			timers.push_back({effect = tmp.effect, delay = tmp.delay})

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
		'effect':
			remove_effect(tmp.effect, 'once')
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
	return {num = nm, index = res}


func apply_temp_effect(eff_code, duration = 1, stack = 1):
	var pos = find_temp_effect(eff_code)
	if pos.num < stack:
		temp_effects.push_back({effect = eff_code, time = duration})
		apply_effect(eff_code)
	else:
		temp_effects[pos.index].time = duration

func add_area_effect(eff_code):
	var effect = Effectdata.effect_table[eff_code]
	var area = []
	match effect.area:
		'back': if [1,2,3].has(position): area.push_back(position + 3)
		'line':
			if [1,2,3].has(position): area = [1,2,3]
			elif [4,5,6].has(position): area = [4,5,6]
			area.erase(position)
	#own_area_effects.push_back(effect.code)
	for pos in area:
		for h in state.heroes.values():
			h.add_ext_area_effect({effect = effect.value, position = pos})

func remove_area_effect(eff_code):
	var effect = Effectdata.effect_table[eff_code]
	var area = []
	match effect.area:
		'back': if [1,2,3].has(position): area.push_back(position + 3)
		'line':
			if [1,2,3].has(position): area = [1,2,3]
			elif [4,5,6].has(position): area = [4,5,6]
			area.erase(position)
	#own_area_effects.erase(effect.code)
	for pos in area:
		for h in state.heroes.values():
			h.remove_ext_area_effect({effect = effect.value, position = pos})

func add_ext_area_effect(dict):
	area_effects.push_back(dict)
	if dict.position == position: apply_effect(dict.effect)

func remove_ext_area_effect(dict):
	area_effects.erase(dict)
	if dict.position == position: remove_effect(dict.effect, 'once')

func set_position(new_pos):
	if new_pos == position: return
	#remove own area effects
	for e in own_area_effects:
		remove_area_effect(e)
	#remove ext area effects
	for e in area_effects:
		if e.position == position: remove_effect(e.effect)
	
	position = new_pos
	#reapply own area effects
	for e in own_area_effects:
		add_area_effect(e)
	#reapply ext area effects
	for e in area_effects:
		if e.position == position: apply_effect(e.effect)


func apply_effect(eff_code):
	var tmp = Effectdata.effect_table[eff_code]
	match tmp.type:
		'static':
			static_effects.push_back(eff_code)
			for ee in tmp.effects:
				apply_atomic(ee)
		'oneshot':
			#oneshot_effects.push_back(eff_code)
			for ee in tmp.effects:
				apply_atomic(ee)
		'trigger':
			triggered_effects.push_back(eff_code)
		'area':
			own_area_effects.push_back(eff_code)
			add_area_effect(eff_code)
			for ee in tmp.effects:
				apply_atomic(ee)

func remove_effect(eff_code, option = 'once'):
	for i in range(temp_effects.size()):
		if temp_effects[i].effect == eff_code:
			if option == 'all' or temp_effects[i].time <0:
				temp_effects.remove(i);
	var tmp = Effectdata.effect_table[eff_code]
	match tmp.type:
		'static':
			if option == 'once':
				static_effects.erase(eff_code)
				for ee in tmp.effects:
					remove_atomic(ee)
			else:
				while static_effects.has(eff_code):
					static_effects.erase(eff_code)
					for ee in tmp.effects:
						remove_atomic(ee)
#		'oneshot':
#			for ee in tmp.effects:
#				remove_atomic(ee)
#				pass
#			pass
		'trigger':
			if option == 'once':
				triggered_effects.erase(eff_code)
			else:
				while triggered_effects.has(eff_code):
					triggered_effects.erase(eff_code)
		'area':
			own_area_effects.erase(eff_code)
			remove_area_effect(eff_code)
			for ee in tmp.effects:
				remove_atomic(ee)


func update_temp_effects():
	for e in temp_effects:
		e.time -= 1
		if e.time < 0:
			remove_effect(e.effect)


func remove_all_temp_effects():
	for e in temp_effects:
		remove_effect(e.effect);

func update_timers():
	for e in timers:
		e.delay -= 1
		if e.delay < 0:
			apply_effect(e.effect)


func basic_check(trigger):
	#clear_oneshot()
	for e in triggered_effects:
		var tmp = Effectdata.effect_table[e]
		if tmp.trigger != trigger: continue
		#check conditions
		var res = true
		for cond in tmp.conditions:
			res = res and input_handler.requirementcombatantcheck(cond, self)
		if !res: return
		#apply effect
		for ee in tmp.effects: 
			apply_atomic(ee)
	#clear_oneshot()

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
						'tag':
							res = res and skill.tags.has(cond.value)
						'result': res = res and (skill.hit_res & cond.value != 0)
				'caster':
					res = res and input_handler.requirementcombatantcheck(cond.value, skill.caster)
				'target':
					res = res and input_handler.requirementcombatantcheck(cond.value, skill.target)
				'chance':
					res = res and (randf()*100 < cond.value)
		if !res: return
		#apply effect
		
		
		for ee in tmp.effects:
			var eee
			if typeof(ee) == TYPE_STRING: eee = Effectdata.atomic[ee].duplicate()
			else: 
				eee = ee.duplicate()
			var rec
			#convert effect to constant form
			if eee.type == 'skill':
				eee.type = eee.new_type
				eee.value = skill.get(eee.value) * eee.mul
			match eee.target:
				'caster':
					rec = skill.caster
				'target':
					rec = skill.target
				'skill':
					rec = skill
			rec.apply_atomic(eee)



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
	for i in ['damage','name','hitrate','evasion','armor','armorpenetration','mdef','speed','combaticon', 'aiposition', 'loottable', 'xpreward', 'bodyhitsound', 'flavor']:
		self[i] = template[i]
	if template.keys().has('traits'):
		for t in template.traits:
			traits[t] = false;
			activate_trait(t);


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
	if classtemplate.has('basetraits'):
		for i in classtemplate.basetraits:
			traits[i] = true
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
	hitrate = 85
	name = tr(nametemplate.name)
	namebase = nametemplate.name
	flavor = nametemplate.flavor


#func checkequipmenteffects():
#	pass
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
	if !item.geartype in combatantdata.classlist[base].gearsubtypes && !item.geartype in ['chest', 'helm','boots', 'gloves']:
		input_handler.SystemMessage(tr("INVALIDCLASS"))
		return
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
	#checkequipmenteffects()
#
#func addpassiveeffect(passive):
#	var effect = globals.effects[passive]
#	if !passives.has(effect.trigger):
#		passives[effect.trigger] = []
#	passives[effect.trigger].append(effect)
#
#func removepassiveeffect(passive):
#	passives[globals.effects[passive].trigger].erase(globals.effects[passive])

func unequip(item):#NEEDS REMAKING!!!!
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

	value = round(value);
	if (shield > 0) and ((shieldtype & source) != 0):
		self.shield -= value
		if shield < 0:
			self.hp = hp + shield
			basic_check(variables.TR_DMG)
			self.shield = 0
		if shield == 0: basic_check(variables.TR_SHIELD_DOWN)
	else:
		self.hp = hp - value
		basic_check(variables.TR_DMG)

func heal(value):
	value = round(value)
	self.hp += value
	basic_check(variables.TR_HEAL)

func death():
	#remove own area effects
	for e in own_area_effects:
		remove_area_effect(e)
	#trigger death triggers
	basic_check(variables.TR_DEATH)
	defeated = true
	hp = 0
	if displaynode != null:
		displaynode.defeat()
	

func can_act():
	var res = true
	for e in static_effects:
		if Effectdata.effect_table[e].has('disable'): res = false
	for e in temp_effects:
		if Effectdata.effect_table[e.effect].has('disable'): res = false
	return res

func portrait():
	if icon != null:
		return images.portraits[icon]

func combat_portrait():
	if combaticon != null:
		return images.combatportraits[combaticon]

func combat_full_portrait():
	if combaticon != null:
		return images.combatfullpictures[combaticon]

func portrait_circle():
	if combaticon != null:
		return images.circleportraits[combaticon]

func createtrait(data, type = 'starter'):
	var array = []
	for i in globals.traits.values():
		if i.type == type && (data.traits.has(i) == false):
			array.append([i.code, i.weight])
	return input_handler.weightedrandom(array)

func calculate_number_from_string_array(array):
	var endvalue = 0
	var firstrun = true
	for i in array:
		var modvalue = i
		if i.find('.') >= 0:
			i = i.split('.')
			if i[0] == 'caster':
				modvalue = str(self[i[1]])
			elif i[0] == 'target':
				return ""; #nonexistent yet case of skill value being based completely on target
		if !modvalue[0].is_valid_float():
			if modvalue[0] == '-' && firstrun == true:
				endvalue += float(modvalue)
			else:
				input_handler.string_to_math(endvalue, modvalue)
		else:
			endvalue += float(modvalue)
		firstrun = false
	return endvalue


func skill_tooltip_text(skillcode):
	var skill = globals.skills[skillcode]
	var text = '[center]' + skill.name + '[/center]\n'
	if skill.description.find("%d") >= 0:
		text += skill.description % calculate_number_from_string_array(skill.value)
	else:
		text += skill.description
	return text

func serialize():
	var tmp = {};
	var atr = ['name','level', 'baseexp', 'hpmax', 'hppercent', 'manamax', 'damage', 'hitrate', 'armor', 'armorpenetration', 'speed','critchance','critmod','resistfire','resistearth','resistwater','resistair','shield','shieldtype','traitpoints','price', 'damagemod', 'hpmod', 'manamod', 'xpmod', 'detoriatemod'];
	var atr1 = ['evasion', 'mdef', 'position', 'mana']
	var atr2 = ['skills', 'traits', 'buffs', 'static_effects','temp_effects','triggered_effects','oneshot_effects','area_effects','own_area_effects',]
	for a in atr:
		tmp[a] = get(a)
	for a in atr1:
		tmp[a] = get(a)
	for a in atr2:
		tmp[a] = get(a).duplicate()
	#return to_json(tmp)
	return tmp
	pass

func deserialize(tmp):
	#var tmp = parse_json(buff);
	var nametemplate = combatantdata.charlist[tmp.name]
	base = nametemplate.subclass;
	icon = nametemplate.icon
	combaticon = nametemplate.combaticon
	image = nametemplate.image
	name = nametemplate.name
	var atr = ['level', 'baseexp', 'hpmax', 'hppercent', 'manamax', 'damage', 'hitrate', 'armor', 'armorpenetration', 'speed','critchance','critmod','resistfire','resistearth','resistwater','resistair','shield','shieldtype','traitpoints','price', 'damagemod', 'hpmod', 'manamod', 'xpmod', 'detoriatemod'];
	var atr1 = ['evasion', 'mdef', 'position', 'mana']
	var atr2 = ['skills', 'traits', 'buffs', 'static_effects','temp_effects','triggered_effects','oneshot_effects','area_effects','own_area_effects',]
	for a in atr:
		self.set(a, tmp[a])
	evasion = tmp.evasion;
	mdef = tmp.mdef;
	position = tmp.position;
	mana =tmp.mana;
	for a in atr2:
		set(a, tmp[a].duplicate())
	pass
