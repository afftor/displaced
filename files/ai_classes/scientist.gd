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
