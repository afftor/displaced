extends hero
class_name h_rilu

func _init():
	id = 'rilu'
	state.heroes[id] = self
	createfromname('rilu')

#func deserialize(savedir): 
#	.deserialize(savedir)
#	if !traits.has('necro_trait'):
#		traits.push_back('necro_trait')
#	remove_trait('necro_trait')
#	add_trait('necro_trait')


func hpmax_get():
	var res = .hpmax_get()
	match state.get_upgrade_level('farm'):
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
	#old concept
#	if value > alt_mana:
#		if cooldowns.has('soul_prot') and gear_check('weapon2', 4, 'gte'):
#			if globals.rng.randf() < 0.25:
#				cooldowns['soul_prot'] -= 1
#				if cooldowns['soul_prot'] == 0: cooldowns.erase('soul_prot') 
	alt_mana = clamp(round(value), 0, 3)
	recheck_effect_tag('recheck_alt_mana')
