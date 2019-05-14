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
var casteffects
var userange
var targetpattern

var chance
var evade
var caster
var target
var critchance
var hit_res
var armor_p

var effects = []

func _init():
	caster = null
	target = null
	pass

func createfromskill(s_code):
	template = Skillsdata.skilllist[s_code]
	code = s_code
	damagetype = template.damagetype
	skilltype = template.skilltype
	tags = template.tags.duplicate()
	manacost = template.manacost
	targetpattern = template.targetpattern
	if typeof(template.value) == TYPE_ARRAY:
		long_value = template.value.duplicate()
		damagestat = template.damagestat.duplicate()
	else:
		long_value.push_back(template.value)
		if template.has('damagestat'):
			damagestat.push_back(template.damagestat)
		else:
			damagestat.push_back('hp')
	userange = template.userange
	casteffects = template.casteffects.duplicate()
	for e in template.effects:
		var eff = effects_pool.e_createfromtemplate(e)
		apply_effect(effects_pool.add_effect(eff))
	
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


func setup_caster(c):
	caster = c
	chance = caster.hitrate
	critchance = caster.critchance
	armor_p = caster.armorpenetration

func setup_target(t):
	target = t
	evade = target.evasion

func setup_final():
	if template.keys().has('chance'):
		chance = template.chance
	if template.keys().has('critchance'):
		critchance = template.critchance
	if template.keys().has('evade'):
		evade = template.evade
	if template.keys().has('armor_p'):
		armor_p = template['armor_p']

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

#old code
#func apply_effect(code, trigger):
#	var tmp = Effectdata.effect_table[code]
#	var rec
#	var res = true
#	if tmp.trigger != trigger: return
#	for cond in tmp.conditions:
#		match cond.target:
#			'skill':
#				match cond.check:
#					'type': res = res and (skilltype == cond.value)
#					'tag': res = res and tags.has(cond.value)
#					'result': res = res and (hit_res & cond.value != 0)
#			'caster':
#				res = res and input_handler.requirementcombatantcheck(cond.value, caster)
#			'target':
#				res = res and input_handler.requirementcombatantcheck(cond.value, target)
#			'chance':
#				res = res and (randf()*100 < cond.value)
#	if !res: return
#	for ee in tmp.effects:
#			var eee
#			if typeof(ee) == TYPE_STRING: eee = Effectdata.atomic[ee].duplicate()
#			else: eee = ee.duplicate()
#			#convert effect to constant form
#			if eee.type == 'skill':
#				eee.type = eee.new_type
#				eee.value = get(eee.value) * eee.mul
#			if eee.type == 'caster':
#				eee.type = eee.new_type
#				eee.value = caster.get(eee.value) * eee.mul
#			if eee.type == 'target':
#				eee.type = eee.new_type
#				eee.value = target.get(eee.value) * eee.mul
#
#			match eee.target:
#				'caster':
#					rec = caster
#				'target':
#					rec = target
#				'skill':
#					rec = self
#			rec.apply_atomic(eee)

func apply_effect(eff):
	var obj = effects_pool.get_effect_by_id(eff)
	match obj.template.type:
		'trigger':
			obj.set_args('skill', self)
			effects.push_back(obj.id)
			pass
		'oneshot':
			obj.applied_obj = self
			obj.apply()
			pass


func remove_effects():
	for eff in effects:
		eff.remove()
		pass

func process_event(ev):
	for e in effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.process_event(ev)
	pass

func resolve_value(check_m):
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
		pass
	pass

func calculate_dmg():
	if damagetype == 'weapon':
		damagesrc = variables.S_PHYS
	elif damagetype == 'fire':
		damagesrc = variables.S_FIRE
	elif damagetype == 'water':
		damagesrc = variables.S_WATER
	elif damagetype == 'air':
		damagesrc = variables.S_AIR
	elif damagetype == 'earth':
		damagesrc = variables.S_EARTH
	if hit_res == variables.RES_CRIT:
		for i in range(value.size()): 
			if damagestat[i] in variables.dmg_mod_list:
				value[i] *= caster.critmod
	var reduction = 0
	if skilltype == 'skill':
		reduction = max(0, target.armor - armor_p)
	elif skilltype == 'spell':
		reduction = max(0, target.mdef)
	if !tags.has('heal'):
		for i in range(value.size()): 
			if damagestat[i] in variables.dmg_mod_list:
				 value[i] *= (float(100 - reduction)/100)
	if damagetype in ['fire','water','air','earth']:
		for i in range(value.size()): 
			if damagestat[i] in variables.dmg_mod_list:
				 value[i] *= ((100 - target['resist' + damagetype])/100)
	for v in value: v = round(v)
