extends Node

#defoult struct for button {
#	obj = Node, sig = String,
#	parent_obj = Node} this is for dynamic buttons.
#parent_obj must have get_tutorial_button(button_name :String)->Node implementation
var tutorial_buttons = {
	skill = {},
	enemy = {},
	character = {},
	char_reserve = {},
	townhall = {},
	town_upgrade = {},
	exploration_loc = {},
	missions = {},
	bridge = {},
}

var tutorials_data = {
	skill_usage = {
		buttons = ["skill", "enemy"],
		message = "TUTORIAL_SKILL_USAGE"
	},
	select_character = {
		buttons = ["character"],
		message = "TUTORIAL_SELECT_CHARACTER"
	},
	elemental_weaknesses = {
		no_auto_close = true,
		message = "TUTORIAL_ELEMENTAL_WEAKNESSES"
	},
	swapping_characters = {
		buttons = ["char_reserve"],
		message = "TUTORIAL_SWAPPING_CHARACTERS"
	},
	building_upgrades = {
		buttons = ["townhall", "town_upgrade"],
		message = "TUTORIAL_BUILDING_UPGRADES"
	},
	exploration_menu = {
		buttons = ["bridge", "exploration_loc", "missions"],
		delay = {"exploration_loc" : 0.7, "missions" : 0.7},
		message = "TUTORIAL_EXPLORATION_MENU"
	},
}

var scenarios = {
	first_battle = "first_battle_connect",
	second_battle = "second_battle_connect",
	party_battle = "party_battle_connect"
}
var cur_scenarios = {}

var scene_tutorial :PackedScene
func load_scene_if_notyet() ->void:
	if scene_tutorial != null : return
	scene_tutorial = load("res://files/scenes/tutorial.tscn")

func obj_is_button(obj :Node, sig :String) ->bool:
	return (obj.get('rect_global_position') != null
		and obj.get('rect_size') != null
		and obj.has_signal(sig))

func register_static_button(id :String, obj :Node, sig :String) ->void:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to register nonexistent button")
	assert(obj_is_button(obj, sig), "tutorial_core is tring to register nonbutton as a button")
	var button = tutorial_buttons[id]
	button['obj'] = obj
	button['sig'] = sig

func register_dynamic_button(id :String, obj :Node, sig :String) ->void:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to register nonexistent button")
	assert(obj.has_method('get_tutorial_button'), "tutorial_core is tring to register unacceptable dynamic button")
	var button = tutorial_buttons[id]
	button['parent_obj'] = obj
	button['sig'] = sig

func refresh_dynamic_button(id :String) ->void:
	var button = tutorial_buttons[id]
	if !button.has('parent_obj'): return
	button['obj'] = button.parent_obj.get_tutorial_button(id)
	assert(obj_is_button(button.obj, button.sig), "in tutorial_core dynamic button returns nonbutton")

func get_button_pos(id :String) ->Vector2:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to get nonexistent button")
	refresh_dynamic_button(id)
	return tutorial_buttons[id].obj.rect_global_position

func get_button_size(id :String) ->Vector2:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to get nonexistent button")
	refresh_dynamic_button(id)
	return tutorial_buttons[id].obj.rect_size

func connect_to_button(id :String, obj :Node, method :String) ->void:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to connect to nonexistent button")
	refresh_dynamic_button(id)
	var button = tutorial_buttons[id]
	var args_num = -1
	var signals_list = button.obj.get_signal_list()
	for sig in signals_list:
		if sig.name == button.sig:
			args_num = sig.args.size()
			break
	assert(args_num > -1, "tutorial_core connect_to_button: args_num not found")
	assert(args_num < 2, "tutorial_core connect_to_button: too many args (%s)" % args_num)
	#quite stupid stuff with signals, that can carry an argument, which is hard to predict
	#it's better to find some another way do deal with it
	if args_num == 0:
		button.obj.connect(button.sig, obj, method, [], CONNECT_ONESHOT)
	elif args_num == 1:
		button.obj.connect(button.sig, self, 'signal_resender', [obj, method], CONNECT_ONESHOT)

func signal_resender(_needles_arg, obj :Node, method :String):
	obj.call(method)

func start_tut(id :String) ->void:
	assert(tutorials_data.has(id), "tutorial_core is tring to start nonexistent tutorial")
	if is_tutorial_disabled(): return
	
	load_scene_if_notyet()
	var new_tut :Control = scene_tutorial.instance()
	get_tree().get_root().add_child(new_tut)
	var tut :Dictionary = tutorials_data[id]
	var buttons :Array
	var delay :Dictionary
	if tut.has("buttons") :
		buttons = tut.buttons
	else: buttons = []
	if tut.has("delay") :
		delay = tut.delay
	else: delay = {}
	var no_auto_close :bool = (tut.has("no_auto_close") and tut.no_auto_close)
	new_tut.show_tut(
		tut.message,
		buttons,
		delay,
		no_auto_close
	)

func scenario_connect(scenario_id :String, obj :Object) ->void:
	assert(scenarios.has(scenario_id), "tutorial_core is tring to start nonexistent scenario")
	assert(!cur_scenarios.has(scenario_id), "tutorial_core is tring to restart active scenario")
	if is_tutorial_disabled(): return
	
	cur_scenarios[scenario_id] = {obj = obj}
	call(scenarios[scenario_id], obj)

func is_tutorial_disabled() ->bool:
	return globals.globalsettings.disable_tutorial



#-------first_battle scenario----------
func first_battle_connect(battle_node :Object) ->void:
	cur_scenarios.first_battle.turns = 0
	battle_node.connect("turn_started", self, "first_battle_signal_turn")
	battle_node.connect("player_ready", self, "first_battle_signal_ready")
	battle_node.connect("combat_ended", self, "first_battle_disconnect")

func first_battle_signal_turn() ->void:
	cur_scenarios.first_battle.turns += 1
	var turns = cur_scenarios.first_battle.turns
	if turns > 2:
		first_battle_disconnect()

func first_battle_signal_ready() ->void:
	var scenario = cur_scenarios.first_battle
	if scenario.turns == 1 and !scenario.has('skill_usage'):
		scenario.skill_usage = true
		start_tut("skill_usage")
	elif scenario.turns == 2 and !scenario.has('select_character'):
		scenario.select_character = true
		start_tut("select_character")

func first_battle_disconnect() ->void:
	if !cur_scenarios.has("first_battle"):
		return
	var battle_node = cur_scenarios.first_battle.obj
	battle_node.disconnect("turn_started", self, "first_battle_signal_turn")
	battle_node.disconnect("player_ready", self, "first_battle_signal_ready")
	battle_node.disconnect("combat_ended", self, "first_battle_disconnect")
	cur_scenarios.erase("first_battle")

#-------------------second_battle scenario
func second_battle_connect(battle_node :Object) ->void:
	battle_node.connect("turn_started", self, "second_battle_signal_turn", [], CONNECT_ONESHOT)

func second_battle_signal_turn() ->void:
	start_tut("elemental_weaknesses")
	cur_scenarios.erase("second_battle")

#-------------------party_battle scenario
func party_battle_connect(battle_node :Object) ->void:
	battle_node.connect("turn_started", self, "party_battle_signal_turn", [], CONNECT_ONESHOT)

func party_battle_signal_turn() ->void:
	start_tut("swapping_characters")
	cur_scenarios.erase("party_battle")
