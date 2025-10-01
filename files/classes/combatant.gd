extends Object
class_name combatant
#There are too much reference for combatants, I couldn't find all of them.
#For this reason we can't use Reference extension, as entities are not freed correctly.
#MIND(!), that with Object extension combatants are now must be freed manually,
#with the risk of breaking odd references. Keep open eye for such references, as thay should be fixed.

var id
var name
var base

var icon
var combaticon
var animations = {}#no getter from now on. Use get_animation() manually!
var anim_scale

var race

var level = 1

var hp = 0 setget hp_set#mind that setter works only though self.hp inside the class
var hpmax = 0 setget , hpmax_get #base value
var hp_growth
var defeated = false
#var mana = 0 setget mana_set
#var manamax = 0
var damage = 0 setget ,damage_get
var evasion = 0
var hitrate = 80
var critchance = 5
var critmod = 1.5
#Mind, that use of getters with dictionaries makes it dangerous for attempts to modify it from outside
var resists = {} setget ,get_resists#to modify resists from outside use set_resists()!
var status_resists = {} setget ,get_s_resists
var shield = 0 setget set_shield;
#var base_dmg_type = 'bludgeon'
var base_dmg_range = 'melee'
var is_boss :bool = false

var flavor

var skills = ['attack'] setget ,get_skills
var traits = []
var traitpoints := 0

var inactiveskills = [] #what is this for?
var cooldowns = {}

var bodyhitsound = ''#flesh - for sound effect calculations, but doesn't seems to be needed
var weaponsound = 'dodge'


#effects new part
var static_effects = []
var temp_effects = []
var triggered_effects = []
var aura_effects = []

var temporal_shields = {}

var position
var combatgroup = 'ally'
#var selectedskill = 'attack'

var acted = false
#mods. obsolete imho
#var damagemod = 1
#var hpmod = 1
#var manamod = 1
var xpmod = 1

var displaynode = null

#var detoriatemod = 1
var bonuses = {}

#ai
var taunt = null

func _init():
	animations = {}

func get_animation(key :String):
	if key == 'idle_1' and !animations.has('idle_1'):
		key = 'idle'
	if typeof(animations[key]) == TYPE_OBJECT:
		return animations[key]
	else:
		return resources.get_res(animations[key])


func get_weapon_sound():
	var res = weaponsound
	return "sound/%s" % res


func get_stat(statname):
	if statname == 'hp_p':
		return 100.0 * hp / hpmax_get()
	var res = get(statname)
	var combat = input_handler.combat_node
#	if !variables.direct_access_stat_list.has(statname):
	if variables.bonuses_stat_list.has(statname):
		if bonuses.has(statname + '_add'): res += bonuses[statname + '_add']
		if combat != null and combat.aura_bonuses[combatgroup].has(statname + '_add'): res += combat.aura_bonuses[combatgroup][statname + '_add']
		if bonuses.has(statname + '_mul'): res *= bonuses[statname + '_mul']
		if combat != null and combat.aura_bonuses[combatgroup].has(statname + '_mul'): res *= combat.aura_bonuses[combatgroup][statname + '_mul']
	return res


#seems not to be in use
#func add_stat_bonuses(ls:Dictionary):
#	if variables.new_stat_bonuses_syntax:
#		for rec in ls:
#			add_bonus(rec, ls[rec])
#		recheck_effect_tag('recheck_stats')
#	else:
#		for rec in ls:
#			if (rec as String).begins_with('resist') :
#				add_bonus(rec + '_add', ls[rec])
#				continue
#			if (rec as String).ends_with('mod') && rec as String != 'critmod' :
#				add_bonus(rec.replace('mod','_mul'), ls[rec])
#				continue
#			if get(rec) == null:
#			#safe variant
#			#add_bonus(rec, ls[rec])
#				continue
#			add_stat(rec, ls[rec])
#
#func remove_stat_bonuses(ls:Dictionary):
#	if variables.new_stat_bonuses_syntax:
#		for rec in ls:
#			add_bonus(rec, ls[rec], true)
#		recheck_effect_tag('recheck_stats')
#	else:
#		for rec in ls:
#			if (rec as String).begins_with('resist'):
#				add_bonus(rec + '_add', ls[rec], true)
#				continue
#			if (rec as String).ends_with('mod') :
#				add_bonus(rec.replace('mod','_mul'), ls[rec], true)
#				continue
#			if get(rec) == null: continue
#			add_stat(rec, ls[rec], true)

func add_bonus(b_rec:String, value, revert = false):
	#IMPORTANT TO UNDERSTAND:
	#entry in `bonuses` is a temporal deviation from normal stat. By itself it does not mean that
	#there is some effect on combatant. If one effect give +1, and another -1,
	#there will be no bonus, as there will be no deviation.
	#Mind it while working with `revert` flag!
	
	#classification
	var BTYPE = {ADD = 0, MUL = 1}
	var bonus_type :int = -1
	if b_rec.ends_with('_mul'):
		bonus_type = BTYPE.MUL
	elif b_rec.ends_with('_add'):
		bonus_type = BTYPE.ADD
	assert(bonus_type != -1, 'add_bonus got unexpected bonus type')
	
	#validation
	var statname :String = b_rec.trim_suffix("_add")
	statname = statname.trim_suffix("_mul")
	if statname.begins_with('resist'):
		assert((
			variables.resistlist.has(statname.trim_prefix('resist')) or
			variables.status_list.has(statname.trim_prefix('resist'))),
			"%s trying to edit unexisting resist by %s" % [name, b_rec])
	else:
		assert(get(statname) != null, "%s trying to edit unexisting stat by %s" % [name, b_rec])
	
	#bonus process
	if value == 0: return
	if bonuses.has(b_rec):
		if revert:
			if bonus_type == BTYPE.MUL: bonuses[b_rec] /= value
			else: bonuses[b_rec] -= value
		else:
			if bonus_type == BTYPE.MUL: bonuses[b_rec] *= value
			else: bonuses[b_rec] += value
		if bonus_type == BTYPE.ADD:
			if bonuses[b_rec] == 0.0: bonuses.erase(b_rec)
		elif bonuses[b_rec] == 1.0: bonuses.erase(b_rec)
	else:
		bonuses[b_rec] = value
	
	#hpmax change reaction
	if statname == 'hpmax':
		var new_hp
		if revert:
			if bonus_type == BTYPE.MUL: new_hp = hp / value
			else: new_hp = hp - value#ADD-type bonus hasn't been tested
		else:
			if bonus_type == BTYPE.MUL: new_hp = hp * value
			else: new_hp = hp + value
		if displaynode != null:
			displaynode.update_hp_bar_max()
		hp_set(new_hp)
	
	#keep it to test new add_bonus() till it's workability will be assured
#	if !bonuses.has(b_rec):
#		print("add_bonus %s removed by %s" % [b_rec, value])
#	else:
#		print("add_bonus %s by %s to %s" % [b_rec, value, bonuses[b_rec]])

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
		add_bonus(statname+'_mul', value, revert)
	recheck_effect_tag('recheck_stats')

func add_part_stat(statname, value, revert = false):
	#stat_add_p needed in cases, when math returns "+0.5" insted of "*1.5",
	#full refactoring is risky past the point of release, but bonuses are already
	#works only with "_mul" concept. So I'm make this patch, duplicating "_mul"
	#instead of old "_part" logic. Also because there was a bug with "_part"
	#modifier being added to "_mul" bonus container
	var mul_value = 1.0 + value
	mul_stat(statname, mul_value, revert)

func add_temporal_shield(value, temporal_id :String):
	if !temporal_shields.has(temporal_id):
		temporal_shields[temporal_id] = 0
	temporal_shields[temporal_id] += value
	add_stat('shield', value)

func remove_temporal_shield(temporal_id :String):
	if !temporal_shields.has(temporal_id): return
	
	add_stat('shield', temporal_shields[temporal_id], true)
	temporal_shields.erase(temporal_id)

#not in use, but could come handy
#func get_temporal_shield(temporal_id :String):
#	if !temporal_shields.has(temporal_id): return 0
#	return temporal_shields[temporal_id]

func wither_temporal_shields(value):
	for shield_id in temporal_shields.keys():
		temporal_shields[shield_id] -= value
		if temporal_shields[shield_id] < 0 :
			value = -temporal_shields[shield_id]
			temporal_shields.erase(shield_id)
		else:
			break

func clear_temporal_shields():
	temporal_shields.clear()

#confirmed getters
func calc_resist_mul_bonus(base :float, bonus :float) -> float:
	#base rasist < 0 is actualy debuff, yet mul_bonus > 1 must still increase resistance, and mul_bonus < 1 decrease it
	if base > 0.0:
		return base * bonus
	elif base < 0.0:
		return base / bonus
	return base

func set_resists(new_resists :Dictionary):#not making it a setter, as I don't cleary understand, how would it work, when you will try to set precise value in dictionary
	for i in variables.resistlist:
		if new_resists.has(i):
			resists[i] = new_resists[i]

func get_base_resists():#subject to overriding
	return resists.duplicate()

func get_resists():
	var res = get_base_resists()
	for r in variables.resistlist:
		if bonuses.has('resist' + r + '_add'): res[r] += bonuses['resist' + r + '_add']
		if bonuses.has('resist' + r + '_mul'):
			res[r] = calc_resist_mul_bonus(res[r], bonuses['resist' + r + '_mul'])
	return res

func get_s_resists():
	var res = status_resists.duplicate()
	for r in variables.status_list:
		if bonuses.has('resist' + r + '_add'): res[r] += bonuses['resist' + r + '_add']
		if bonuses.has('resist' + r + '_mul'):
			res[r] = calc_resist_mul_bonus(res[r], bonuses['resist' + r + '_mul'])
	return res

func set_shield(value):
#	if shield != 0:
#		process_event(variables.TR_SHIELD_DOWN)
	if input_handler.combat_node != null and input_handler.combat_node.rules.has('no_shield'):
		if value > shield: return
	if value == 0:
		clear_temporal_shields()
	elif value < shield:
		wither_temporal_shields(shield - value)
	shield = value;
	#that stuff not working. For now all shield representation made through buff-icons
	if displaynode != null:
		displaynode.update_shield()
	recheck_effect_tag('recheck_stats')

func hpmax_get():
	return get_hpmax_at_level(level)

func get_hpmax_at_level(lvl):
	var value = hpmax
	value += hp_growth * variables.curve[lvl - 1]
	return value

func get_damage_at_level(lvl):
	return damage * variables.curve[lvl - 1]

func damage_get():
	return get_damage_at_level(level)

func hp_set(value):
	if defeated: return
	var hp_max = get_stat('hpmax')
	if has_status('soulprot') or (hp == hp_max and base == 'bomber'):
		hp = clamp(round(value), 1, hp_max)
	else:
		hp = clamp(round(value), 0, hp_max)
	if displaynode != null:
		displaynode.update_hp()
	var possible_ai = get('ai')
	if possible_ai != null:
		possible_ai.check_stage()


func get_skills():
	return skills


#func mana_set(value):
#	mana = clamp(round(value), 0, get_stat('manamax'))
#	if displaynode != null:
#		displaynode.update_mana()

#some AI-related functions
func need_heal(): #stub. borderlines are subject to tuning
	#if has_status('banish'): return -1.0
	var rate = hp * 1.0 / self.hpmax
	if rate < 0.2: return 1.0
	if rate < 0.4: return 0.5
	if rate < 0.6: return 0.0
	if rate < 0.8: return -0.5
	return -1.0

#traits
func can_acq_trait(tr_id):
	if traits.has(tr_id):
		print("%s already has trait %s" % [name, tr_id])
		return false
	return true

func add_trait(trait_code):
	if !can_acq_trait(trait_code): return
	traits.push_back(trait_code)
	var tmp = Traitdata.traitlist[trait_code]
	for e in tmp.effects:
		var eff = effects_pool.e_createfromtemplate(Effectdata.effect_table[e])
		apply_effect(effects_pool.add_effect(eff))
		eff.set_args('trait', trait_code)

func remove_trait(trait_code):
	if !traits.has(trait_code): return
	traits.erase(trait_code)
	clear_trait_effects(trait_code)

func clear_traits():
	for code in traits:
		clear_trait_effects(code)
	traits.clear()

func clear_trait_effects(trait_code):
	var tmp = find_eff_by_trait(trait_code)
	for e in tmp:
		var eff = effects_pool.get_effect_by_id(e)
		eff.remove()



#skills
func tick_cooldowns():
	var cooldowncleararray = []
	for k in cooldowns:
		cooldowns[k] -= 1
		if cooldowns[k] <= 0:
			cooldowncleararray.append(k)
	for k in cooldowncleararray:
		cooldowns.erase(k)

#effects
func recheck_effect_tag(tg):
	var e_list = find_temp_effect_tag(tg)
	for e in e_list:
		var tmp = effects_pool.get_effect_by_id(e)
		tmp.recheck()

func apply_atomic(template):
	match template.type:
		'damage':
			var tmp = deal_damage(template.value, template.source)
			var combat = input_handler.combat_node
			combat.combatlogadd(combat.log_get_damage(tmp, name))
			if displaynode != null:
				var args = {critical = false, group = combatgroup}
				var data = {}
				args.type = template.source
				args.damage = tmp
				data = {node = displaynode, time = input_handler.combat_node.turns, type = 'damage_float', slot = 'damage', params = args.duplicate()}
				combat.CombatAnimations.add_new_data(data)
		'heal':
			heal(template.value)
			var combat = input_handler.combat_node
			combat.combatlogadd(combat.log_get_heal(template.value, name))
			if displaynode != null:
				var args = {critical = false, group = combatgroup}
				var data = {}
				args.heal = template.value
				data = {node = displaynode, time = input_handler.combat_node.turns, type = 'heal_float', slot = 'damage', params = args.duplicate()}
				combat.CombatAnimations.add_new_data(data)
#		'mana':
#			mana_update(template.value)
#			pass
		'stat_set', 'stat_set_revert': #use this on direct-accessed stats
			template.buffer = get(template.stat)
			set(template.stat, template.value)
		'stat_add':
			add_stat(template.stat, template.value)
		'stat_mul':#do not mix add_p and mul for the sake of logic (old comment, obsolete?)
			mul_stat(template.stat, template.value)
		'stat_add_p':
			add_part_stat(template.stat, template.value)
		'shield_add_temporal':
			add_temporal_shield(template.value, template.shield_id)
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
			var new_hp
			if template.has('value'):
				new_hp = template.value
			elif template.has('value_p'):
				new_hp = template.value_p * get_stat('hpmax')
			else: return
			resurrection(new_hp)
		'use_combat_skill':
			if input_handler.combat_node == null: return
			input_handler.combat_node.enqueue_skill(template.skill, self, position)
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
			if input_handler.combat_node == null: return
			if !input_handler.combat_node.rules.has(template.value):
				input_handler.combat_node.rules.push_back(template.value)
		'add_ultimeter':#only for hero. Maybe it's better to implement it in hero.gd
			if has_method('add_ultimeter'):
				call('add_ultimeter', template.value)


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
		'shield_add_temporal':
			remove_temporal_shield(template.shield_id)
		'bonus':
			if bonuses.has(template.bonusname): bonuses[template.bonusname] -= template.value
			else: print('error bonus not found')
		'add_skill':
			skills.erase(template.skill)
			cooldowns.erase(template.skill)
		'remove_skill':
			skills.push_back(template.skill)
		'add_rule':
			if input_handler.combat_node == null: return
			input_handler.combat_node.rules.erase(template.value)


func apply_aura_atomic(template):
	if input_handler.combat_node == null: return
	match template.type:
		'stat_add':
			input_handler.combat_node.add_bonus(combatgroup, template.stat + '_add', template.value)
#		'stat_mul':
#			input_handler.combat_node.add_bonus(combatgroup, template.stat + '_mul', template.value)
		'stat_add_p':
			input_handler.combat_node.add_bonus(combatgroup, template.stat + '_mul', template.value)
		'bonus':
			input_handler.combat_node.add_bonus(combatgroup, template.bonusname, template.value)


func remove_aura_atomic(template):
	if input_handler.combat_node == null: return
	match template.type:
		'stat_add':
			input_handler.combat_node.add_bonus(combatgroup, template.stat + '_add', template.value, true)
#		'stat_mul':
#			input_handler.combat_node.add_bonus(combatgroup, template.stat + '_mul', template.value, true)
		'stat_add_p':
			input_handler.combat_node.add_bonus(combatgroup, template.stat + '_mul', template.value, true)
		'bonus':
			input_handler.combat_node.add_bonus(combatgroup, template.bonusname, template.value, true)


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
	for e in (static_effects + triggered_effects + temp_effects):
		var eff = effects_pool.get_effect_by_id(e)
		if eff.self_args.has('trait'):
			if eff.self_args.trait == trait_code:
				res.push_back(e)
	return res

func find_eff_by_item(item_id):
	var res = []
	for e in (static_effects + triggered_effects + temp_effects):
		var eff = effects_pool.get_effect_by_id(e)
		if eff.self_args.has('item'):
			if eff.self_args.item == item_id:
				res.push_back(e)
	return res

func check_status_resist(eff):
	var all_res = get_stat('status_resists')
	var applicable_res = []
	for s in variables.status_list:
		if eff.tags.has(s): applicable_res.append(all_res[s])
	if applicable_res.empty():
		return false
	
	#all statuses are 'negative', but effects should be explicitly taged as such
	#so appending 'negative' resist here is just reassurance
	applicable_res.append(all_res['negative'])
	var res = applicable_res.max()
	var roll = globals.rng.randi_range(0, 99)
	return roll < res

func apply_temp_effect(eff_id):
	var eff = effects_pool.get_effect_by_id(eff_id)
	if check_status_resist(eff):
		if input_handler.combat_node != null and eff.has_screen_name():
			input_handler.combat_node.combatlogadd(tr("IS_RESISTS") % [get_stat('name'), eff.get_screen_name()])
			play_sfx('sfx_dispel')
		return
	if input_handler.combat_node != null and eff.has_screen_name():
		input_handler.combat_node.combatlogadd(tr("IS_AFFLICTED") % [get_stat('name'), eff.get_screen_name()])

	var eff_n = eff.template.name
	var tmp = find_temp_effect(eff_n)
	if (tmp.num < eff.template.stack) or (eff.template.stack == 0):
		temp_effects.push_back(eff_id)
		eff.applied_char = id
		eff.apply()
	else:
		var eff_a = effects_pool.get_effect_by_id(temp_effects[tmp.index])
		match eff_a.template.type:
			'temp_s':eff_a.reset_duration()
			'temp_p':eff_a.reset_duration() #i'm not sure if this case should exist or if it should be treated like this
			'temp_u':eff_a.upgrade() #i'm also not sure about this collision treatement, but for this i'm sure that upgradeable effects should have stack 1
		eff.remove()



func apply_effect(eff_id):
	var obj = effects_pool.get_effect_by_id(eff_id)
	match obj.template.type:
		'static', 'c_static', 'dynamic':
			static_effects.push_back(eff_id)
			obj.applied_char = id
			obj.apply()
		'trigger':
			triggered_effects.push_back(eff_id)
			obj.applied_char = id
			obj.apply()
		'temp_s','temp_p','temp_u': apply_temp_effect(eff_id)
		'oneshot':
			obj.applied_obj = self
			obj.apply()
		'aura':
			if input_handler.combat_node != null: 
				aura_effects.push_back(eff_id)
				input_handler.combat_node.aura_effects[combatgroup].push_back(eff_id)
				obj.applied_char = id
				obj.apply()


func remove_effect(eff_id):
	var obj = effects_pool.get_effect_by_id(eff_id)
	match obj.template.type:
		'static', 'c_static', 'dynamic': static_effects.erase(eff_id)
		'trigger': triggered_effects.erase(eff_id)
		'temp_s','temp_p','temp_u': temp_effects.erase(eff_id)
		'aura': 
			aura_effects.erase(eff_id)
			if input_handler.combat_node != null:
				input_handler.combat_node.aura_effects[combatgroup].erase(eff_id)


func remove_temp_effect(eff_id):#warning!! this mathod can remove effect that is not applied to character
	var eff = effects_pool.get_effect_by_id(eff_id)
	eff.remove()

#func remove_all_temp_effects():
#	for e in temp_effects:
#		var obj = effects_pool.get_effect_by_id(e)
#		obj.call_deferred('remove')

func remove_temp_effect_tag(eff_tag):#function for nonn-direct temps removing, like heal or dispel
	var tmp = find_temp_effect_tag(eff_tag)
	if tmp.size() == 0: return
	var i = globals.rng.randi_range(0, tmp.size()-1)
	remove_temp_effect(tmp[i])

func remove_all_effect_tag(eff_tag):#function for nonn-direct temps removing, like heal or dispel
	var tmp = find_temp_effect_tag(eff_tag)
	for eff in tmp:
		remove_temp_effect(eff)

func clean_effects():
	for e in temp_effects + static_effects + triggered_effects + aura_effects:
		var eff = effects_pool.get_effect_by_id(e)
		eff.remove()

func process_event(ev, skill = null):
	var effects_to_process = triggered_effects.duplicate()#effects can be removed from original array during cycle
#	print("%s process_event %s" % [name, String(effects_to_process)])
	for e in effects_to_process:
		var eff:triggered_effect = effects_pool.get_effect_by_id(e)
		if skill != null and eff.req_skill:
			eff.set_args('skill', skill)
			eff.process_event(ev)
			eff.set_args('skill', null)
		else:
			eff.process_event(ev)
	#ATTENTION! temp_effects has buff's calculate_args() inside process_event,
	#for now it's unobvious if it is effecting triggered_effects somehow.
	#If it is, temp_effects probably should be processed befor triggered_effects,
	#but than problem with temp_effects removeing it's triggered_effects will return
	effects_to_process = temp_effects.duplicate()
	for e in effects_to_process:
		var eff = effects_pool.get_effect_by_id(e)
		eff.process_event(ev)

func deal_damage(value, source):
	var out = {hp = 0, shield = 0, true_hp = 0}
	var res = get_stat('resists')
	value = round(value)
	value *= 1 - res['damage']/100.0
	if variables.resistlist.has(source): value *= 1 - res[source]/100.0
	var old_hp = hp
	if value < 0: 
		out.hp = -heal(-value)
		return out
	if (shield > 0) and (source != 'pure'):
		out.shield = value
		self.shield -= value
		if shield < 0:
			out.shield += shield
			self.hp = hp + shield
			out.hp = -shield
			process_event(variables.TR_DMG)
			self.shield = 0
		if shield == 0: process_event(variables.TR_SHIELD_DOWN)
	else:
		self.hp = hp - value
		out.hp = value
		process_event(variables.TR_DMG)
	recheck_effect_tag('recheck_damage')
	out.true_hp = out.hp
	if hp == 0: out.true_hp = old_hp
	return out

func heal(value):
	if input_handler.combat_node != null and input_handler.combat_node.rules.has('no_heal'): return 0
	var tmp = hp
	value = round(value)
	self.hp += value
	tmp = hp - tmp
	process_event(variables.TR_HEAL)
	return tmp

#func mana_update(value):
#	var tmp = mana
#	value = round(value)
#	self.mana += value
#	tmp = mana - tmp
#	#maybe better to rigger heal triggers on this
#	#process_event(variables.TR_HEAL)
#	return tmp

func stat_update(stat, value, precise = false):
	var tmp = get(stat)
	value = round(value)
	if tmp and !precise:
		set(stat, tmp + value)
	else:
		set(stat, value)
	if tmp != null: tmp = get(stat) - tmp
	else:  tmp = get(stat)
	recheck_effect_tag('recheck_stats')
	return tmp

func death():
	defeated = true
	hp = 0
	process_event(variables.TR_DEATH)
	if displaynode != null:
		displaynode.process_defeat()
		if !aura_effects.empty():
			input_handler.combat_node.recheck_auras()

func resurrection(new_hp = 1):
	if !defeated: return
	if input_handler.combat_node.rules.has('no_res'): return
	
	defeated = false
	self.hp = new_hp
	acted = false
	process_event(variables.TR_RES)
	if displaynode != null:
		displaynode.process_resurrect()
		displaynode.process_enable()#if acted = false
#		if !aura_effects.empty():
#			input_handler.combat_node.recheck_auras()

func can_act():
	var res = !acted
	for e in static_effects + temp_effects:
		var obj = effects_pool.get_effect_by_id(e)
		if obj.template.has('disable'):
			res = false
	return res

func can_use_skill(skill):
#	if mana < skill.manacost: return false
	if cooldowns.has(skill.code): return false
	if skill.tags.has('disabled'): return false
	if !process_check(skill.reqs): return false
	if has_status('silence') and skill.skilltype != 'item' and !skill.tags.has('default'): return false #possible to change in caase of combat item system
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

#2fix next functions due to errors
func sprite():
#	if icon != null:
	return resources.get_res(id)
	return null

func portrait():
	if icon != null:
		if resources.has_res(icon):
			return resources.get_res(icon)
		else:#for fullgame portrait unavailable in demo
			return resources.get_res(variables.portrait_dummy)

func combat_portrait():
	if combaticon != null:
		return resources.get_res(combaticon)

func combat_full_portrait():
	if combaticon != null:
		return resources.get_res(combaticon)

func portrait_circle():
	if combaticon != null:
		return resources.get_res(combaticon)

#func createtrait(data, type = 'starter'):
#	var array = []
#	for i in Traitdata.traitlist.values():
#		if i.type == type && (data.traits.has(i) == false):
#			array.append([i.code, i.weight])
#	return input_handler.weightedrandom(array)

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
			res = res and requirementcombatantcheck(ch)
		return res
	else: return requirementcombatantcheck(check)

func get_all_buffs():
	var res = {}
	for e in temp_effects + static_effects + triggered_effects:
		var eff = effects_pool.get_effect_by_id(e)
		#eff.calculate_args()
		if eff == null: continue
		for b in eff.buffs:
			b.calculate_args()
			b.amount = 1
			if !res.has(b.template_name):
				if !(b.template.has('limit') and b.template.limit == 0):
					res[b.template_name] = []
					res[b.template_name].push_back(b)
			elif b.template.has('limit'):
				if res[b.template_name].size() < b.template.limit:
					res[b.template_name].push_back(b)
				else:
					res[b.template_name].back().amount += 1
			else:
				res[b.template_name].push_back(b)
	if input_handler.combat_node != null:
		for e in input_handler.combat_node.aura_effects[combatgroup]:
			var eff = effects_pool.get_effect_by_id(e)
			if eff == null: continue
			#eff.calculate_args()
			for b in eff.buffs:
				b.amount = 1
				if !res.has(b.template_name):
					if !(b.template.has('limit') and b.template.limit == 0):
						res[b.template_name] = []
						res[b.template_name].push_back(b)
				elif b.template.has('limit'):
					if res[b.template_name].size() < b.template.limit:
						res[b.template_name].push_back(b)
					else:
						res[b.template_name].back().amount += 1
				else:
					res[b.template_name].push_back(b)
	var tmp = []
	for b_a in res.values():
		for b in b_a: tmp.push_back(b)
	return tmp

#this function is broken and needs revision (but for now skill tooltips are broken as well due to translation issues so i did't fix this)
#func skill_tooltip_text(skillcode):
#	var skill = Skillsdata.skilllist[skillcode]
#	var text = ''
#	if skill.description.find("%d") >= 0:
#		text += skill.description % calculate_number_from_string_array(skill.value)
#	else:
#		text += skill.description
#	return text

func play_sfx(code):
	if displaynode != null:
		displaynode.process_sfx(code)

func rebuildbuffs():
	if displaynode != null: displaynode.rebuildbuffs()

func requirementcombatantcheck(req):#Gear, Race, Types, Resists, stats
	if req.size() == 0:
		return true
	var result
	match req.type:
		'chance':
			result = (randf()*100 < req.value);
		'id':
			result = (id == req.value) == req.check
		'stats':
			result = input_handler.operate(req.operant, get_stat(req.stat), req.value)
		'race':
			result = (req.value == race);
		'status':
			result = has_status(req.status) == req.check
		'is_boss':
			result = is_boss == req.check
		'skill':
			if skills.has(req.skill):
				var skilldata = Skillsdata.patch_skill(req.skill, self)
				match req.check:
					'avail': result = can_use_skill(skilldata)
					'not_avail': result = !can_use_skill(skilldata)
					'disabled': result = skilldata.tags.has('disabled')
			else:
				result = false
	return result

func add_permanent_sfx(sfx_code):
	if !displaynode:
		return
	var sfx_obj = input_handler.gfx_sprite_permanent(displaynode, sfx_code)
	#we seems not in need of storing sfx_obj here. For now 'effect' do it
	return sfx_obj
