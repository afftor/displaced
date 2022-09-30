extends TextureRect

export var pos = 0

var active = false

func can_drop_data(position, data):
	if data.type != 'character': return false
	return active


func drop_data(position, data):
	var newchar = state.heroes[data.id]
	if newchar.position == null:
		input_handler.combat_node.move_hero(data.id, pos)
	else:
		input_handler.combat_node.swap_heroes(data.id, pos)


func set_active():
	active = true
	visible = true

func set_inactive():
	active = false
	visible = false
