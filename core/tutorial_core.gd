extends Node

var tutorial_buttons = {
	skill = {pos = Vector2(), size = Vector2()},
	enemy = {pos = Vector2(), size = Vector2()},
	character = {pos = Vector2(), size = Vector2()},
	char_reserve = {pos = Vector2(), size = Vector2()},
	townhall = {pos = Vector2(), size = Vector2()},
	town_upgrade = {pos = Vector2(), size = Vector2()},
	exploration_loc = {pos = Vector2(), size = Vector2()},
	missions = {pos = Vector2(), size = Vector2()},
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
		buttons = ["exploration_loc", "missions"],
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


func register_button(id :String, pos :Vector2, size :Vector2) ->void:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to register nonexistent button")
#	print("!!! register_button %s %s %s" %[id,String(pos),String(size)])
	var button = tutorial_buttons[id]
	button.pos = pos
	button.size = size

func get_button_pos(id :String) ->Vector2:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to get nonexistent button")
	return tutorial_buttons[id].pos

func get_button_size(id :String) ->Vector2:
	assert(tutorial_buttons.has(id), "tutorial_core is tring to get nonexistent button")
	return tutorial_buttons[id].size

func start_tut(id :String) ->void:
	assert(tutorials_data.has(id), "tutorial_core is tring to start nonexistent tutorial")
	load_scene_if_notyet()
	var new_tut :Control = scene_tutorial.instance()
	get_tree().get_root().add_child(new_tut)
	var tut :Dictionary = tutorials_data[id]
	var buttons :Array
	if tut.has("buttons") :
		buttons = tut.buttons
	else:
		buttons = []
	var no_auto_close :bool = (tut.has("no_auto_close") and tut.no_auto_close)
	new_tut.show_tut(
		tut.message,
		buttons,
		no_auto_close
	)

func scenario_connect(scenario_id :String, obj :Object) ->void:
	assert(scenarios.has(scenario_id), "tutorial_core is tring to start nonexistent scenario")
	assert(!cur_scenarios.has(scenario_id), "tutorial_core is tring to restart active scenario")
	cur_scenarios[scenario_id] = {obj = obj}
	call(scenarios[scenario_id], obj)

#-------first_battle scenario----------
func first_battle_connect(battle_node :Object) ->void:
	cur_scenarios.first_battle.turns = 0
	battle_node.connect("turn_started", self, "first_battle_signal_turn")
	battle_node.connect("combat_ended", self, "first_battle_disconnect")

func first_battle_signal_turn() ->void:
	cur_scenarios.first_battle.turns += 1
	var turns = cur_scenarios.first_battle.turns
	if turns == 1:
		start_tut("skill_usage")
	elif turns == 2:
		start_tut("select_character")
	elif turns > 2:
		first_battle_disconnect()

func first_battle_disconnect() ->void:
	if !cur_scenarios.has("first_battle"):
		return
	var battle_node = cur_scenarios.first_battle.obj
	battle_node.disconnect("turn_started", self, "first_battle_signal_turn")
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
