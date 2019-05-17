extends Reference
class_name combatant

var id
var name
var namebase
var base
var combatclass

var icon
var combaticon

var race

var level := 1
var recentlevelups := 0
var baseexp := 0 setget exp_set

var xpreward #for enemies

var hp = 0 setget hp_set
var hppercent = 100 setget hp_p_set
var hpmaxvalue = 0
var hpmax = 0 setget hp_max_set
var defeated = false
var mana = 0 setget mana_set
var manamax = 0
var alt_mana = 0 setget a_mana_set
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
var shieldtype := variables.S_FULL setget set_shield_t;

var flavor

var image
var portrait
var combatportrait
var gear = {helm = null, chest = null, gloves = null, boots = null, rhand = null, lhand = null, neck = null, ring1 = null, ring2 = null}

var skills = ['attack']
var traits = {} #{'trait':'state'}
var traitpoints := 0

var inactiveskills = []
var cooldowns = {}

var bodyhitsound = 'flesh' #for sound effect calculations

var buffs = {} #for display purpose ONLY, list of names 
#var passives = {skillhit = [], spellhit = [], anyhit = [], endturn = []} # combat passives
#var classpassives = {}

#effects new part
var static_effects = []
var temp_effects = []  
var triggered_effects = []
var area_effects = [] 
var own_area_effects = [] 


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
var taunt = null


#out of combat regen stats
var regen_threshholds = {health = 0, mana = 0}
var regen_collected = {health = 0, mana = 0}

func regen_tick(delta):
	
	for i in regen_collected:
		
		regen_collected[i] += delta
		
		if regen_collected[i] >= regen_threshholds[i]:
			regen_collected[i] -= regen_threshholds[i]
			match i:
				'health':
					self.hp += 1
				"mana":
					self.mana += 1

func regen_calculate_threshhold():
	regen_threshholds.health = variables.TimePerDay/max(hpmaxvalue,1)
	regen_threshholds.mana = variables.TimePerDay/max(manamax,1)

func set_shield(value):
	if shield != 0: 
		process_event(variables.TR_SHIELD_DOWN)
	shield = value;
	if displaynode != null:
		displaynode.update_shield()

func set_shield_t(value):
	shieldtype = value;
	if displaynode != null:
		displaynode.update_shield()

func damage_set(value):
	damage = value

func damage_get():
	return damage * damagemod

func hpmax():
	var value = ceil(hpmax*hpmod)
	hpmaxvalue = value
	regen_calculate_threshhold()
	return value

func manamax():
	regen_calculate_threshhold()
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
	if level >= variables.MaxLevel:
		baseexp = 100
	else:
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

func a_mana_set(value):
	alt_mana = value
	if traits.keys().has('necro_trait') and traits['necro_trait']:
		var tmp = find_temp_effect('necro_trait')
		tmp.set_args('count', value)
		pass

func armor_get():
	return max(0, armor)


func levelup():
	level += 1
	recentlevelups += 1
	traitpoints += variables.TraitPointsPerLevel
	
	var baseclass = combatantdata.classlist[combatclass]
	for i in baseclass.learnableskills:
		if skills.has(i) == false && level >= baseclass.learnableskills[i]:
			skills.append(i)
	

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
		var eff = effects_pool.e_createfromtemplate(Effectdata.effect_table[e])
		apply_effect(effects_pool.add_effect(eff))

func deactivate_trait(trait_code):
	if !traits.keys().has(trait_code): return
	if traits[trait_code] == false: return
	traits[trait_code] = false
	var tmp = Traitdata.traitlist[trait_code]
	traitpoints += tmp.cost
	for e in (static_effects + own_area_effects + triggered_effects):
		var eff = effects_pool.get_effect_by_id(e)
		if eff.template.has('trait_effect') && eff.template.trait_effect == trait_code:
			eff.call_deferred('remove')
	pass

func add_trait(trait_code):
	if !can_acq_trait(trait_code): return
	traits[trait_code] = false

#func clear_oneshot():
#	for e in oneshot_effects:
#		remove_effect(e, 'once')
#	oneshot_effects.clear()
#	pass

func apply_atomic(template): 
	match template.type:
		'damage':
			deal_damage(template.value, template.source)
			pass
		'heal':
			heal(template.value)
			pass
		'mana':
			mana_update(template.value)
			pass
		'stat_set', 'stat_set_revert':
			template.buffer = get(template.stat)
			set(template.stat, template.value)
			pass
		'stat_add':
			set(template.stat, get(template.stat) + template.value)
			pass
		'stat_mul':
			set(template.stat, get(template.stat) * template.value)
			pass
		'signal':
			#stub for signal emitting
			globals.emit_signal(template.value)
		'remove_effect': 
			remove_temp_effect_tag(template.value)
			pass


func remove_atomic(template):
	match template.type:
		'stat_set_revert':
			set(template.stat, template.buffer)
			pass
		'stat_add':
			set(template.stat, get(template.stat) - template.value)
			pass
		'stat_mul':
			set(template.stat, get(template.stat) / template.value)
			pass
	pass

func find_temp_effect(eff_code):
	var res = -1
	var tres = 9999999
	var nm = 0
	for i in range(temp_effects.size()):
		var eff = effects_pool.get_effect_by_id(temp_effects[i])
		if eff.template.name != eff_code:continue
		nm += 1
		if eff.remains < tres: 
			tres = eff.remains
			res = i
	return {num = nm, index = res}

func find_temp_effect_tag(eff_tag):
	var res = []
	for e in temp_effects:
		var eff = effects_pool.get_effect_by_id(e)
		if eff.tags.has(eff_tag):
			res.push_back(e)
		return res


func apply_temp_effect(eff_id):
	var eff = effects_pool.get_effect_by_id(eff_id)
	var eff_n = eff.template.name
	var tmp = find_temp_effect(eff_n)
	if (tmp.num < eff.template.stack) or (eff.template.stack == 0):
		temp_effects.push_back(eff_id)
		eff.applied_pos = position
		eff.applied_char = id
		eff.apply()
	else:
		var eff_a = effects_pool.get_effect_by_id(temp_effects[tmp.index])
		match eff_a.template.type:
			'temp_s':eff_a.reset_duration()
			'temp_p':eff_a.reset_duration() #i'm not sure if this case should exist or if it should be treated like this
			'temp_u':eff_a.upgrade() #i'm also not sure about this collision treatement, but for this i'm sure that upgradeable effects should have stack 1
		eff.remove()


func add_area_effect(eff_id):
	var eff = effects_pool.get_effect_by_id(eff_id)
	own_area_effects.push_back(eff_id)
	eff.apply()

func remove_area_effect(eff_id):
	own_area_effects.erase(eff_id)

func add_ext_area_effect(eff_id):
	if own_area_effects.has(eff_id): return
	area_effects.push_back(eff_id)

func remove_ext_area_effect(eff_id):
	if own_area_effects.has(eff_id): return
	area_effects.erase(eff_id)

func set_position(new_pos):
	if new_pos == position: return
	#remove ext area effects
	for e in area_effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.remove_pos(position)
	
	position = new_pos
	#reapply own area effects
	for e in own_area_effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.apply()
	#reapply ext area effects
	for e in area_effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.apply_pos(position)


func apply_effect(eff_id):
	var obj = effects_pool.get_effect_by_id(eff_id)
	match obj.template.type:
		'static': 
			static_effects.push_back(eff_id)
			obj.applied_pos = position
			obj.applied_char = id
			obj.apply()
		'trigger': 
			triggered_effect.push_back(eff_id)
			obj.applied_pos = position
			obj.applied_char = id
		'temp_s','temp_p','temp_u': apply_temp_effect(eff_id)
		'area': add_area_effect(eff_id)
		'oneshot': 
			obj.applied_obj = self
			obj.apply()


func remove_effect(eff_id):
	var obj = effects_pool.get_effect_by_id(eff_id)
	match obj.template.type:
		'static': static_effects.erase(eff_id)
		'trigger': triggered_effects.erase(eff_id)
		'temp_s','temp_p','temp_u': temp_effects.erase(eff_id)
		'area': remove_area_effect(eff_id)
	pass

func remove_temp_effect(eff_id):#warning!! this mathod can remove effect that is not applied to character
	var eff = effects_pool.get_effect_by_id(eff_id)
	eff.remove()
	pass

func remove_all_temp_effects():
	for e in temp_effects:
		var obj = effects_pool.get_effect_by_id(e)
		obj.call_deferred('remove')

func remove_temp_effect_tag(eff_tag):#function for nonn-direct temps removing, like heal or dispel
	var tmp = find_temp_effect_tag(eff_tag)
	if tmp.size() == 0: return
	var i = globals.rng.randi_range(0, tmp.size()-1)
	remove_temp_effect(tmp[i])
	pass

func process_event(ev):
	for e in temp_effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.process_event(ev)
	for e in triggered_effects:
		var eff:triggered_effect = effects_pool.get_effect_by_id(e)
		if eff.req_skill: continue
		var tr = eff.process_event(ev) #stub for more direct controling of temps removal
	pass

func createfromenemy(enemy):
	var template = Enemydata.enemylist[enemy].duplicate()
	base = enemy
	race = template.race
	hpmax = template.basehp
	self.hp = hpmax
	manamax = template.basemana
	speed = template.speed
	mana = manamax
	skills = template.skills
	for i in template.resists:
		#self['resist' + i] = template.resists[i]
		set('resist' + i, template.resists[i])
	for i in ['damage','name','hitrate','evasion','armor','armorpenetration','mdef','speed','combaticon', 'aiposition', 'loottable', 'xpreward', 'bodyhitsound', 'flavor']:
		#self[i] = template[i]
		set(i, template[i])
	if template.keys().has('traits'):
		for t in template.traits:
			traits[t] = false;
			activate_trait(t);


func createfromclass(classid):
	var classtemplate = combatantdata.classlist[classid].duplicate()
	id = 'h'+str(state.heroidcounter)
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
	if classtemplate.keys().has('basetraits'):
		for t in classtemplate.basetraits:
			traits[t] = false;
			activate_trait(t);
	

func createfromname(charname):
	var nametemplate = combatantdata.charlist[charname]
	var classid = nametemplate.subclass
	var classtemplate = combatantdata.classlist[classid].duplicate()
	if classtemplate.keys().has('basetraits'):
		for i in classtemplate.basetraits:
			traits[i] = false
			activate_trait(i);
	id = 'h'+str(state.heroidcounter)
	state.heroidcounter += 1
	base = nametemplate.code
	combatclass = classtemplate.code
	hpmax = classtemplate.basehp
	speed = classtemplate.speed
	self.hp = hpmax
	manamax = classtemplate.basemana
	mana = manamax
	skills = classtemplate.skills.duplicate()
	icon = nametemplate.icon
	combaticon = nametemplate.combaticon
	image = nametemplate.image
	damage = classtemplate.damage
	hitrate = 95
	name = tr(nametemplate.name)
	namebase = nametemplate.name
	flavor = nametemplate.flavor



func equip(item):
	if !item.geartype in combatantdata.classlist[combatclass].gearsubtypes && !item.geartype in ['chest', 'helm','boots', 'gloves']:
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
		#self[i] += item.bonusstats[i]
		set(i, get(i) + item.bonusstats[i])
	for i in item.effects:
		var tmp = Effectdata.effects[i].effects;
		for e in tmp:
			apply_effect(e);
		#addpassiveeffect(i)
		#NEED REPLACING
		pass
	#checkequipmenteffects()


func unequip(item):#NEEDS REMAKING!!!!
	#removing links
	item.owner = null
	for i in gear:
		if gear[i] == item.id:
			gear[i] = null
	#removing bonuses
	for i in item.bonusstats:
		#self[i] -= item.bonusstats[i]
		set(i, get(i) - item.bonusstats[i])
	
	for i in item.effects:
		var tmp = Effectdata.effects[i].effects;
		for e in tmp:
			remove_effect(e);
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
	var tmp = hp
	value = round(value);
	if (shield > 0) and ((shieldtype & source) != 0):
		self.shield -= value
		if shield < 0:
			self.hp = hp + shield
			process_event(variables.TR_DMG)
			self.shield = 0
		if shield == 0: process_event(variables.TR_SHIELD_DOWN)
	else:
		self.hp = hp - value
		process_event(variables.TR_DMG)
	tmp = tmp - hp
	return tmp

func heal(value):
	var tmp = hp
	value = round(value)
	self.hp += value
	tmp = hp - tmp
	process_event(variables.TR_HEAL)
	return tmp

func mana_update(value):
	var tmp = mana
	value = round(value)
	self.mana += value
	tmp = mana - tmp
	#maybe better to rigger heal triggers on this
	#process_event(variables.TR_HEAL)
	return tmp

func death():
	#remove own area effects
	for e in own_area_effects:
		remove_area_effect(e)
	#trigger death triggers
	process_event(variables.TR_DEATH)
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
	for i in Traitdata.traitlist.values():
		if i.type == type && (data.traits.has(i) == false):
			array.append([i.code, i.weight])
	return input_handler.weightedrandom(array)

func calculate_number_from_string_array(array):
	var endvalue = 0
	var firstrun = true
	for i in array:
		var modvalue = i
		if i.find('caster') >= 0:
			i = i.split('.')
			if i[0] == 'caster':
				#modvalue = str(self[i[1]])
				modvalue = str(get(i[1]))
			elif i[0] == 'target':
				return ""; #nonexistent yet case of skill value being based completely on target
		if !modvalue[0].is_valid_float():
			if modvalue[0] == '-' && firstrun == true:
				endvalue += float(modvalue)
			else:
				endvalue = input_handler.string_to_math(endvalue, modvalue)
		else:
			endvalue += float(modvalue)
		firstrun = false
	return endvalue

func process_check(check):
	return input_handler.requirementcombatantcheck(check, self)
	pass

func get_all_buffs():
	var res = {}
	for e in temp_effects + static_effects + area_effects + triggered_effects:
		var eff = effects_pool.get_effect_by_id(e)
		for b in eff.buffs:
			if !res.has(b.template_name):
				res[b.template_name] = []
				res[b.template_name].push_back(b)
			elif (!b.template.has('limit')) or (res[b.template_name].size() < b.template.limit):
				res[b.template_name].push_back(b)
	return res

func skill_tooltip_text(skillcode):
	var skill = Skillsdata.skilllist[skillcode]
	var text = ''
	if skill.description.find("%d") >= 0:
		text += skill.description % calculate_number_from_string_array(skill.value)
	else:
		text += skill.description
	return text

