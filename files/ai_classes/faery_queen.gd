extends ai_base

func get_spec_data():
	var batt = globals.combat_node.enemygroup
	var res = 0
	for ch in batt.values():
		if ch.base == 'faery': res += 1
	return res
