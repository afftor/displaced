extends TextureButton

func can_drop_data(position, data):
	if data.type != 'character': return false
	return true

func drop_data(position, data):
	input_handler.combat_node.reserve_hero(data.id)
