extends ai_base

var stage = 1
var base_skills = ['attack', 'vic_fburst', 'vic_culling', 'en_enburst']

func get_skill_list():
	if stage == 1:
		return base_skills
	else:
		return base_skills + ['en_thrust']

func check_stage():
	if stage == 2: return
	if app_obj.get_stat('hp_p') <= 50:
		stage = 2
