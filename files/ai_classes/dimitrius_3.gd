extends ai_base

func shuffle_resists():
	var key_tres = ['slash', 'pierce', 'dark', 'air']#advantageous for Arron
	var tres = ['bludgeon', 'light', 'water', 'earth', 'fire']
	var new_resists = {}
	for resist in key_tres:
		new_resists[resist] = 75.0
	for resist in tres:
		new_resists[resist] = 75.0
	
	#idea is that slash resist must be at least -100, so Arron could have a chance
	randomize()
	var best = randi() % 4
	var support = 0
	if best == 0:
		support = randi() % 3 + 1
	var last = randi() % 5
	new_resists[key_tres[best]] = -200.0
	new_resists[key_tres[support]] = -100.0
	new_resists[tres[last]] = -100.0
	
	app_obj.set_resists(new_resists)
