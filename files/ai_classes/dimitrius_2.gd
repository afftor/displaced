extends ai_base

var stage = 1

func get_skill_list():
	if stage == 1:
		return ['attack', 'dm_storm', 'dm_fire', 'dm_poison_spike', 'dm_bomb']
	else:
		return ['attack', 'dm_storm', 'dm_nova', 'dm_form']

func check_stage():
	if stage == 2: return
	if app_obj.get_stat('hp') <= 2:
		stage = 2
		app_obj.hp_set(app_obj.hpmax_get())
		app_obj.remove_trait('dem_soulprot')
		app_obj.add_trait('dem_rules')

func shuffle_resists():
	var tres = ['slash', 'pierce', 'bludgeon', 'light', 'dark', 'air', 'water', 'earth', 'fire']
	tres.shuffle()
	var new_resists = {}
	for i in range(0,3):
		new_resists[tres[i]] = -100.0
	for i in range(3,9):
		new_resists[tres[i]] = 75.0
	app_obj.set_resists(new_resists)
