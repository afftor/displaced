extends Reference
class_name S_Skill

var code
var template

var damagetype
var damagesrc
var damagestat = []
var is_drain = false
var skilltype
var tags
var value = []
var long_value = []
var manacost
var userange
var targetpattern
var repeat

var chance
var evade
var caster
var target
var critchance
var hit_res
var armor_p

var effects = []
var process_value
var tempdur

func _init():
	caster = null
	target = null
	userange = 'any'
	targetpattern = 'single'
	damagetype = 'direct'
	damagestat = '+damage_hp'
#	random_factor = 0
#	random_factor_p = 0.0

func clone():
	var res = dict2inst(inst2dict(self))
	res.effects.clear()
	for e in template.casteffects:
		var eff = effects_pool.e_createfromtemplate(e, res)
		res.apply_effect(effects_pool.add_effect(eff))
	return res

func get_from_template(attr, val_rel = false):
	if template.has(attr): 
		if typeof(template[attr]) == TYPE_ARRAY:
			set(attr, template[attr].duplicate())
			return
		set(attr, template[attr])
	if val_rel:
		var tres = []
		for i in range(long_value.size()): tres.push_back(get(attr))
		set(attr, tres)

func createfromskill(s_code, i_caster):
	template = Skillsdata.skilllist[s_code].dupliacte()
	code = s_code
	skilltype = template.skilltype
	tags = template.tags.duplicate()
	manacost = template.manacost
	get_from_template('userange')
	get_from_template('targetpattern')
	get_from_template('damagetype')
	if typeof(damagetype) == TYPE_ARRAY:
		damagetype = input_handler.random_element(damagetype)
	get_from_template('keep_target')
	
	if typeof(template.value) == TYPE_ARRAY: 
		if typeof(template.value[0]) == TYPE_ARRAY:
			long_value = template.value.duplicate()
		else:
			long_value.push_back(template.value.duplicate())
	else:
		long_value.push_back(template.value)
	
	get_from_template('damagestat', true)
	for s in range(damagestat.size()):
		if damagestat[s] == 'no_stat': continue
		if !(damagestat[s][0] in ['+','-','=']):
			damagestat[s] = '+'+damagestat[s]
	#get_from_template('receiver', true)
	#get_from_template('random_factor', true)
	#get_from_template('random_factor_p', true)
	
	for e in template.casteffects:
		var eff = effects_pool.e_createfromtemplate(e, self)
		apply_effect(effects_pool.add_effect(eff))
	if template.has('repeat'):
		repeat = template.repeat
	else:
		repeat = 1
	if template.has('is_drain'):
		is_drain = true
	
	setup_caster(i_caster)
#	if template.keys().has('chance'):
#		chance = template.chance
#	else:
#		chance = caster.hitrate
#	if template.keys().has('critchance'):
#		critchance = template.critchance
#	else:
#		critchance = caster.critchance
#	if template.keys().has('evade'):
#		evade = template.evade
#	else:
#		evade = target.evasion
#	if template.keys().has('armor_p'):
#		armor_p = template['armor_p']
#	else:
#		armor_p = caster.armorpenetration

func process_check(check:Array):
	var op1 = check[0]
	var op2 = check[2]
	if typeof(op1) == TYPE_STRING:
		op1 = get(op1)
	if typeof(op2) == TYPE_STRING && check[1] != 'has':
		op2 = get(op2)
	return input_handler.operate(check[1], op1, op2)
	pass

func setup_caster(c):
	caster = c
	chance = caster.get_stat('hitrate')
	critchance = caster.get_stat('critchance')
	armor_p = caster.get_stat('armorpenetration')

func setup_target(t):
	target = t
	evade = target.get_stat('evasion')

func setup_final():
	if template.keys().has('chance'):
		chance = template.chance
	if template.keys().has('critchance'):
		critchance = template.critchance
	if template.keys().has('evade'):
		evade = template.evade
	if template.keys().has('armor_p'):
		armor_p = template['armor_p']
	if template.has('custom_duration'):
		if typeof(template.custom_duration) == TYPE_ARRAY:
			tempdur = input_handler.calculate_number_from_string_array(template.custom_duration, caster, target)
		else: tempdur = template.custom_duration

func setup_effects_final():
	process_value = value[0]
	if template.has('custom_duration'):
		for e in effects:
			var eff = effects_pool.get_effect_by_id(e)
			eff.set_args('duration', tempdur)

func hit_roll():
	var prop = chance - evade
	if prop < randf()*100 && caster.combatgroup != target.combatgroup:
		hit_res = variables.RES_MISS
	elif critchance < randf()*100 || caster.combatgroup == target.combatgroup:
		hit_res = variables.RES_HIT
	else:
		hit_res = variables.RES_CRIT

func apply_atomic(tmp):
	match tmp.type:
		'stat_add':
			if tmp.stat == 'value':
				for i in range(value.size()): 
					if damagestat[i] in variables.dmg_mod_list:
						value[i] += tmp.value
				pass
			else: set(tmp.stat, get(tmp.stat) + tmp.value)
		'stat_mul':
			if tmp.stat == 'value':
				for i in range(value.size()): 
					if damagestat[i] in variables.dmg_mod_list:
						value[i] *= tmp.value
				pass
			else: set(tmp.stat, get(tmp.stat) * tmp.value)
		'stat_set':
			if tmp.stat == 'value':
				for i in range(value.size()): 
					if damagestat[i] in variables.dmg_mod_list:
						value[i] = tmp.value
				pass
			else: set(tmp.stat, tmp.value)
		'add_tag':
			tags.push_back(tmp.value)

func apply_effect(eff):
	var obj = effects_pool.get_effect_by_id(eff)
	match obj.template.type:
		'trigger':
			obj.set_args('skill', self)
			effects.push_back(obj.id)
			obj.apply()
			pass
		'oneshot':
			obj.applied_obj = self
			obj.apply()
			pass


func remove_effects():
	for e in effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.remove()
		pass

func process_event(ev):
	for e in effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.set_args('skill', self)
		eff.process_event(ev)


func resolve_value(check_m):
	value.resize(long_value.size())
	for i in range(long_value.size()):
		var endvalue = input_handler.calculate_number_from_string_array(long_value[i], caster, target)
		if !(damagestat[i] in variables.dmg_mod_list): 
			value[i] = endvalue
			continue
		var rangetype
		if userange == 'weapon':
			if caster.gear.rhand == null:
				rangetype = 'melee'
			else:
				var weapon = state.items[caster.gear.rhand]
				rangetype = weapon.weaponrange
		if rangetype == 'melee' && input_handler.FindFighterRow(caster) == 'backrow' && !check_m:
			endvalue /= 2
		value[i] = endvalue
	process_value = value[0]

func calculate_dmg():
	if damagetype == 'weapon':
		damagetype = caster.get_weapon_damagetype()
#	if typeof(damagetype) == TYPE_ARRAY:
#		damagetype = input_handler.random_element(damagetype)
#
#		damagesrc = variables.S_PHYS
#	elif damagetype == 'fire':
#		damagesrc = variables.S_FIRE
#	elif damagetype == 'water':
#		damagesrc = variables.S_WATER
#	elif damagetype == 'air':
#		damagesrc = variables.S_AIR
#	elif damagetype == 'earth':
#		damagesrc = variables.S_EARTH
	if hit_res == variables.RES_CRIT:
		for i in range(value.size()): 
			if damagestat[i] in variables.dmg_mod_list:
				value[i] *= caster.get_stat('critmod')
	var reduction = 0
	if skilltype == 'skill':
		reduction = max(0, target.armor - armor_p)
	elif skilltype == 'spell':
		reduction = max(0, target.mdef)
	if !tags.has('noreduce'):#tag for all reduction-ignoring skills i.e heals and others
		for i in range(value.size()): 
			if damagestat[i] in variables.dmg_mod_list:
				 value[i] *= (float(100 - reduction)/100.0)
#	if damagetype in variables.resistlist:
#		for i in range(value.size()): 
#			if damagestat[i] in variables.dmg_mod_list:
#				 value[i] *= ((100 - target.get_stat('resists')[damagetype])/100.0)
	for v in value: v = round(v)
