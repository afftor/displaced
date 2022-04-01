extends ai_base

func get_skill_list():
	if app_obj.hp > 200: #first stage
		return ['attack', 'dk_slash', 'dk_strike', 'dk_stun']
	else: #second stage
		return ['attack', 'dk_stun', 'dk_dark', 'dk_execute_charge']
