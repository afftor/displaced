extends TextureRect


func can_drop_data(position, data):
	return true

func drop_data(position, data):
	get_parent().activate_shades([])
	get_parent().hide_screen()
