extends Panel



func _ready():
	input_handler.SetMusic("eventgeneric")#('combattheme')
	input_handler.SetMusic('combattheme')
	globals.preload_backgrounds()
	for ch in state.heroes:
		get_node("VBoxContainer/%s/Label" % ch).text = ch
	for i in range(1, 5):
		for j in range(1, 7):
			get_node("waves/w%d/s%d/Label" % [i, j]).text = str(j)
			get_node("waves/w%d/s%d/monster/value" % [i, j]).add_item('null')
			get_node("waves/w%d/s%d/monster/value" % [i, j]).selected = 0
			for id in Enemydata.enemylist:
				get_node("waves/w%d/s%d/monster/value" % [i, j]).add_item(id)
	$run.connect("pressed", self, 'run_test')


func test_combat():
	$combat.test_combat()


func run_test():
	if resources.is_busy(): yield(resources, "done_work")
	state.add_test_resources()
	for ch in state.characters:
		state.unlock_char(ch)
		state.heroes[ch].unlock_all_skills()
		state.heroes[ch].level = int($partylv/value.text)
		state.heroes[ch].hp = state.heroes[ch].hpmax
		state.heroes[ch].curweapon = get_node("VBoxContainer/%s/weapon/value" % ch).text
		state.heroes[ch].gear_level[state.heroes[ch].curweapon] = int(get_node("VBoxContainer/%s/weaponlv/value" % ch).text)
		state.heroes[ch].gear_level.armor = int(get_node("VBoxContainer/%s/armorlv/value" % ch).text)
	state.heroes.arron.position = 1
	state.heroes.ember.position = 2
	state.heroes.rose.position = 3
	state.heroes.rilu.position = null
	state.heroes.iola.position = null
	state.heroes.erika.position = null
	
	var endata = []
	for i in range(1, 5):
		var wdata = {}
		for j in range(1, 7):
			if get_node("waves/w%d/s%d/monster/value" % [i, j]).selected == 0: continue
			wdata[j] = [get_node("waves/w%d/s%d/monster/value" % [i, j]).get_item_text(get_node("waves/w%d/s%d/monster/value" % [i, j]).selected)]
			if !get_node("waves/w%d/s%d/lv/value" % [i, j]).text.empty():
				wdata[j].push_back(int(get_node("waves/w%d/s%d/lv/value" % [i, j]).text))
			else:
				wdata[j].push_back(int($enlv/value.text))
		if wdata.empty():
			break
		else:
			endata.push_back(wdata)
	if endata.empty(): return
	$combat.show()
	$combat.start_combat(endata, int($enlv/value.text), 'combat_cave', 'combattheme')
