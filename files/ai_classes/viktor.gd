extends ai_base

func get_skill_list():
	if app_obj.get_stat('hp_p') > 50: #first stage
		return ['attack', 'vic_fburst', 'vic_culling', 'en_enburst']
	else: #second stage
		return ['attack', 'vic_fburst', 'vic_culling', 'en_enburst', 'en_thrust']
