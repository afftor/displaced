extends ai_base

var stage = 1
var base_skills = ['attack', 'sc_summon', 'en_enburst']

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
	if stage == 1:
		return base_skills + ['sc_shatter']
	else:
		return base_skills + ['en_thrust']

func check_stage():
	if stage == 2: return
	if app_obj.get_stat('hp_p') <= 50:
		stage = 2
