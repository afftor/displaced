extends ai_base

func get_spec_data():
	var batt = input_handler.combat_node.enemygroup
	var res = 0
	for ch in batt.values():
		if ch.base == 'faery': res += 1
	return res


func get_skill_list():
	if app_obj.get_stat('hp_p') > 50: #first stage
		return ['attack', 'fq_summon', 'fq_lance', 'fq_screech']
	else: #second stage
		return ['attack', 'fq_summon', 'fq_lance', 'fq_screech', 'fq_flash', 'fq_blast']
