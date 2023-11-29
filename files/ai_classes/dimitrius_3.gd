extends ai_base

func shuffle_resists():
	var key_tres = ['slash', 'pierce', 'dark', 'air']#advantageous for Arron
	var tres = ['bludgeon', 'light', 'water', 'earth', 'fire']
	for resist in key_tres:
		app_obj.resists[resist] = 75.0
	for resist in tres:
		app_obj.resists[resist] = 75.0
	
	#idea is that slash resist must be at least -100, so Arron could have a chance
	randomize()
	var best = randi() % 4
	var support
	if best == 0:
		support = randi() % 3 + 1
	else:
		support = 0
	var last = randi() % 5
	app_obj.resists[key_tres[best]] = -200.0
	app_obj.resists[key_tres[support]] = -100.0
	app_obj.resists[tres[last]] = -100.0
