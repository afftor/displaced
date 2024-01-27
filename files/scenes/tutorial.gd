extends Control

onready var node_text = $Panel/RichTextLabel
onready var node_close = $Panel/Button
onready var node_disable = $Panel/CheckBox
onready var node_highlighter = $highlighter
onready var node_panel = $Panel

onready var screen_top = $highlighter/screen_top
onready var screen_right = $highlighter/screen_right
onready var screen_bottom = $highlighter/screen_bottom
onready var screen_left = $highlighter/screen_left

var cur_button_num :int = -1
var cur_button_seq :Array
var cur_delay :Dictionary
var auto_close :bool = true
var panel_has_best_pos :bool = false

var panel_positions = []

func _ready() ->void:
	#panel_positions
	var panel_margin = 40
	var bottom_y = rect_size.y - panel_margin - node_panel.rect_size.y
	var right_x = rect_size.x - panel_margin - node_panel.rect_size.x
#	panel_positions.append(node_panel.rect_position)#top-center
#	panel_positions.append(Vector2(
#		node_panel.rect_position.x, bottom_y))#bottom-center
	panel_positions.append(Vector2(
		right_x, panel_margin))#top-right
	panel_positions.append(Vector2(
		panel_margin, panel_margin))#top-left
	panel_positions.append(Vector2(
		right_x, bottom_y))#bottom-right
	panel_positions.append(Vector2(
		panel_margin, bottom_y))#bottom-left

	node_close.connect("pressed", self, "stop_tut")
	node_disable.connect("pressed", self, "disable_tutorial")

func show_tut(text :String, buttons_seq :Array = [], delay :Dictionary = {}, no_auto_close :bool = false) ->void:
	node_text.text = tr(text)
	auto_close = !no_auto_close
#	node_close.visible = no_auto_close
	node_panel.rect_position = panel_positions[0]
	panel_has_best_pos = false
	
	if !buttons_seq.empty():
		mouse_filter = MOUSE_FILTER_IGNORE
#		set_process_input(true)
		cur_button_seq = buttons_seq
		cur_button_num = -1
		cur_delay = delay
		
		for panel_pos in panel_positions:
			node_panel.rect_position = panel_pos
			var has_intersections = false
			for btn_id in cur_button_seq:
				var btn_ready = TutorialCore.refresh_dynamic_button(btn_id)
				if !btn_ready:
					has_intersections = true
					break
				var highlighter_rect = Rect2(
						TutorialCore.get_button_pos(btn_id), 
						TutorialCore.get_button_size(btn_id))
				if node_panel.get_rect().intersects(highlighter_rect):
					has_intersections = true
					break
			if !has_intersections:
				panel_has_best_pos = true
				break
		
		highlight_next_button()
	else:
		mouse_filter = MOUSE_FILTER_STOP
#		set_process_input(false)
		node_highlighter.hide()
	show()

func highlight_next_button() ->void:
	cur_button_num += 1
	if cur_button_seq.empty() or cur_button_num >= cur_button_seq.size() :
		if auto_close:
			stop_tut()
		return
	
	var btn_id = cur_button_seq[cur_button_num]
	if cur_delay.has(btn_id):
		mouse_filter = MOUSE_FILTER_STOP
		node_highlighter.rect_position = Vector2(-1,-1)
		node_highlighter.rect_size = Vector2(0,0)
		calculate_screen()
		yield(get_tree().create_timer(cur_delay[btn_id]), 'timeout')
		mouse_filter = MOUSE_FILTER_IGNORE
	
	TutorialCore.refresh_dynamic_button(btn_id)
	node_highlighter.rect_position = TutorialCore.get_button_pos(btn_id)
	node_highlighter.rect_size = TutorialCore.get_button_size(btn_id)
	calculate_screen()
	node_highlighter.show()
	TutorialCore.connect_to_button(btn_id, self, 'highlight_next_button')
	
	if !panel_has_best_pos:
		var panel_pos_found = false
		var highlighter_rect = node_highlighter.get_rect()
		for panel_pos in panel_positions:
			node_panel.rect_position = panel_pos
			if !node_panel.get_rect().intersects(highlighter_rect):
				panel_pos_found = true
				break
		if !panel_pos_found:
			node_panel.rect_position = panel_positions[0]
			assert(false, "tutorial cann't find a place for panel")
#			node_close.show()

#delete with time, if not nedded
#func _input(event) ->void:
#	if (event.is_action_pressed("LMB") and
#			node_highlighter.get_rect().has_point(event.position)):
#		call_deferred("highlight_next_button")#so that event could end the processing

func stop_tut() ->void:
	if !cur_button_seq.empty():
		cur_button_seq = []
		cur_button_num = -1
	hide()
	queue_free()

func calculate_screen() ->void:
	var highlighter_rect = node_highlighter.get_rect()
	screen_top.rect_global_position = Vector2(0, 0)
	screen_top.rect_size.x = rect_size.x
	screen_top.rect_size.y = highlighter_rect.position.y
	screen_bottom.rect_global_position = Vector2(
		0, highlighter_rect.end.y)
	screen_bottom.rect_size.x = rect_size.x
	screen_bottom.rect_size.y = rect_size.y - highlighter_rect.end.y
	screen_left.rect_global_position = Vector2(
		0, highlighter_rect.position.y)
	screen_left.rect_size.x = highlighter_rect.position.x
	screen_left.rect_size.y = highlighter_rect.size.y
	screen_right.rect_global_position = Vector2(
		highlighter_rect.end.x, highlighter_rect.position.y)
	screen_right.rect_size.x = rect_size.x - highlighter_rect.end.x
	screen_right.rect_size.y = highlighter_rect.size.y


func disable_tutorial():
	globals.globalsettings.disable_tutorial = node_disable.pressed

#--------------------legacy------------
#func blink():
#	var tween = input_handler.GetTweenNode(self)
#	tween.start()
#	tween.interpolate_property(self, 'self_modulate', Color(1,1,1,0.5), Color(1,1,1,0.8), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,1)
#	tween.interpolate_property(self, 'self_modulate', Color(1,1,1,0.8), Color(1,1,1,0.5), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,2)
#	tween.interpolate_property(self, 'self_modulate', Color(1,1,1,0.5), Color(1,1,1,0.8), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,3)
#	tween.interpolate_property(self, 'self_modulate', Color(1,1,1,0.8), Color(1,1,1,0.5), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,4)
#	tween.interpolate_property(self, 'self_modulate', Color(1,1,1,0.5), Color(1,1,1,0.8), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,5)
#	tween.interpolate_property(self, 'self_modulate', Color(1,1,1,0.8), Color(1,1,1,0.5), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,6)

#var tutorialdict = {
#	tutorial1 = {
#		text = 'Visit the Market by clicking on it. ',
#		trigger = 'BuildingEntered',
#		mission = 'market',
#		check = null,
#		completioneffects = [{type = 'nexttutor', value = 'tutorial2'}]
#	},
#	tutorial2 = {
#		text = "Assign worker to woodcutting. Open the worker menu. Select Goblin Worker. Select 'Harvest Lumber', then Confirm.",
#		trigger = "WorkerAssigned",
#		check = null,
#		completioneffects = [{type = 'nexttutor', value = 'tutorial3'}]
#	},
#	tutorial3 = {
#		text = "Speed up the game to make time fly faster. Use Speed buttons at the top left corner.",
#		trigger = "SpeedChanged",
#		mission = 10,
#		check = null,
#		completioneffects = [{type = 'nexttutor', value = 'tutorial4'}]
#	},
#	tutorial4 = {
#		text = "Collect 5 Wood to progress.",
#		trigger = "MaterialObtained",
#		check = 'state',
#		checkvalue = {type = 'has_material', material = 'wood', value = 5, operant = 'gte'},
#		completioneffects = [{type = 'nexttutor', value = 'tutorial5'}]
#	},
#	tutorial5 = {
#		text = "Purchase the Bridge upgrade to proceed. You can unlock upgrades at Town Hall.",
#		trigger = "UpgradeUnlocked",
#		check = 'state',
#		checkvalue = {type = 'has_upgrade', name = 'bridge', value = 1}
#	},
#
#}
