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
	var batt = globals.combat_node.enemygroup
	return batt.size()
