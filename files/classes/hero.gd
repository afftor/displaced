extends combatant
class_name hero

var unlocked = false

var recentlevelups = 0
var baseexp = 0 setget exp_set

var alt_mana = 0 setget a_mana_set


var gear_level = {weapon1 = 1, weapon2 = 1, armor = 1}
var curweapon = 'weapon1'

var skillpoints = {support = 1, main = 1, ultimate = 0}


#out of combat regen stats
var regen_collected = 0

var bonusres = []

func _init():
	combatgroup = 'ally'

func createfromname(name):
	var template = combatantdata.charlist[name]
	base = template.code
	self.name = tr(template.name)
	for key in ['hpmax', 'hp_growth', 'evasion', 'hitrate', 'race', 'bonusres', 'unlocked', 'icon','combaticon', 'bodyhitsound', 'flavor', 'damage']:
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
	if template.keys().has('traits'):
		for t in template.traits:
			traits[t] = false;
			add_trait(t);
	animations = template.animations.duplicate()
	hp = get_stat('hpmax')


func regen_tick(delta):
	var regen_thresholds = regen_calculate_threshold()
	regen_collected += delta
	if regen_collected >= regen_thresholds:
		regen_collected -= regen_thresholds
		self.hp += 1


func regen_calculate_threshold():
	return variables.TimePerDay/max(get_stat('hpmax'),1)


func exp_set(value):
	if level >= variables.MaxLevel:
		baseexp = 100
	else:
		baseexp = value
		while baseexp > 100:
			baseexp -= 100
			levelup()


func a_mana_set(value):
	pass

func levelup():
	level += 1
	recentlevelups += 1
	if level in [4, 16, 22]:
		skillpoints.main += 1
	if level == 12:
		skillpoints.support += 1
	if level in [8, 28]:
		skillpoints.ultimate += 1

func can_unlock_skill(skill_code):
	var template = Skillsdata.skilllist[skill_code]
	if template.has('req_level') and level < template.req_level: return false
	if skills.has(skill_code): return false
	if !skillpoints.has(template.skilltype): return false
	return skillpoints[template.skilltype] > 0

func unlock_skill(skill_code):
	if !can_unlock_skill(skill_code): return
	var template = Skillsdata.skilllist[skill_code]
	skills.push_back(skill_code)
	skillpoints[template.skilltype] -= 1

func can_forget_skill(skill_code):
	var template = Skillsdata.skilllist[skill_code]
	if !skills.has(skill_code): return false
	if template.tags.has('default'): return false
	return true

func forget_skill(skill_code):
	if !can_forget_skill(skill_code): return
	var template = Skillsdata.skilllist[skill_code]
	skills.erase(skill_code)
	skillpoints[template.skilltype] += 1




func switch_weapon():
	if curweapon == 'weapon1': curweapon = 'weapon2'
	else: curweapon = 'weapon1'

func gear_check(slot, level, op):
	var lv = gear_level[slot]
	if slot != 'armor': 
		if slot != curweapon: lv = 0 #possibly not
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

func get_item_data(slot):
	var res = {icon = null, name = null, description = null, colors = [], type = slot}
	var template = Items.hero_items_data["%s_%s" % [id, slot]]
	var lvl = gear_level[slot]
	res.icon = template.leveldata[lvl].icon
	res.name = tr(template.name)
	res.description = tr(template.description) + tr(template.leveldata[lvl].lvldesc)
	return res

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
	return res


#this function is broken and needs revision (but for now skill tooltips are broken as well due to translation issues so i did't fix this)
#slill need fixing
func skill_tooltip_text(skillcode):
	var skill = Skillsdata.skilllist[skillcode]
	var text = ''
	if skill.description.find("%d") >= 0:
		text += skill.description % calculate_number_from_string_array(skill.value)
	else:
		text += skill.description
	return text


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
	tmp.skillpoints = skillpoints.duplicate()
	tmp.skills = skills.duplicate()
	tmp.hp = hp
#	tmp.mana = mana
	tmp.defeated = defeated
	tmp.position = position
	tmp.static_effects = static_effects.duplicate()
	tmp.temp_effects = temp_effects.duplicate()
	tmp.triggered_effects = triggered_effects.duplicate()
	tmp.bonuses = bonuses.duplicate()
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
	skillpoints = savedir.skillpoints.duplicate()
	skills = savedir.skills.duplicate()
	hp = savedir.hp
#	mana = savedir.mana
	defeated = savedir.defeated
	position = int(savedir.position)
	if position != null: state.combatparty[position] = id
	static_effects = savedir.static_effects.duplicate()
	temp_effects = savedir.temp_effects.duplicate()
	triggered_effects = savedir.triggered_effects.duplicate()
	bonuses = savedir.bonuses.duplicate()


var skills_autoselect = ["attack"]
func get_autoselected_skill():
	var skilldata = Skillsdata.patch_skill( skills_autoselect.back(), self)
	while !can_use_skill(skilldata):
		skills_autoselect.pop_back()
		skilldata = Skillsdata.patch_skill( skills_autoselect.back(), self)
	return skills_autoselect.back()
