extends ai_base

var stage = 1

func get_skill_list():
	if stage == 1:
		return ['attack', 'dm_storm', 'dm_fire', 'dm_poison_spike', 'dm_bomb']
	else:
		return ['attack', 'dm_storm', 'dm_nova', 'dm_form']

func check_stage():
	if stage == 2: return
	print("check_stage hp = %s" % app_obj.get_stat('hp'))
	if app_obj.get_stat('hp') <= 2:
		stage = 2
		app_obj.hp_set(app_obj.hpmax_get())
		app_obj.remove_trait('dem_soulprot')
		app_obj.add_trait('dem_rules')

func shuffle_resists():
	var tres = ['slash', 'pierce', 'bludgeon', 'light', 'dark', 'air', 'water', 'earth', 'fire']
	tres.shuffle()
	app_obj.resists[tres[0]] = -100.0
	app_obj.resists[tres[1]] = -100.0
	app_obj.resists[tres[2]] = -100.0
	app_obj.resists[tres[3]] = 75.0
	app_obj.resists[tres[4]] = 75.0
	app_obj.resists[tres[5]] = 75.0
	app_obj.resists[tres[6]] = 75.0
	app_obj.resists[tres[7]] = 75.0
	app_obj.resists[tres[8]] = 75.0
