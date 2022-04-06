extends ai_base

func get_skill_list():
	if app_obj.hp > 200: #first stage
		return ['attack', 'vic_fburst', 'vic_culling', 'en_enburst']
	else: #second stage
		return ['attack', 'vic_fburst', 'vic_culling', 'en_enburst', 'en_thrust']
