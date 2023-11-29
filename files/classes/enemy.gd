extends combatant
class_name enemy

var xpreward setget ,get_reward #for enemies 
var loottable

var base_dmg_type = 'bludgeon'

var ai
var ai_spec setget ,get_spec_data

func _init():
	combatgroup = 'enemy'
	critchance = 0

func get_spec_data():
	if ai == null: return null
	return ai.get_spec_data()


func get_reward():
	return  int(xpreward * variables.curve[level - 1])


func hpmax_get():
	var res = .hpmax_get()
	if state.get_difficulty() == 'easy':
		res *= variables.EasyDiffMul
	return res


func damage_get():
	var res = .damage_get()
	if state.get_difficulty() == 'easy':
		res *= variables.EasyDiffMul
	return res

#confirmed getters
func get_weapon_damagetype():
	var res = base_dmg_type
	return res

func get_weapon_range():
	return base_dmg_range

func apply_atomic(template):
	match template.type:
		'ai_call':
			if ai == null: return
			if ai.has_method(template.value): ai.call(template.value)
		_: .apply_atomic(template)

func createfromtemplate(enemy_id, lvl):
	var template = Enemydata.enemylist[enemy_id].duplicate()
	base = enemy_id
	level = lvl
	race = template.race
	hpmax = 0 #template.basehp #or not
	hp_growth = template.basehp
	self.hp = get_stat('hpmax')
	is_boss = (template.has('is_boss') and template.is_boss)
#	manamax = template.basemana
#	self.mana = manamax
	skills = template.skills.duplicate()
	id = 'h'+str(state.heroidcounter)
	state.heroidcounter += 1
	state.heroes[id] = self
	for i in ['damage','name','hitrate','evasion','icon','combaticon', 'loottable', 'xpreward', 'bodyhitsound', 'weaponsound', 'flavor', 'base_dmg_type', 'base_dmg_range']:
		#self[i] = template[i]
		if template.has(i): set(i, template[i])
	for i in variables.resistlist:
		resists[i] = 0
		if !template.has('resists'): continue
		if template.resists.has(i):
			resists[i] = template.resists[i]
		if state.get_difficulty() == 'easy' and resists[i] > 0: resists[i] /= 2
	for i in variables.status_list:
		status_resists[i] = 0
		if !template.has('status_resists'): continue
		if template.status_resists.has(i):
			status_resists[i] = template.status_resists[i]
	if template.keys().has('traits'):
		for t in template.traits:
			add_trait(t);
	if template.has('ai'):
		ai = template.ai.new()
	else:
		ai = ai_base.new()
	ai.bind(self)
	animations = template.animations.duplicate()

