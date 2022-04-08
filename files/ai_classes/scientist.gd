extends ai_base

#func _init():
#	set_single_state({})
#	ai_data[0].choices = {
#		summon = 10,
#		damage = 2,
#		aoe = 2,
#		poison = 1
#	}

func get_spec_data():
	var batt = input_handler.combat_node.enemygroup
	var res = 0
	for ch in batt.values():
		if ch.base == 'bomber': res += 1
	return res


func get_skill_list():
	if app_obj.hp > 250: #first stage
		return ['attack', 'sc_summon1', 'sc_shatter', 'en_enburst']
	else: #second stage
		return ['attack', 'sc_summon1', 'en_enburst', 'en_thrust']
