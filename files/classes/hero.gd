extends combatant
class_name hero

var unlocked = false setget set_unlocked
var friend_points = 0.0
var friend_points_new = 0.0

var recentlevelups = 0
var baseexp = 0 setget exp_set
var exp_cap = 100 setget ,get_exp_cap

var alt_mana = 0 setget a_mana_set

var got_turn = false#flag for single process of TR_TURN_GET
var gear_level = {weapon1 = 0, weapon2 = 0, armor = 1}
var curweapon = 'weapon1'
var base_dmg_type = 'bludgeon' setget , get_weapon_damagetype
var armorbase = {}
var armorbonus = {}
var ultimeter :int = 0
var ult_min_lvl :int = 0

var bonusres = []

func _init():
	combatgroup = 'ally'

func set_unlocked(value):
	unlocked = value
	if !value:
		position = null
		input_handler.emit_signal("PositionChanged")


func createfromname(name):
	var template = combatantdata.charlist[name]
	base = template.code
	self.name = tr(template.name)
	for key in ['hpmax', 'hp_growth', 'evasion', 'hitrate', 'race', 'bonusres', 'armorbase', 'armorbonus', 'unlocked', 'icon','combaticon', 'bodyhitsound', 'flavor', 'damage']:
		if template.has(key): set(key, template[key])
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
	animations = template.animations.duplicate()
	hp = get_stat('hpmax')
	for skill_id in template.skilllist:
		var skill_lvl = template.skilllist[skill_id]
		var skill = Skillsdata.patch_skill(skill_id, self)
		if (skill.skilltype == 'ultimate'
				and (ult_min_lvl == 0 or ult_min_lvl > skill_lvl)):
			ult_min_lvl = skill_lvl

func activate_traits():
	var template = combatantdata.charlist[base]
	if template.keys().has('traits'):
		for t in template.traits:
			add_trait(t);

#seems not in use (and not working)
#out of combat regen stats
#var regen_collected = 0
#func regen_tick(delta):
#	var regen_thresholds = regen_calculate_threshold()
#	regen_collected += delta
#	if regen_collected >= regen_thresholds:
#		regen_collected -= regen_thresholds
#		self.hp += 1
#func regen_calculate_threshold():
#	return variables.TimePerDay/max(get_stat('hpmax'),1)


func exp_set(value):
	if level >= variables.MaxLevel:
		baseexp = get_exp_cap()
	else:
		baseexp = value
		while baseexp > get_exp_cap():
			baseexp -= get_exp_cap()
			levelup()


func get_exp_cap():
	return int(100 * variables.exp_curve[level - 1])

func a_mana_set(value):
	pass

func levelup():
	level += 1
	recentlevelups += 1
#	var template = combatantdata.charlist[id]
#	for id in template.skills:
#		if template.skills[id] == level:
#			skills.push_back(id)

func get_skills():
	var res = []
	var template = combatantdata.charlist[id]
	for id in template.skilllist:
		if template.skilllist[id] <= level:
			res.push_back(id)
	return res


func see_enemy_killed():
	#stub
	if base == 'arron':
		for ch in state.characters:
			var girl = state.heroes[ch]
			if ch != 'arron' and girl.unlocked:
				girl.add_friend_points(0.3)
	else:
		add_friend_points(1)

func add_friend_points(value):
	friend_points += value
	friend_points_new += value

func clear_new_friend_points():
	friend_points_new = 0.0

##cheat
#func unlock_all_skills():
#	var template = combatantdata.charlist[id]
#	for s in template.skilllist:
#		if !skills.has(s):
#			skills.push_back(s)



func set_weapon(slot):
	if (slot == "armor"
			or (slot == "weapon2" and gear_level[slot] == 0)):
		return
		#weapon1 with level 0 still can be equipped
	curweapon = slot


func gear_check(slot, level, op):
	var lv = gear_level[slot]
	if slot != 'armor' and slot != curweapon:
		return false
	if lv == 0:#for armed weapon with level 0 (armor can't be level 0)
		return false
	match op:
		'eq': return lv == level
		'neq': return lv != level
		'gt': return lv > level
		'gte': return lv >= level
		'lt': return lv < level
		'lte': return lv <= level

func upgrade_gear(slot):
	if gear_level[slot] >= 4: return false
	gear_level[slot] += 1
	return true

func set_gear(slot :String, lvl :int):
	if lvl > 4 or lvl < 0: return
	if lvl == 0 and slot == 'armor': return
	gear_level[slot] = lvl

func get_item_data_level(slot, level):
	var res = {icon = null, name = null, description = null, colors = [], type = slot, cost = {}, level = level}
	var template = Items.hero_items_data["%s_%s" % [id, slot]]
	res.icon = template.leveldata[level].icon
	if typeof(res.icon) == TYPE_STRING:
		res.icon = load(res.icon)
	res.name = tr(template.name)
	if slot == 'armor':
		res.description = form_armor_lvl_desc(level)
	else:#weapon
		res.description = Items.form_weapon_lvl_desc(template.leveldata[level].lvldesc)
	res.cost = template.leveldata[level].cost.duplicate()
	return res

func get_item_data(slot):
	return get_item_data_level(slot, gear_level[slot])

func get_item_upgrade_data(slot):
	if gear_level[slot] >= 4: return null
	return get_item_data_level(slot, gear_level[slot] + 1)


func get_weapon_damagetype():
	var res = base_dmg_type
	var template = Items.hero_items_data["%s_%s" % [id, curweapon]]
	if template != null:
		res = template.damagetype
	return res

func get_weapon_range():
	var res = base_dmg_range
	var template = Items.hero_items_data["%s_%s" % [id, curweapon]]
	if template != null:
		res = template.weaponrange
	return res

func get_weapon_sound():
	var res = weaponsound
	var template = Items.hero_items_data["%s_%s" % [id, curweapon]]
	if template != null:
		res = template.weaponsound
	return "sound/%s" % res


#this function is broken and needs revision (but for now skill tooltips are broken as well due to translation issues so i didn't fix this)
#still need fixing
#func skill_tooltip_text(skillcode):
#	var skill = Skillsdata.skilllist[skillcode]
#	var text = ''
#	if skill.description.find("%d") >= 0:
#		text += skill.description % calculate_number_from_string_array(skill.value)
#	else:
#		text += skill.description
#	return text


func requirementcombatantcheck(req):#Gear, Race, Types, Resists, stats
	if req.size() == 0:
		return true
	var result
	match req.type:
		'gear_level':
			result = gear_check(req.slot, req.level, req.op)
		_:
			result = .requirementcombatantcheck(req)

	return result

func serialize():
	var tmp = {}
	tmp.unlocked = unlocked
	tmp.baseexp = baseexp
	tmp.recentlevelups = recentlevelups
	tmp.level = level
	tmp.curweapon = curweapon
	tmp.gear_level = gear_level.duplicate()
	tmp.skills = skills.duplicate()
	tmp.hp = hp
#	tmp.mana = mana
#	tmp.defeated = defeated
	tmp.position = position
	tmp.bonuses = bonuses.duplicate()
	tmp.fr_p = friend_points
	tmp.ultimeter = ultimeter
	if !static_effects.empty():
		print("ERROR on save %s! There are %s static_effects active" % [name, static_effects.size()])
	if !triggered_effects.empty():
		print("ERROR on save %s! There are %s triggered_effects active" % [name, triggered_effects.size()])
	if !temp_effects.empty():
		print("ERROR on save %s! There are %s temp_effects active" % [name, temp_effects.size()])
	#delete, if new dynamic traits system works
#	tmp.static_effects = static_effects.duplicate()
#	tmp.temp_effects = temp_effects.duplicate()
#	tmp.triggered_effects = triggered_effects.duplicate()
#	tmp.traits = traits.duplicate()
	return tmp

func deserialize(savedir):
#	id = savedir.id
	createfromname(id)
	unlocked = savedir.unlocked
	baseexp = savedir.baseexp
	recentlevelups = savedir.recentlevelups
	level = savedir.level
	curweapon = savedir.curweapon
	gear_level = savedir.gear_level.duplicate()
	skills = savedir.skills.duplicate()
	hp = savedir.hp
#	mana = savedir.mana
#	defeated = savedir.defeated
	if savedir.position != null:
		position = int(savedir.position)
	else:
		position = null
#	if position != null: state.combatparty[position] = id
	bonuses = savedir.bonuses.duplicate()
	for slot in gear_level:
		gear_level[slot] = int(gear_level[slot])
	friend_points = floor(float(savedir.fr_p) * 10) * 0.1
	ultimeter = int(savedir.ultimeter)
	#delete, if new dynamic traits system works
#	static_effects = savedir.static_effects.duplicate()
#	temp_effects = savedir.temp_effects.duplicate()
#	triggered_effects = savedir.triggered_effects.duplicate()
#	for eff in static_effects.duplicate():
#		var tmp = effects_pool.get_effect_by_id(eff)
#		if tmp == null: 
#			static_effects.erase(eff)
#			continue
#		tmp.applied_char = id
#		tmp.calculate_args() 
#	for eff in temp_effects.duplicate():
#		var tmp = effects_pool.get_effect_by_id(eff)
#		if tmp == null: 
#			temp_effects.erase(eff)
#			continue
#		tmp.applied_char = id
#		tmp.calculate_args() 
#	for eff in triggered_effects.duplicate():
#		var tmp = effects_pool.get_effect_by_id(eff)
#		if tmp == null: 
#			triggered_effects.erase(eff)
#			continue
#		tmp.applied_char = id
#		tmp.calculate_args() 
	#most of the stuff is just fix for savegame traits compatibility. In regular cases only savedir.traits import is relevant
#	if savedir.has('traits'):
#		traits = savedir.traits.duplicate()
#	else:
#		traits = []
#	var template = combatantdata.charlist[base]
#	if template.keys().has('traits'):
#		for trait in template.traits:
#			if !(trait in traits):
#				clear_trait_effects(trait)
#				add_trait(trait)


var skills_autoselect = ["attack"]
func get_autoselected_skill():
	var skilldata = Skillsdata.patch_skill( skills_autoselect.back(), self)
	while !can_use_skill(skilldata) or skilldata.skilltype == 'item':
		skills_autoselect.pop_back()
		skilldata = Skillsdata.patch_skill( skills_autoselect.back(), self)
	return skills_autoselect.back()

func unlock_resists() ->Array:#return only new unlocked resists
	var active_resists = {}
	var skill_list = get_skills()
	var used_weapon
	for i in range(2):
		if i == 1:
			if gear_level['weapon2'] == 0:
				break
			#the thig is, we switch weapon, if possible, to let skills patch themselves with both weapons
			#but it still could be a bad idea, as this is not true weapon switching event,
			#and rest of the game could behave itself unexpectedly
			used_weapon = curweapon
			if curweapon == 'weapon1': set_weapon('weapon2')
			else: set_weapon('weapon1')
		
		active_resists[get_weapon_damagetype()] = true
		
		for skill_id in skill_list:
			var resists_applicable = Skillsdata.get_resists_applicable(skill_id, id)
			for new_resist in resists_applicable:
				active_resists[new_resist] = true
		
		if i == 1:
			curweapon = used_weapon
	
	var unlocked = []
	for resist in active_resists:
		if state.try_unlock_resist(resist):
			unlocked.append(resist)
	return unlocked

func get_base_resists():
	var res = resists.duplicate()
	for r in variables.resistlist:
		if r in bonusres:
			res[r] = armorbonus[gear_level.armor]
		else:
			res[r] = armorbase[gear_level.armor]
	return res

func form_armor_lvl_desc(lvl :int) -> String:
	var bonus_list = ''
	var bonus_unlocked = []
	for res in bonusres:
		if state.is_resist_unlocked(res):
			bonus_unlocked.append(res)
	for i in range(bonus_unlocked.size()):
		if i == 0:
			pass
		elif i == bonus_unlocked.size()-1:
			bonus_list += " and "
		else:
			bonus_list += ", "
		bonus_list += tr(variables.get_resist_data(bonus_unlocked[i]).name)
	
	return tr("ARMOR_EFFECT") % [armorbase[lvl],
		armorbonus[lvl],
		bonus_list
	]

func try_rest():
	if defeated or position != null:
		return
	heal(get_stat('hpmax') * 0.25)

func can_use_skill(skill):
	if !.can_use_skill(skill): return false
	if skill.skilltype == 'ultimate':
		return is_ult_ready()
	return true

func has_ult() ->bool:
	return level >= ult_min_lvl

func add_ultimeter(value :int):
#	print("%s add_ultimeter %d" % [name, value])
	set_ultimeter(ultimeter + value)

func deplete_ultimeter():
	set_ultimeter(0)

func set_ultimeter(value :int):
	if !has_ult(): return
	ultimeter = value
	if ultimeter > 100: ultimeter = 100
	elif ultimeter < 0: ultimeter = 0
	if displaynode != null:
		displaynode.update_ultimeter()

func get_ultimeter() ->int:
	return ultimeter

func is_ult_ready() ->bool:
	return ultimeter == 100

func process_ultimeter(ev, skill = null):#skill :S_Skill
	if !has_ult(): return
	var do_add = variables.ULTIMETER_COSTS.has(ev)
	if ev == variables.TR_POST_TARG:#S_Skill here is applicable-type
		do_add = (skill.process_check(['tags', 'has', 'damage'])
			and skill.process_check(['hit_res', 'mask', variables.RES_HITCRIT]))
	elif ev == variables.TR_SKILL_FINISH:#S_Skill here is meta-type
		do_add = (skill.process_check(['tags', 'has', 'damage'])
			and skill.process_check(['best_hit_res', 'mask', variables.RES_HITCRIT])
			and !skill.template.has('not_final')
			and skill.skilltype != 'ultimate')
	if do_add:
		add_ultimeter(variables.ULTIMETER_COSTS[ev])

func process_event(ev, skill = null):
	#TR_TURN_GET for player's char can be processed on each selection, wich is wrong
	#this event must be processed strictly once per turn
	if ev == variables.TR_TURN_GET:
		if got_turn:
			return
		else:
			got_turn = true
	elif ev == variables.TR_TURN_S:
		got_turn = false
	
	.process_event(ev, skill)
	process_ultimeter(ev, skill)
