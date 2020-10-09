extends ai_base

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
