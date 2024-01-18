extends TextureButton

signal pressed_lmb
signal pressed_rmb

func can_drop_data(position, data):
	if data.type != 'character': return false
	return true

func drop_data(position, data):
	input_handler.combat_node.reserve_hero(data.id)

func _pressed():
	#mind that "_released" func will only work while button has corresponding action_mode
	if Input.is_action_just_released("LMB"):
		emit_signal("pressed_lmb")
	elif Input.is_action_just_released("RMB"):
		emit_signal("pressed_rmb")

func gray_out():
	modulate = Color(0.6, 0.6, 0.6, 1)

func gray_out_undo():
	modulate = Color(1, 1, 1, 1)
