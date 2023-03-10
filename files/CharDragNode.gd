extends TextureButton

var parent_node
var dragdata
export var pos = 0


signal signal_RMB
signal signal_RMB_release

var RMBpressed = false


func _input(event):
	if get_global_rect().has_point(get_global_mouse_position()):
		if event.is_pressed() and event.is_action("RMB"):
			emit_signal("signal_RMB")
			RMBpressed = true
	if event.is_action_released("RMB") && RMBpressed == true:
		emit_signal("signal_RMB_release")
		RMBpressed = false


func _ready():
	connect("signal_RMB_release", self, "rclick")

func get_drag_data(position):
	if dragdata == null: 
		return null
	parent_node.show_screen()
	press()
	set_drag_preview(self.duplicate())
	return dragdata
 

func can_drop_data(position, data):
	return true


func drop_data(position, data):
	if data == null:# and dragdata != null: #drag empty slot
#		var hero1 = state.heroes[dragdata]
#		var pos1 = pos
#		if pos1 == 0: pos1 = null
#		hero1.position = pos1
		pass 
	elif dragdata == null and data != null: #drag char onto empty slot
		var hero1 = state.heroes[data]
		var pos1 = pos
		if pos1 == 0: pos1 = null
		hero1.position = pos1
#	elif dragdata != null and data != null:
	elif dragdata != data: #drag char onto another char
		var hero1 = state.heroes[data]
		var pos1 = pos
		if pos1 == 0: pos1 = null
		var hero2 = state.heroes[dragdata]
		var pos2 = hero1.position
		hero1.position = pos1
		hero2.position = pos2
	elif pos == 0: #drag char on self upwards
		var hero1 = state.heroes[data]
		hero1.position = null
	else: #drag char on self downwards
		pass
	input_handler.emit_signal("PositionChanged")


func press():
	toggle_mode = true
	pressed = true
	$name.set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
	$level.set("custom_colors/font_color", variables.hexcolordict.highlight_blue)

func unpress():
	pressed = false
	toggle_mode = false
	if input_handler.if_mouse_inside(self):
		$name.set("custom_colors/font_color", variables.hexcolordict.light_grey)
		$level.set("custom_colors/font_color", variables.hexcolordict.light_grey)
	else:
		$name.set("custom_colors/font_color", variables.hexcolordict.dark_grey)
		$level.set("custom_colors/font_color", variables.hexcolordict.dark_grey)


func rclick():
	if dragdata == null: return
	parent_node.show_info(dragdata)
