extends hero
class_name h_rilu

func _init():
	id = 'rilu'
	state.heroes[id] = self
	createfromname('rilu')
	add_trait('necro_trait')

#func deserialize(savedir): 
#	.deserialize(savedir)
#	if !traits.has('necro_trait'):
#		traits.push_back('necro_trait')
#	remove_trait('necro_trait')
#	add_trait('necro_trait')


func get_resists():
	var res = resists.duplicate()
	for r in variables.resistlist:
		if r in bonusres:
			match gear_level.armor:
				1: res[r] = 20
				2: res[r] = 40
				3: res[r] = 60
				4: res[r] = 80
		else:
			match gear_level.armor:
				1: res[r] = 10
				2: res[r] = 20
				3: res[r] = 30
				4: res[r] = 40
		if bonuses.has('resist' + r + '_add'): res[r] += bonuses['resist' + r + '_add']
		if bonuses.has('resist' + r + '_mul'): res[r] *= bonuses['resist' + r + '_mul']
	return res

func hpmax_get():
	var res = .hpmax_get()
	match state.get_upgrade_level('field'):
		1: res *= 1.15
		2: res *= 1.3
		3: res *= 1.45
		4: res *= 1.6
	return int(res)

func damage_get():
	var res = .damage_get()
	match state.get_upgrade_level('mill'):
		1: res *= 1.15
		2: res *= 1.3
		3: res *= 1.45
		4: res *= 1.6
	return int(res)

func a_mana_set(value):
	if value > alt_mana:
		if cooldowns.has('soul_prot') and gear_check('weapon1', 'gte', 4):
			var rnd = globals.rng.randf()
			if rnd < 0.25: 
				cooldowns['soul_prot'] -= 1
				if cooldowns['soul_prot'] == 0: cooldowns.erase('soul_prot') 
	alt_mana = clamp(round(value), 0, 5) 
