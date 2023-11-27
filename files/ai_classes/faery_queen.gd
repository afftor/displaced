extends ai_base

var stage = 1
var base_skills = ['attack', 'fq_summon', 'fq_lance', 'fq_screech']

func get_spec_data():
	var batt = input_handler.combat_node.enemygroup
	var res = 0
	for ch in batt.values():
		if ch.base == 'faery': res += 1
	return res

func get_skill_list():
	if stage == 1:
		return base_skills
	else:
		return base_skills + ['fq_flash', 'fq_blast']

func check_stage():
	if stage == 2: return
	if app_obj.get_stat('hp_p') <= 50:
		stage = 2
		app_obj.add_trait('fq_blast_info')
