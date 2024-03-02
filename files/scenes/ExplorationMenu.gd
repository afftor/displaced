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
onready var fakeload = $fake_load

onready var combat_node = get_parent().get_node("combat")

var sounds = {
	"start" : "sound/dragon protection",
	"abandon" : "sound/menu_close"
}

var pressed_char_btn

func _ready():
	Explorationdata.preload_resources()
	for i in sounds.values():
		resources.preload_res(i)
	if resources.is_busy(): yield(resources, "done_work")
	$BattleGroup/start.connect("pressed", self, "on_start_press")
	$BattleGroup/advance.connect("pressed", self, "on_advance_pressed")
	$BattleGroup/abandon.connect("pressed", self, "abandon_area")
	$ExplorationSelect/Close.connect('pressed', self, 'hide')
	
	build_party()
	input_handler.connect("PositionChanged", self, 'build_party')
	input_handler.queue_connection("scene_node", "EventFinished", self, 'build_party')
	input_handler.set_handler_node('explore_node', self)
	
	$BattleGroup/screen.parent_node = self
	
#	$AdvConfirm/panel/ok.connect("pressed", self, 'adv_confirm')
#	$AdvConfirm/panel/no.connect("pressed", self, 'adv_decline')
	scalecheck.connect('pressed', self, 'reset_level')
	
	closebutton.visible = false
	
	if test_mode: 
		if resources.is_busy(): yield(resources, "done_work")
		test()
	
	TutorialCore.register_dynamic_button("missions", self, "pressed")


func get_tutorial_button(button_name :String):
	if button_name == "missions":
		return arealist.get_child(0)


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
		var completed_missions = []
		var incompleted_missions = []
		for a in Explorationdata.locations[location].missions:
			if !state.areaprogress[a].unlocked: continue
			if state.areaprogress[a].completed:
				completed_missions.append(a)
			else:
				incompleted_missions.append(a)
		for a in incompleted_missions + completed_missions:
			var areadata = Explorationdata.areas[a]
			var panel = input_handler.DuplicateContainerTemplate(arealist, 'Button')
			panel.text = tr(areadata.name)
			panel.set_meta('area', a)
			panel.connect('pressed', self, 'select_area', [a])
			panel.get_node('Completed').visible = state.areaprogress[a].completed
			num_missions += 1
			if area:
				panel.pressed = (area == a)
			if state.activearea:
				panel.disabled = (state.activearea != a)
	#this hide() seems to break down opening of missionless locs. If it has any other use, return this code
#	if num_missions == 0:
#		hide()


func select_area(area_code):
	area = area_code
	areapanel.visible = true
	for node in arealist.get_children():
		node.pressed = (node.has_meta('area') and area == node.get_meta('area'))
	if state.activearea == null:
		scalecheck.pressed = false
		scalecheck.smart_disable(false)
	elif state.activearea != area:
		scalecheck.pressed = false
		scalecheck.smart_disable(true)
	else:
		scalecheck.pressed = Explorationdata.areas[area].level != state.areaprogress[area].level
		scalecheck.smart_disable(true)
	scalecheck.visible = state.areaprogress[area].completed
	build_area_description() #+build_area_info
	#update_buttons() #build_area_description has it


func reset_level():
	if area == null : return
	if scalecheck.pressed:
		$ExplorationSelect/about/level.text = "Level %d" % state.heroes['arron'].level
	else:
		$ExplorationSelect/about/level.text = "Level %d" % Explorationdata.areas[area].level


func reset_progress():
	var areastage = get_area_stage()
	var areastage_num = get_area_stage_num()
	var progress_node = $ExplorationSelect/about/progress
	progress_node.visible = true
	progress_node.value = areastage - 1
	progress_node.max_value = areastage_num
	progress_node.get_node("Label").text = "%d/%d" % [progress_node.value, progress_node.max_value]

func get_area_stage() ->int:
	if !area: return 0
	return state.areaprogress[area].stage

func get_area_stage_num() ->int:
	if !area: return 0
	return Explorationdata.areas[area].stages

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


func on_start_press():
	var areadata = Explorationdata.areas[area]
	if areadata.has("final") and areadata.final:
		input_handler.get_spec_node(input_handler.NODE_CONFIRMPANELBIG, [self, 'start_area', tr('FINAL_BATTLE_WARNING'), tr('FINAL_BATTLE_WARNING_BTN')])
	else:
		start_area()


func start_area():
	input_handler.PlaySound(sounds["start"])
	state.start_area(area, scalecheck.pressed)
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
	unpress_char_btn()
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
	input_handler.PlaySound(sounds["abandon"])
	state.abandon_area()
	open_explore()

func on_advance_pressed():
	input_handler.block_screen()
	var curtain_time = 0.5
	show_combat_curtain(curtain_time)
	yield(get_tree().create_timer(curtain_time), 'timeout')
	fakeload.open()
	hide_combat_curtain()
	fakeload.start_load()
	yield(fakeload, "load_finished")
	show_combat_curtain(curtain_time)
	yield(get_tree().create_timer(curtain_time), 'timeout')
	fakeload.hide()
	advance_area()
	input_handler.unblock_screen()
	hide_combat_curtain()

func advance_area():
#	$AdvConfirm.visible = false
	var areadata = Explorationdata.areas[area]
	var areastate = state.areaprogress[area]
	#2add generic scene check
	assert(areastate.stage <= areadata.stages, "advance_area() made on unexistant stage")
	if areadata.enemies.has(areastate.stage):
		var stagedata = areadata.enemies[areastate.stage]
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
#		elif stagedata.has('scene'):
#			#fixed scene
#			if state.OldEvents.has(stagedata.scene) and events.events[stagedata.scene].onetime:
#				areastate.stage += 1
#				advance_area()
#			else:
#				#2move to globals method
#				input_handler.OpenClose(input_handler.scene_node)
#				input_handler.scene_node.play_scene(stagedata.scene)
#
#				yield(input_handler.scene_node, "scene_end")
#				advance_check()
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
		if globals.play_scene(scene):
#			yield(input_handler.scene_node, "scene_end")
			yield(input_handler.scene_node, "EventFinished")
	if location != 'mission': open_explore()
	else: hide()
	if areadata.has('events') and areadata.events.has("on_complete_seq"):
		var seq_id = areadata.events.on_complete_seq
		if state.check_sequence(seq_id):
			var output = globals.run_seq(seq_id)
			if output == variables.SEQ_SCENE_STARTED :
				yield(input_handler.scene_node, "EventOnScreen")
	hide_combat_curtain()

func show_combat_curtain(duration :float = 0.0):
	var curtains = input_handler.curtains
	if curtains == null: return
	if duration > 0.0:
		curtains.show_anim(variables.CURTAIN_BATTLE, duration)
	else:
		curtains.show_anim(variables.CURTAIN_BATTLE)

func hide_combat_curtain(duration :float = 0.0):
	var curtains = input_handler.curtains
	if curtains == null: return
	if duration > 0.0:
		curtains.hide_anim(variables.CURTAIN_BATTLE, duration)
	else:
		curtains.hide_anim(variables.CURTAIN_BATTLE)


func combat_finished(value, do_advance :bool):
	if value:
		advance_check(do_advance)#combat_win
	else:
		combat_loose()


func combat_loose():
	hide_combat_curtain()
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

func has_auto_advance() ->bool:
	if !area: return false
	var areadata = Explorationdata.areas[area]
	return (areadata.has("auto_advance") and areadata.auto_advance)

func is_last_stage() ->bool:
	return (get_area_stage() == get_area_stage_num())

func advance_check(do_advance :bool = false):
	var areadata = Explorationdata.areas[area]
	var areastate = state.areaprogress[area]
	#2add generic scene check
	if is_last_stage():
		finish_area()
		return
	
	areastate.stage += 1
#	if areadata.stagedenemies.has(areastate.stage) and areadata.stagedenemies[areastate.stage].has('scene'):
#		advance_area()
	var playing_scene = false
	if areadata.events.has("after_fight_%d" % (areastate.stage - 1)):
		var scene = areadata.events["after_fight_%d" % (areastate.stage - 1)]
		playing_scene = globals.play_scene(scene)
		if playing_scene:
			yield(input_handler.scene_node, "EventOnScreen")
	hide_combat_curtain()
	if has_auto_advance() or do_advance:
		if playing_scene:
			yield(input_handler.scene_node, "AllEventsFinished")
		advance_area()
	else:
		build_area_description()
#		if !playing_scene:
#			$AdvConfirm.visible = true

#func adv_confirm():
#	advance_area()
#
#func adv_decline():
#	$AdvConfirm.visible = false


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

func can_hide() ->bool:
	return can_escape()

func can_escape() ->bool:
	if area == null:
		return true
	var areadata = Explorationdata.areas[area]
	return !(areadata.has('no_escape') and areadata.no_escape)

func press_char_btn(pressed_btn :BaseButton):
	unpress_char_btn()
	pressed_char_btn = pressed_btn
	pressed_btn.press()

func unpress_char_btn():
	if pressed_char_btn != null:
		pressed_char_btn.unpress()
		pressed_char_btn = null

func get_selected_char():
	if pressed_char_btn == null:
		return null
	return pressed_char_btn.get_char_data()

func get_pressed_char_btn():
	return pressed_char_btn

func has_pressed_char_btn() ->bool:
	return (pressed_char_btn != null)
