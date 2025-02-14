extends ai_base

#DK's stages for now are splitted in two different combatants. This AI is for second stage
func get_skill_list():
	var skill_list :Array = app_obj.get_skills()
	if app_obj.has_status('execute_charged'):
		skill_list = skill_list.duplicate()
		skill_list.append('dk_execute')
	return skill_list

#for two staged DK
#var stage = 1
#
#func get_skill_list():
#	var skill_list :Array
#	if stage == 1:
#		skill_list = ['attack', 'dk_stun', 'dk_slash', 'dk_strike']
#	else:
#		skill_list = ['attack', 'dk_stun', 'dk_dark', 'dk_execute_charge']
#	if app_obj.has_status('execute_charged'):
#		skill_list.append('dk_execute')
#	return skill_list
#
#func check_stage():
#	if stage == 2: return
#	if app_obj.get_stat('hp_p') <= 50:
#		stage = 2
#		app_obj.remove_trait('dwking_enrage1')
#		app_obj.add_trait('dwking_enrage2')
