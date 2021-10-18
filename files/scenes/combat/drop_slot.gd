extends TextureRect

export var pos = 0

var active = false

func can_drop_data(position, data):
	if data.type != 'character': return false
	return active


func drop_data(position, data):
	input_handler.combat_node.move_hero(data.id, pos)


func set_active():
	active = true
	visible = true

func set_inactive():
	active = false
	visible = false
