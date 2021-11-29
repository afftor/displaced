extends TextureRect
var parent_node


func can_drop_data(position, data):
	return true

func drop_data(position, data):
	parent_node.build_party()
