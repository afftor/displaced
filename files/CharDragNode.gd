extends TextureButton

var parent_node
var dragdata
export var pos = 0
var just_droped = false


#signal signal_RMB
#signal signal_RMB_release

#var RMBpressed = false


#func _ready():
#	connect("gui_input", self, "_on_Button_gui_input")
#	connect("signal_RMB_release", self, "rclick")


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		just_droped = false
		match event.button_index:
			BUTTON_LEFT:
				if parent_node.has_pressed_char_btn():
					if parent_node.get_pressed_char_btn() == self:
						parent_node.unpress_char_btn()
						#must avoid PositionChanged signal here, for drag to work
					else:
						drop_data(null, parent_node.get_selected_char())
						#parent_node unpresses all buttons on PositionChanged signal
				elif dragdata != null:#empty slots are unclickable so as undragable
					parent_node.press_char_btn(self)
#				emit_signal("signal_LMB", position)
			BUTTON_RIGHT:
				rclick()
#				emit_signal("signal_RMB_release")
#				emit_signal("signal_RMB")


func get_drag_data(position):
	if dragdata == null or just_droped: 
		return null
	parent_node.show_screen()
	parent_node.press_char_btn(self)
	var container = Control.new()
	var drag_item = self.duplicate()
	container.add_child(drag_item)
	drag_item.rect_position = - drag_item.rect_size * 0.5
	set_drag_preview(container)
	return dragdata
 

func can_drop_data(position, data):
	return true


func drop_data(position, data):
	if data == null:#drag empty slot
		#practically impossible
		return
	
	if pos == 0:#drag char to reserve (dragdata can't be null)
		var drag_char = state.heroes[data]
		if drag_char.position != 0:#draged char in party
			if data == dragdata:#drag to self
				drag_char.position = null
			else:#drag to another char
				switch_char(data, dragdata)
	elif dragdata == null: #drag char onto empty slot
		state.heroes[data].position = pos
	elif dragdata != data: #drag char onto another char
		switch_char(data, dragdata)
	input_handler.emit_signal("PositionChanged")
	just_droped = true

func switch_char(data1, data2):
	var char1 = state.heroes[data1]
	var char2 = state.heroes[data2]
	var pos1 = char1.position
	char1.position = char2.position
	char2.position = pos1


func press():
	toggle_mode = true
	pressed = true
	$name.set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
	$level.set("custom_colors/font_color", variables.hexcolordict.highlight_blue)

func unpress():
	pressed = false
	toggle_mode = false
	$name.set("custom_colors/font_color", variables.hexcolordict.light_grey)
	$level.set("custom_colors/font_color", variables.hexcolordict.light_grey)

func rclick():
	if dragdata == null: return
	parent_node.show_info(dragdata)

func get_char_data():
	return dragdata
