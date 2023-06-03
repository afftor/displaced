extends "res://files/Close Panel Button/ClosingPanel.gd"

export var test_mode = false
var location = 'village'
var area = null


onready var arealist = $ExplorationSelect/missions/ScrollContainer/MarginContainer/VBoxContainer
onready var areapanel = $BattleGroup
onready var locdesc = $ExplorationSelect/about/desc
onready var partylist = $BattleGroup/party
onready var reservelist = $BattleGroup/roster
onready var areadesc = $BattleGroup/about_bg/about
onready var locname = $ExplorationSelect/head
onready var scalecheck = $BattleGroup/ScaleCheck

onready var combat_node = get_parent().get_node("combat")

func _ready():
	Explorationdata.preload_resources()
	$BattleGroup/start.connect("pressed", self, "start_area")
	$BattleGroup/advance.connect("pressed", self, "advance_area")
	$BattleGroup/abandon.connect("pressed", self, "abandon_area")
	$ExplorationSelect/Close.connect('pressed', self, 'hide')
	
	build_party()
	input_handler.connect("PositionChanged", self, 'build_party')
	input_handler.connect("EventFinished", self, 'build_party')
	input_handler.explore_node = self
	
	$BattleGroup/screen.parent_node = self
	
	$AdvConfirm/panel/ok.connect("pressed", self, 'adv_confirm')
	$AdvConfirm/panel/no.connect("pressed", self, 'adv_decline')
	scalecheck.connect('true_pressed', self, 'reset_level')
	
	closebutton.visible = false
	
	if test_mode: 
		if resources.is_busy(): yield(resources, "done_work")
		test()
	
	var mission_btn = arealist.get_node("Button")
	TutorialCore.register_button("missions", 
		mission_btn.rect_global_position, 
		mission_btn.rect_size)
	


func test():
	for cid in state.characters:
		state.unlock_char(cid)
	set_location('forest')
	area = 'forest_erika'
	state.areaprogress[area].unlocked = true
#	show()
	open_mission()


func set_location(loc_code):
	location = loc_code
	if typeof(Explorationdata.locations[location].background) == TYPE_STRING:
		$ExplorationSelect/about/Image.texture = resources.get_res("bg/%s" % Explorationdata.locations[location].background)
	else:
		$ExplorationSelect/about/Image.texture = Explorationdata.locations[location].background #obsolete, for testing
	areadesc.bbcode_text = ""


func show():
	.show()
#	input_handler.explore_node = self
#	if state.activearea != null and Explorationdata.areas[state.activearea].category == location:
	input_handler.menu_node.visible = false
	if state.activearea != null and (location == 'mission' or Explorationdata.locations[location].missions.has(state.activearea)):
		area = state.activearea
		open_mission()
	else:
		open_explore()


func open_explore():
	areapanel.visible = false
	$ExplorationSelect/about/level.text = ""
	$ExplorationSelect/about/progress.visible = false
	input_handler.ClearContainer(arealist, ['Button'])
	var num_missions = 0
	if !Explorationdata.locations.has(location): #mission case
		var areadata = Explorationdata.areas[area]
		var panel = input_handler.DuplicateContainerTemplate(arealist, 'Button')
		panel.text = tr(areadata.name)
		locname.text = tr(areadata.name)
		locdesc.bbcode_text = tr(areadata.descript)
		panel.set_meta('area', area)
		panel.connect('pressed', self, 'select_area', [area])
		panel.get_node('Completed').visible = false
		num_missions += 1
	else: #general case
		locname.text = tr(Explorationdata.locations[location].name)
		locdesc.bbcode_text = tr(Explorationdata.locations[location].descript)
		for a in Explorationdata.locations[location].missions:
			var areadata = Explorationdata.areas[a]
			if !state.areaprogress[a].unlocked: continue
			if state.areaprogress[a].completed: continue
			var panel = input_handler.DuplicateContainerTemplate(arealist, 'Button')
			panel.text = tr(areadata.name)
			panel.set_meta('area', a)
			panel.connect('pressed', self, 'select_area', [a])
			panel.get_node('Completed').visible = false
			num_missions += 1
		for a in Explorationdata.locations[location].missions:
			var areadata = Explorationdata.areas[a]
			if !state.areaprogress[a].unlocked: continue
			if !state.areaprogress[a].completed: continue
			var panel = input_handler.DuplicateContainerTemplate(arealist, 'Button')
			panel.text = tr(areadata.name)
			panel.set_meta('area', a)
			panel.connect('pressed', self, 'select_area', [a])
			panel.get_node('Completed').visible = true
			num_missions += 1
	if num_missions == 0:
		hide()


func select_area(area_code):
	area = area_code
	areapanel.visible = true
	for node in arealist.get_children():
		node.pressed = (node.has_meta('area') and area == node.get_meta('area'))
	if state.activearea == null:
		scalecheck.set_state(false)
		scalecheck.disabled = false
	elif state.activearea != area:
		scalecheck.set_state(false)
		scalecheck.disabled = true
	else:
		scalecheck.set_state(Explorationdata.areas[area].level != state.areaprogress[area].level)
		scalecheck.disabled = true
	scalecheck.visible = state.areaprogress[area].completed
	build_area_description() #+build_area_info
	#update_buttons() #build_area_description has it


func reset_level():
	if area == null : return
	if scalecheck.checked:
		$ExplorationSelect/about/level.text = "Level %d" % state.heroes['arron'].level
	else:
		$ExplorationSelect/about/level.text = "Level %d" % Explorationdata.areas[area].level


func reset_progress():
	var areastate = state.areaprogress[area]
	var areadata = Explorationdata.areas[area]
	var progress_node = $ExplorationSelect/about/progress
	progress_node.visible = true
	progress_node.value = areastate.stage - 1
	progress_node.max_value = areadata.stages
	progress_node.get_node("Label").text = "%d/%d" % [areastate.stage, areadata.stages]


func build_area_description():
	build_party()
	var areadata = Explorationdata.areas[area]
	if areadata.has('descript'):
		areadesc.bbcode_text = tr(areadata.descript)
	else:
		areadesc.bbcode_text = ""
	if areadata.has('explore_image') and areadata.explore_image != null and areadata.explore_image!= '':
		$ExplorationSelect/about/Image.texture = resources.get_res("bg/%s" % areadata.explore_image)
#	elif areadata.has('image') and areadata.image != null and areadata.image!= '':
#		$ExplorationSelect/about/Image.texture = resources.get_res("bg/%s" % areadata.image)
	else:
		$ExplorationSelect/about/Image.texture = resources.get_res("bg/%s" % Explorationdata.locations[location].background)
	reset_level()
	
	if state.activearea != null and state.activearea == area:
		reset_progress()
	else:
		$ExplorationSelect/about/progress.visible = false
	
	update_buttons()


func start_area():
	state.start_area(area, scalecheck.checked)
	for node in arealist.get_children():
		if !node.visible: continue
		node.disabled = (area != node.get_meta('area'))
	open_mission()


func open_mission():
	if area != state.activearea:
		print("warning - opened not active area")
	open_explore()
	select_area(area)


func show_screen():
	$BattleGroup/screen.visible = true

func build_party():
	$BattleGroup/screen.visible = false
	for i in range(3):
#		partylist.get_child(i).disabled = true
		var node = partylist.get_child(i)
		node.get_node('icon').texture = null
		node.get_node('level').text = ""
		node.get_node('name').text = ""
		node.parent_node = self
		node.dragdata = null
		node.unpress()
		
#	for i in range(6):
#		var node = reservelist.get_child(i)
#		node.texture = null
#		node.parent_node = self
#		node.dragdata = null

	input_handler.ClearContainer(reservelist, ['Button'])
	for ch in state.characters:
		var hero = state.heroes[ch]
		if !hero.unlocked: continue
		if hero.position != null:
			var node = partylist.get_child(hero.position - 1)
			node.get_node('icon').texture = hero.portrait()
			node.get_node('level').text = "Level %d" % hero.level
			node.get_node('name').text = hero.name
			node.dragdata = ch
		var node = input_handler.DuplicateContainerTemplate(reservelist, 'Button')
		node.get_node('icon').texture = hero.portrait()
		node.get_node('level').text = "Level %d" % hero.level
		node.get_node('name').text = hero.name
		node.dragdata = ch
		node.parent_node = self

	update_buttons()


func show_info(ch_id):
	var node = input_handler.get_spec_node(input_handler.NODE_SLAVEPANEL)
	node.open(state.heroes[ch_id])



func abandon_area():
	input_handler.get_spec_node(input_handler.NODE_CONFIRMPANEL, [self, 'abandon_area_confirm', tr('ABANDONAREA')])


func abandon_area_confirm():
	state.abandon_area()
	open_explore()


func advance_area():
	$AdvConfirm.visible = false
	var areadata = Explorationdata.areas[area]
	var areastate = state.areaprogress[area]
	#2add generic scene check
#	areastate.stage += 1
	if areastate.stage > areadata.stages:
		finish_area()
	else:
		var stagedata
		if areadata.enemies.has(areastate.stage):
			stagedata = areadata.enemies[areastate.stage]
			#predescribed combat
			var party
			if typeof(stagedata) == TYPE_STRING:
				party = Enemydata.predeterminatedgroups[stagedata].group
			else:
				party = stagedata.duplicate(true) 
			var level = areastate.level
			if stagedata.has('level'):
				level = stagedata.level - areadata.level + areastate.level
			set_party_level_data(party, areadata.level, level)
			var bg
			if Explorationdata.locations.has(location): 
				bg = Explorationdata.locations[location].background
			if areadata.has('image') and areadata.image != null and (areadata.image is Array or areadata.image != ""):
				bg = areadata.image
			#2add set sound
			if areadata.has("tutorials") and areadata.tutorials.has(areastate.stage):
				TutorialCore.scenario_connect(
					areadata.tutorials[areastate.stage], combat_node)
			combat_node.show()
			combat_node.start_combat(party, level, bg)
#			elif stagedata.has('scene'):
#				#fixed scene
#				if state.OldEvents.has(stagedata.scene) and events.events[stagedata.scene].onetime:
#					areastate.stage += 1
#					advance_area()
#				else:
#					#2move to globals method
#					input_handler.OpenClose(input_handler.scene_node)
#					input_handler.scene_node.replay_mode = state.OldEvents.has(stagedata.scene)
#					input_handler.scene_node.play_scene(stagedata.scene)
#
#					yield(input_handler.scene_node, "scene_end")
#					advance_check()
		else:
			#random combat
			var tmp
			var arr = []
			for group in areadata.enemygroups:
				var groupdata = Enemydata.randomgroups[group]
				if !state.checkreqs(groupdata.reqs):  continue
				arr.push_back({value = group, weight = groupdata.weight})
			tmp = input_handler.weightedrandom(arr).value
			var party = create_random_group(Enemydata.randomgroups[tmp].units) 
			var level = areastate.level
			set_party_level_data(party, areadata.level, level)
			var bg = Explorationdata.locations[location].background
			if areadata.has('image') and areadata.image != null and(areadata.image is Array or areadata.image != ""):
				bg = areadata.image
			#2add set sound
			combat_node.show()
			combat_node.start_combat(party, level, bg)


func create_random_group(data):
	var res = []
	if typeof(data) == TYPE_DICTIONARY:
		#old (current) format. generates unit pool then form waves from them
		var pool = generate_unit_pool(data)
		var nw = 1
		if pool.melee.size() > 3 * nw: nw = (pool.melee.size() - 1)/3 + 1
		if pool.ranged.size() > 3 * nw: nw = (pool.ranged.size() - 1)/3 + 1
		
		for i in range(3 * nw - pool.melee.size()): 
			pool.melee.push_back("")
		for i in range(3 * nw - pool.ranged.size()): 
			pool.ranged.push_back("")
		
		pool.melee.shuffle()
		pool.ranged.shuffle()
		
		for i in range(nw):
			var res_w = {}
			for pos in range(1, 4):
				if pool.melee[pos - 1 + 3 * i] != "":
					res_w[pos] = pool.melee[pos - 1 + 3 * i] 
			for pos in range(4, 7):
				if pool.ranged[pos - 4 + 3 * i] != "":
					res_w[pos] = pool.ranged[pos - 4 + 3 * i] 
			res.push_back(res_w)
#		return res
	elif typeof(data) == TYPE_ARRAY:
		#normal format. has data for separate waves
		for w_data in data:
			var res_w = {}
			var pool = generate_unit_pool(w_data)
			
#			pool.melee.shuffle()
			pool.ranged.shuffle()
			for i in range(pool.ranged.size() - 3):
				pool.melee.push_back(pool.ranged.pop_back())
			
			pool.melee.shuffle()
			for i in range(pool.melee.size() - 3):
				pool.ranged.push_back(pool.melee.pop_back())
			
			for i in range(3 - pool.melee.size()):
				pool.melee.push_back("")
			for i in range(3 - pool.ranged.size()):
				pool.ranged.push_back("")
			
			pool.melee.shuffle()
			pool.ranged.shuffle()
			
			for pos in range(1, 4):
				if pool.melee[pos - 1] != "":
					res_w[pos] = pool.melee[pos - 1] 
			for pos in range(4, 7):
				if pool.melee[pos - 4] != "":
					res_w[pos] = pool.ranged[pos - 4] 
			
			res.push_back(res_w) 
#		return res
	elif typeof(data) == TYPE_STRING:
		res = Enemydata.predeterminatedgroups[data].group.duplicate()
#		return Enemydata.predeterminatedgroups[data].group
	else:
		print ("error in random party data")
		res = [{1: 'elvenrat'}]
	return res


func generate_unit_pool(data):
	var res = {melee = [], ranged = []}
	for unit in data:
		var edata = Enemydata.enemylist[unit]
		var pos = res.melee
		if edata.has('aiposition') and edata.aiposition == 'ranged':
			pos = res.ranged
		var n = globals.rng.randi_range(data[unit][0], data[unit][1])
		for i in range(n):
			pos.push_back(unit)
	return res


func set_party_level_data(party, def_lvl, cur_lvl):
	#cause party is array we can modify it without returning
	for wave in party:
		for pos in wave:
			if typeof(wave[pos]) == TYPE_STRING:
				var temp = {unit = wave[pos], level = cur_lvl}
				wave[pos] = temp
			elif typeof(wave[pos]) == TYPE_ARRAY: #currently main case 
				if wave[pos].size() == 1:
					wave[pos].push_back(cur_lvl)
				else:
					wave[pos][1] += cur_lvl - def_lvl
				var tres = {}
			elif typeof(wave[pos]) == TYPE_DICTIONARY:
				if wave[pos].has('level'):
					print("monster %s upscaled" % wave[pos].unit)
					wave[pos].level += cur_lvl - def_lvl
				else:
					wave[pos].level = cur_lvl
			else:
				print("warning: wrong party format")
				print(party)

func finish_area():
	state.complete_area()
	var areadata = Explorationdata.areas[area]
	if areadata.has('events') and areadata.events.has("on_complete"):
		var scene = areadata.events.on_complete
		var enforce_replay = state.OldEvents.has(scene)
		if globals.play_scene(scene, enforce_replay):
#			yield(input_handler.scene_node, "scene_end")
			yield(input_handler, "EventFinished")
	if location != 'mission': open_explore()
	else: hide()
	if areadata.has('events') and areadata.events.has("on_complete_seq"):
		var seq_id = areadata.events.on_complete_seq
		if state.check_sequence(seq_id):
			var output = globals.run_seq(seq_id)
			if output == variables.SEQ_SCENE_STARTED :
				yield(input_handler, "EventOnScreen")
	input_handler.combat_node.hide_me()


func combat_finished(value):
	if value:
		combat_win()
	else:
		combat_loose()


func combat_win():
	advance_check()


func combat_loose():
	input_handler.combat_node.hide_me()
	var areastate = state.areaprogress[area]
	var areadata = Explorationdata.areas[area]
	if areadata.has('no_escape') and areadata.no_escape:
#		hide()
		input_handler.menu_node.GameOverShow()
		return
	if areastate.stage == 1:
		state.abandon_area()
	if !$ExplorationSelect/Close.disabled:
		hide()


func hide():
	input_handler.menu_node.visible = true
	input_handler.map_node.update_map()
	.hide()


func advance_check():
	var areadata = Explorationdata.areas[area]
	var areastate = state.areaprogress[area]
	#2add generic scene check
	areastate.stage += 1
	if areastate.stage > areadata.stages:
		finish_area()
	else:
		build_area_description()
#		if areadata.stagedenemies.has(areastate.stage) and areadata.stagedenemies[areastate.stage].has('scene'):
#			advance_area()
		var playing_scene = false
		if areadata.events.has("after_fight_%d" % (areastate.stage - 1)):
			var scene = areadata.events["after_fight_%d" % (areastate.stage - 1)]
			var enforce_replay = state.OldEvents.has(scene)
			playing_scene = globals.play_scene(scene, enforce_replay)
			if playing_scene:
				yield(input_handler, "EventOnScreen")

#			if !enforce_replay: #kept legacy code with it's logic, but it was already to old to work
#				yield(input_handler.scene_node, "scene_end")
#				advance_check()
		input_handler.combat_node.hide_me()
		if !playing_scene:
			$AdvConfirm.visible = true

func adv_confirm():
	advance_area()

func adv_decline():
	$AdvConfirm.visible = false


func check_party():
	var free_positions = [1, 2, 3]
	var free_heroes = []
	for ch in state.characters:
		var thero = state.heroes[ch]
		if !thero.unlocked : continue
		if thero.position == null: 
			free_heroes.push_back(thero)
		else:
			free_positions.erase(thero.position)
	while !free_positions.empty() and !free_heroes.empty():
		var pos = free_positions.front()
		var tch = free_heroes.front()
		tch.position = pos
		free_positions.pop_front()
		free_heroes.pop_front()


func auto_advance():
	check_party()
	advance_area()

func update_buttons() ->void:
	var start = $BattleGroup/start
	var advance = $BattleGroup/advance
	var abandon = $BattleGroup/abandon
	var close = $ExplorationSelect/Close

	start.disabled = false
	advance.disabled = false
	abandon.disabled = false
	close.disabled = false
	
	if state.activearea == null:
		start.show()
		advance.hide()
		abandon.hide()
	elif state.activearea != area:
		start.show()
		start.disabled = true
		advance.hide()
		abandon.hide()
	else:
		start.hide()
		advance.show()
		abandon.show()
		
		var areadata = Explorationdata.areas[area]
		if areadata.has('no_escape') and areadata.no_escape:
			abandon.disabled = true
			close.disabled = true

	var has_no_party = true
	for ch in state.characters:
		if state.heroes[ch].position != null:
			has_no_party = false
			break
	if has_no_party:
		start.disabled = true
		advance.disabled = true
