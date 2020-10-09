extends Reference
class_name combatant

var id
var name
var namebase
var base
var combatclass

var icon
var combaticon
var ai = null

var race
#i'm not sure if it is correct to allow this fields to be floats, but YOU INSIST ON NOT USING CUSTOM DESERIALIZING SO DICT2INST SETS THEM TO FLOATS AND ANY CONSEQ OPERATION FIRES COMPART ERROR
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
var resists = {} setget ,get_res
var status_resists = {} setget ,get_s_res
var shield = 0 setget set_shield;
#var shieldtype = variables.S_FULL setget set_shield_t;

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
var bonuses = {}

#ai
var taunt = null
var ai_spec setget ,get_spec_data


#out of combat regen stats
var regen_threshholds = {health = 0, mana = 0}
var regen_collected = {health = 0, mana = 0}

func fix_serialize(data):
	data.resists = resists.duplicate()

func get_stat(statname):
	var res = get(statname)
	if variables.bonuses_stat_list.has(statname):
		if bonuses.has(statname + '_add'): res += bonuses[statname + '_add']
		if bonuses.has(statname + '_mul'): res *= bonuses[statname + '_mul']
#	elif statname in ['physics','wits','charm','sexuals']:
#		res = get(statname) + get(statname+"_bonus")
	return res

func get_spec_data():
	if ai == null: return null
	return ai.get_spec_data()

func get_weapon_damagetype():
	var res = 'bludgeon' #or another type for unarmed attacks
	var wid = gear.rhand
	if wid != null:
		var tempw = state.items[wid]
		var t = tempw.get_damagetype()
		if t != null: res = t
	return res

func add_stat_bonuses(ls:Dictionary):
	if variables.new_stat_bonuses_syntax:
		for rec in ls:
			add_bonus(rec, ls[rec])
		recheck_effect_tag('recheck_stats')
	else:
		for rec in ls:
			if (rec as String).begins_with('resist') :
				add_bonus(rec + '_add', ls[rec])
				continue
			if (rec as String).ends_with('mod') && rec as String != 'critmod' :
				add_bonus(rec.replace('mod','_mul'), ls[rec])
				continue
			if get(rec) == null:
			#safe variant
			#add_bonus(rec, ls[rec])
				continue
			add_stat(rec, ls[rec])

func remove_stat_bonuses(ls:Dictionary):
	if variables.new_stat_bonuses_syntax:
		for rec in ls:
			add_bonus(rec, ls[rec], true)
		recheck_effect_tag('recheck_stats')
	else:
		for rec in ls:
			if (rec as String).begins_with('resist'):
				add_bonus(rec + '_add', ls[rec], true)
				continue
			if (rec as String).ends_with('mod') :
				add_bonus(rec.replace('mod','_mul'), ls[rec], true)
				continue
			if get(rec) == null: continue
			add_stat(rec, ls[rec], true)

func add_bonus(b_rec:String, value, revert = false):
	if value == 0: return
	if bonuses.has(b_rec):
		if revert:
			bonuses[b_rec] -= value
			if b_rec.ends_with('_add') and bonuses[b_rec] == 0.0: bonuses.erase(b_rec)
			if b_rec.ends_with('_mul') and bonuses[b_rec] == 1.0: bonuses.erase(b_rec)
		else: bonuses[b_rec] += value
	else:
		if revert: print('error bonus not found')
		else:
			#if b_rec.ends_with('_add'): bonuses[b_rec] = value
			if b_rec.ends_with('_mul'): bonuses[b_rec] = 1.0 + value
			else: bonuses[b_rec] = value
	

func add_stat(statname, value, revert = false):
	if variables.direct_access_stat_list.has(statname):
		if revert: set(statname, get(statname) - value)
		else: set(statname, get(statname) + value)
	else:
		add_bonus(statname+'_add', value, revert)
	recheck_effect_tag('recheck_stats')

func mul_stat(statname, value, revert = false):
	if variables.direct_access_stat_list.has(statname):
		if revert: set(statname, get(statname) / value)
		else: set(statname, get(statname) * value)
	else:
		if bonuses.has(statname + '_mul'):
			if revert:
				bonuses[statname + '_mul'] /= value
				if bonuses[statname + '_mul'] == 1:
					bonuses.erase(statname + '_mul')
			else: bonuses[statname + '_mul'] *= value
		else:
			if revert: print('error bonus not found')
			else: bonuses[statname + '_mul'] = value
	recheck_effect_tag('recheck_stats')

func add_part_stat(statname, value, revert = false):
	if variables.direct_access_stat_list.has(statname):
		if revert: set(statname, get(statname) / (1.0 + value))
		else: set(statname, get(statname) * (1.0 + value))
	else:
		add_bonus(statname+'_mul', value, revert)
	recheck_effect_tag('recheck_stats')

#confirmed getters
func get_res():
	var res = resists.duplicate()
	for r in variables.resistlist:
		if bonuses.has('resist' + r + '_add'): res[r] += bonuses['resist' + r + '_add']
		if bonuses.has('resist' + r + '_mul'): res[r] *= bonuses['resist' + r + '_mul']
	return res

func get_s_res():
	var res = status_resists.duplicate()
	for r in variables.status_list:
		if bonuses.has('resist' + r + '_add'): res[r] += bonuses['resist' + r + '_add']
		if bonuses.has('resist' + r + '_mul'): res[r] *= bonuses['resist' + r + '_mul']
	return res

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
#	if shield != 0: 
#		process_event(variables.TR_SHIELD_DOWN)
	if globals.combat_node != null and globals.combat_node.rules.has('no_shield'): 
		if value > shield: return
	shield = value;
	if displaynode != null:
		displaynode.update_shield()
	recheck_effect_tag('recheck_stats')

#func set_shield_t(value):
#	shieldtype = value;
#	if displaynode != null:
#		displaynode.update_shield()
#	recheck_effect_tag('recheck_stats')

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
#	var df = false
	if has_status('soulprot') or (hppercent > 99 and base == 'bomber'):
		hp = clamp(round(value), 1, hpmax())
	else:
#		if hp > 0 and value <= 0: df = true
		hp = clamp(round(value), 0, hpmax())
	if displaynode != null:
		displaynode.update_hp()
#	if df:
#	#trigger death triggers
#		process_event(variables.TR_DEATH)
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
	#hardcoded for rilu
	if value > alt_mana:
		if cooldowns.has('soul_prot') and process_check({type = 'gear_level', slot = 'lhand', level = 4, op = 'gte'}):
			var rnd = globals.rng.randf()
			if rnd < 0.25: 
				cooldowns['soul_prot'] -= 1
				if cooldowns['soul_prot'] == 0: cooldowns.erase('soul_prot') 
	alt_mana = clamp(round(value), 0, 5) 
#	if traits.keys().has('necro_trait') and traits['necro_trait']:
#		for e in find_eff_by_trait('necro_trait'):
#			var tmp = effects_pool.get_effect_by_id(e)
#			tmp.reapply()
#			if value <= 0:
#				for b in tmp.buffs:
#					b.set_limit(0)
#			else:
#				for b in tmp.buffs:
#					b.set_limit(1)
		

func armor_get():
	return max(0, armor)

func get_weapon_range():
	if gear.rhand == null:
		return 'melee'
	else:
		var weapon = state.items[gear.rhand]
		return weapon.weaponrange

#some AI-related functions
func need_heal(): #stub. borderlines are subject to tuning
	#if has_status('banish'): return -1.0
	var rate = hp * 1.0 / self.hpmax
	if rate < 0.2: return 1.0
	if rate < 0.4: return 0.5
	if rate < 0.6: return 0.0
	if rate < 0.8: return -0.5
	return -1.0

func fill_ai(data):#obsolete
	match variables.ai_setup:
		'off':
			ai.set_single_state({})
		'new':
			ai.set_single_state(data)
		'old':
			var newdata = {}
			for arr in data:
				newdata[arr[0]] = arr[1]
			ai.set_single_state(newdata)



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
		eff.set_args('trait', tmp.code)

func deactivate_trait(trait_code):
	if !traits.keys().has(trait_code): return
	if traits[trait_code] == false: return
	traits[trait_code] = false
	var tmp = Traitdata.traitlist[trait_code]
	traitpoints += tmp.cost
	for e in find_eff_by_trait(trait_code):
		var eff = effects_pool.get_effect_by_id(e)
		eff.remove()
	pass

func add_trait(trait_code):
	if !can_acq_trait(trait_code): return
	traits[trait_code] = false


func tick_cooldowns():
	var cooldowncleararray = []
	for k in cooldowns:
		cooldowns[k] -= 1
		if cooldowns[k] <= 0:
			cooldowncleararray.append(k)
	for k in cooldowncleararray:
		cooldowns.erase(k)

#func clear_oneshot():
#	for e in oneshot_effects:
#		remove_effect(e, 'once')
#	oneshot_effects.clear()
#	pass

func recheck_effect_tag(tg):
	var e_list = find_temp_effect_tag(tg)
	for e in e_list:
		var tmp = effects_pool.get_effect_by_id(e)
		tmp.recheck()



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
		'stat_set', 'stat_set_revert': #use this on direct-accessed stats
			template.buffer = get(template.stat)
			set(template.stat, template.value)
		'stat_add':
			add_stat(template.stat, template.value)
		'stat_mul':#do not mix add_p and mul for the sake of logic
			mul_stat(template.stat, template.value)
		'stat_add_p':
			add_part_stat(template.stat, template.value)
		'bonus': #reverting those effect can not clear no-bonus entries, so be careful not to overuse those
			if bonuses.has(template.bonusname): bonuses[template.bonusname] += template.value
			else: bonuses[template.bonusname] = template.value
		'signal':
			#stub for signal emitting
			globals.emit_signal(template.value)
		'remove_effect':
			remove_temp_effect_tag(template.value)
		'remove_all_effects':
			remove_all_effect_tag(template.value)
		'add_trait':
			add_trait(template.trait)
		'event':
			process_event(template.value)
		'resurrect':
			if !defeated: return
			self.hp = template.value
			defeated = false
			process_event(variables.TR_RES)
		'use_combat_skill':
			if globals.combat_node == null: return
#			globals.combat_node.use_skill(template.skill, self, position)
			globals.combat_node.q_skills.push_back({skill = template.skill, caster = self, target = position})
#		'add_counter':
#			if counters.size() <= template.index + 1:
#				counters.resize(template.index + 1)
#			if counters[template.index] == null:counters[template.index] = template.value
#			else:
#				counters[template.index] += template.value
		'add_skill':
			skills.push_back(template.skill)
		'remove_skill':
			skills.erase(template.skill)
			cooldowns.erase(template.skill)
		'sfx':
			play_sfx(template.value)
		'tick_cd':
			tick_cooldowns()
		'add_rule':
			if globals.combat_node == null: return
			if !globals.combat_node.rules.has(template.value): globals.combat_node.rules.push_back(template.value)
		'ai_call':
			if ai == null: return
			if ai.has_method(template.value): ai.call(template.value)


func remove_atomic(template):
	match template.type:
		'stat_set_revert':
			set(template.stat, template.buffer)
		'stat_add':
			add_stat(template.stat, template.value, true)
		'stat_mul':
			mul_stat(template.stat, template.value, true)
		'stat_add_p':
			add_part_stat(template.stat, template.value, true)
		'bonus':
			if bonuses.has(template.bonusname): bonuses[template.bonusname] -= template.value
			else: print('error bonus not found')
		'add_skill':
			skills.erase(template.skill)
			cooldowns.erase(template.skill)
		'remove_skill':
			skills.push_back(template.skill)
		'add_rule':
			if globals.combat_node == null: return
			globals.combat_node.rules.erase(template.value)

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
	for e in temp_effects + static_effects:
		var eff = effects_pool.get_effect_by_id(e)
		if eff.tags.has(eff_tag):
			res.push_back(e)
	return res

func find_eff_by_trait(trait_code):
	var res = []
	for e in (static_effects + own_area_effects + triggered_effects + temp_effects):
		var eff = effects_pool.get_effect_by_id(e)
		if eff.self_args.has('trait'):
			if eff.self_args.trait == trait_code:
				res.push_back(e)
	return res

func find_eff_by_item(item_id):
	var res = []
	for e in (static_effects + own_area_effects + triggered_effects + temp_effects):
		var eff = effects_pool.get_effect_by_id(e)
		if eff.self_args.has('item'):
			if eff.self_args.item == item_id:
				res.push_back(e)
	return res

func check_status_resist(eff):
	for s in variables.status_list:
		if !eff.tags.has(s): continue
		var res = get_stat('status_resists')[s]
		var roll = globals.rng.randi_range(0, 99)
		if roll < res: return true
	return false

func apply_temp_effect(eff_id):
	var eff = effects_pool.get_effect_by_id(eff_id)
	if check_status_resist(eff): 
		if globals.combat_node != null:
			globals.combat_node.combatlogadd("\n%s resists %s." % [get_stat('name'), eff.template.name]) 
			play_sfx('resist')
		return
	if globals.combat_node != null:
		globals.combat_node.combatlogadd("\n%s is afflicted by %s." % [get_stat('name'), eff.template.name]) 

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
	recheck_effect_tag('recheck_stats')
	
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
		'static', 'c_static', 'dynamic': 
			static_effects.push_back(eff_id)
			#obj.applied_pos = position
			obj.applied_char = id
			obj.apply()
		'trigger': 
			triggered_effects.push_back(eff_id)
			#obj.applied_pos = position
			obj.applied_char = id
			obj.apply()
		'temp_s','temp_p','temp_u': apply_temp_effect(eff_id)
		'area': add_area_effect(eff_id)
		'oneshot': 
			obj.applied_obj = self
			obj.apply()


func remove_effect(eff_id):
	var obj = effects_pool.get_effect_by_id(eff_id)
	match obj.template.type:
		'static', 'c_static': static_effects.erase(eff_id)
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

func remove_all_effect_tag(eff_tag):#function for nonn-direct temps removing, like heal or dispel
	var tmp = find_temp_effect_tag(eff_tag)
	for eff in tmp:
		remove_temp_effect(eff)

func clean_effects():#clean effects before deleting character
	for e in temp_effects + static_effects + triggered_effects + own_area_effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.remove()

func process_event(ev, skill = null):
	for e in temp_effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.process_event(ev)
	for e in triggered_effects:
		var eff:triggered_effect = effects_pool.get_effect_by_id(e)
		if skill != null and eff.req_skill:
			eff.set_args('skill', skill)
			eff.process_event(ev)
			eff.set_args('skill', null)
		else:
			eff.process_event(ev)

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
	id = 'h'+str(state.heroidcounter)
	state.heroidcounter += 1
	state.heroes[id] = self
	for i in variables.resistlist:
		resists[i] = 0
		if template.resists.has(i):
			resists[i] = template.resists[i]
	for i in ['damage','name','hitrate','evasion','armor','armorpenetration','mdef','speed','combaticon', 'aiposition', 'loottable', 'xpreward', 'bodyhitsound', 'flavor']:
		#self[i] = template[i]
		set(i, template[i])
	for i in variables.resistlist:
		resists[i] = 0
		if !template.has('resists'): continue
		if template.resists.has(i):
			resists[i] = template.resists[i]
	for i in variables.status_list:
		status_resists[i] = 0
		if !template.has('status_resists'): continue
		if template.status_resists.has(i):
			status_resists[i] = template.status_resists[i]
	if template.keys().has('traits'):
		for t in template.traits:
			traits[t] = false;
			activate_trait(t);
	if template.has('ai'):
		ai = template.ai
	else:
		ai = ai_base.new()
	ai.app_obj = self


func createfromclass(classid):
	var classtemplate = combatantdata.classlist[classid].duplicate()
	id = 'h'+str(state.heroidcounter)
	state.heroidcounter += 1
	state.heroes[id] = self
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
	id = 'h'+str(state.heroidcounter)
	state.heroidcounter += 1
	state.heroes[id] = self
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
	if classtemplate.keys().has('basetraits'):
		for i in classtemplate.basetraits:
			traits[i] = false
			activate_trait(i);
	for i in variables.resistlist:
		resists[i] = 0
		if !classtemplate.has('resists'): continue
		if classtemplate.resists.has(i):
			resists[i] = classtemplate.resists[i]
	for i in variables.status_list:
		status_resists[i] = 0
		if !classtemplate.has('status_resists'): continue
		if classtemplate.status_resists.has(i):
			status_resists[i] = classtemplate.status_resists[i]


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
	add_stat_bonuses(item.bonusstats)
	#for i in item.bonusstats:
		#self[i] += item.bonusstats[i]
		#set(i, get(i) + item.bonusstats[i])
	for i in item.effects:
		var tmp = Effectdata.effects[i].effects;
		for e in tmp:
			#apply_effect(e);
			var eff = effects_pool.e_createfromtemplate(e)
			apply_effect(effects_pool.add_effect(eff))
			eff.set_args('item', item.id)
		#addpassiveeffect(i)
		#NEED REPLACING
		pass
	#checkequipmenteffects()


func unequip(item):
	#removing links
	item.owner = null
	for i in gear:
		if gear[i] == item.id:
			gear[i] = null
	#removing bonuses
	remove_stat_bonuses(item.bonusstats)
#	for i in item.bonusstats:
		#self[i] -= item.bonusstats[i]
#		set(i, get(i) - item.bonusstats[i])
	
	for i in item.effects:
		var tmp = Effectdata.effects[i].effects;
		for e in find_eff_by_item(item.id):
			var eff = effects_pool.get_effect_by_id(e)
			eff.remove()
		pass


func hitchance(target):
	var chance = hitrate - target.evasion
	if randf() <= chance/100.0:
		return true
	else:
		return false

func deal_damage(value, source):
	var tmp = hp
	var res = get_stat('resists')
	value = round(value);
	value *= 1 - res['damage']/100.0
	if variables.resistlist.has(source): value *= 1 - res[source]/100.0
	if (shield > 0):
		self.shield -= value
		if shield < 0:
			self.hp = hp + shield
			process_event(variables.TR_DMG)
			self.shield = 0
		if shield == 0: process_event(variables.TR_SHIELD_DOWN)
	else:
		self.hp = hp - value
		process_event(variables.TR_DMG)
		recheck_effect_tag('recheck_damage')
	tmp = tmp - hp
	return tmp

func heal(value):
	if globals.combat_node != null and globals.combat_node.rules.has('no_heal'): return 0
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

func stat_update(stat, value):
	var tmp = get(stat)
	value = round(value)
	set(stat, value)
	if tmp != null: tmp = get(stat) - tmp
	else:  tmp = get(stat)
	recheck_effect_tag('recheck_stats')
	return tmp

func death():
	#remove own area effects
	for e in own_area_effects:
		remove_area_effect(e)

	defeated = true
	hp = 0
	if displaynode != null:
		displaynode.defeat()


func can_act():
	var res = true
	for e in static_effects + temp_effects:
		var obj = effects_pool.get_effect_by_id(e)
		if obj.template.has('disable'):
			res = false
	return res

func can_use_skill(skill):
	if mana < skill.manacost: return false
	if cooldowns.has(skill.code): return false
	if has_status('disarm') and skill.skilltype == 'skill' and !skill.tags.has('default'): return false
	if has_status('silence') and skill.skilltype == 'spell' and !skill.tags.has('default'): return false
	return true

func has_status(status):
	var res = false
	for e in static_effects + temp_effects + triggered_effects:
		var obj = effects_pool.get_effect_by_id(e)
		if obj.template.has(status):
			res = true
		if obj.tags.has(status):
			res = true
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

func calculate_number_from_string_array(arr):
	var array = arr.duplicate()
	var endvalue = 0
	var firstrun = true
	var singleop = ''
	for i in array:
		if typeof(i) == TYPE_ARRAY:
			i = str(calculate_number_from_string_array(i))
		if i in ['+','-','*','/']:
			singleop = i
			continue
		var modvalue = i
		if i.find('caster') >= 0 or i.find('self') >= 0:
			i = i.split('.')
			if i[0] == 'caster' or i[0] == 'self':
				#modvalue = str(self[i[1]])
				modvalue = str(get_stat(i[1]))
			elif i[0] == 'target':
				return ""; #nonexistent yet case of skill value being based completely on target
		if singleop != '':
			endvalue = input_handler.string_to_math(endvalue, singleop+modvalue)
			singleop = ''
			continue
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
	if typeof(check) == TYPE_ARRAY:
		var res = true
		for ch in check:
			res = res and input_handler.requirementcombatantcheck(ch, self)
		return res
	else: return input_handler.requirementcombatantcheck(check, self)
	pass

func gear_check(set, level, op):
#	var tmp = gear[slot]
	var tmp = gear.rhand
#	if  tmp == null: return false
#	var lv = state.items[tmp].get_set_level(set)
	#for test purpose
	var lv = 4
	match op:
		'eq': return lv == level
		'neq': return lv != level
		'gt': return lv > level
		'gte': return lv >= level
		'lt': return lv < level
		'lte': return lv <= level


func get_all_buffs():
	var res = {}
	for e in temp_effects + static_effects + triggered_effects:
		var eff = effects_pool.get_effect_by_id(e)
		#eff.calculate_args()
		for b in eff.buffs:
			b.calculate_args()
			if !res.has(b.template_name):
				if !(b.template.has('limit') and b.template.limit == 0):
					res[b.template_name] = []
					res[b.template_name].push_back(b)
			elif (!b.template.has('limit')) or (res[b.template_name].size() < b.template.limit):
				res[b.template_name].push_back(b)
	for e in area_effects:
		var eff:area_effect = effects_pool.get_effect_by_id(e)
		if !eff.is_applied_to_pos(position) :
			continue
		#eff.calculate_args()
		for b in eff.buffs:
			b.calculate_args()
			if !res.has(b.template_name):
				if !(b.template.has('limit') and b.template.limit == 0):
					res[b.template_name] = []
					res[b.template_name].push_back(b)
			elif (!b.template.has('limit')) or (res[b.template_name].size() < b.template.limit):
				res[b.template_name].push_back(b)
	var tmp = []
	for b_a in res.values():
		for b in b_a: tmp.push_back(b)
	return tmp

#this function is broken and needs revision (but for now skill tooltips are broken as well due to translation issues so i did't fix this)
func skill_tooltip_text(skillcode):
	var skill = Skillsdata.skilllist[skillcode]
	var text = ''
	if skill.description.find("%d") >= 0:
		text += skill.description % calculate_number_from_string_array(skill.value)
	else:
		text += skill.description
	return text

func play_sfx(code):
	if displaynode != null:
		displaynode.process_sfx(code)

func rebuildbuffs():
	if displaynode != null: displaynode.rebuildbuffs()
