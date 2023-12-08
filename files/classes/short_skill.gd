extends Reference
class_name S_Skill

var code
var template

var damagetype
var damagesrc
var damagestat
var is_drain = false
var skilltype
var tags
var value = []
var long_value = []
#var manacost
var userange
var targetpattern
var repeat

var chance
var evade
var caster
var target
var critchance
var hit_res

var effects = []
var process_value
var tempdur

var keep_target = variables.TARGET_KEEP
var next_target = variables.NT_MELEE

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
	var res = dict2inst(inst2dict(self).duplicate(true))
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
#	template = Skillsdata.skilllist[s_code].duplicate()
	template = Skillsdata.patch_skill(s_code, i_caster)
	code = s_code
	skilltype = template.skilltype
	tags = template.tags.duplicate()
#	manacost = template.manacost
	get_from_template('userange')
	get_from_template('targetpattern')
	get_from_template('damagetype')
	if typeof(damagetype) == TYPE_ARRAY:
		damagetype = input_handler.random_element(damagetype)
	get_from_template('keep_target')
	get_from_template('next_target')
	
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
#	if typeof(op2) == TYPE_STRING && check[1] != 'has':
#		op2 = get(op2)
	return input_handler.operate(check[1], op1, op2)
	pass

func setup_caster(c):
	caster = c
	chance = caster.get_stat('hitrate')
	critchance = caster.get_stat('critchance')

func setup_target(t):
	target = t
	if target == null: return#in all honesty, it shouldn't ever work, but it is still needed for zombie selfdestraction
	evade = target.get_stat('evasion')

func setup_final():
	if template.keys().has('chance'):
		chance = template.chance
	if template.keys().has('critchance'):
		critchance = template.critchance
	if template.keys().has('evade'):
		evade = template.evade
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
#	print("hit_roll by %s - %s" % [chance, evade])
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


func recalculate_effects():
	for e in effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.calculate_args()

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

#that's very much of a reckless patch for meta-skill TR_CAST event processing. Mind that it is not a replacement for resolve_value
#to get rid of this, need to do a major refactor of all this meta/applicable skill system
func prepare_process_value_on_meta():
	if !get_exception_type().empty() or target == null:
		return
	process_value = input_handler.calculate_number_from_string_array(long_value[0], caster, target)

func resolve_value(check_m):
	value.resize(long_value.size())
	for i in range(long_value.size()):
		var endvalue = input_handler.calculate_number_from_string_array(long_value[i], caster, target)
		if !(damagestat[i] in variables.dmg_mod_list): 
			value[i] = endvalue
			continue
		var rangetype
		if userange == 'weapon': userange = caster.get_weapon_range()
		if userange == 'melee' && input_handler.FindFighterRow(caster) == 'backrow' && !check_m:
			endvalue /= 2
		value[i] = endvalue
	process_value = value[0]
	recalculate_effects()
#	print("resolve_value for %s: %s" % [code, process_value])
#	print("target is %s" % target.name)
#	print(long_value)
#	print(value)

func calculate_dmg():
	if damagetype == 'weapon':
		damagetype = caster.get_weapon_damagetype()
	if hit_res == variables.RES_CRIT:
		for i in range(value.size()): 
			if damagestat[i] in variables.dmg_mod_list:
				value[i] *= caster.get_stat('critmod')
	for v in value: v = round(v)

#returns empty string for default skill processing
func get_exception_type() ->String:
	if damagetype is String and damagetype == 'summon':
		return 'summon'
	return ''
