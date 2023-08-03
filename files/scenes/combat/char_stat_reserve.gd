extends TextureButton

signal pressed_lmb
signal pressed_rmb

var dragdata = {type = 'character', id = ''}

func get_drag_data(position):
	if !input_handler.combat_node.allowaction: return null
	dragdata.id = name.trim_suffix('_reserve')
	var hero = state.heroes[dragdata.id]
	if hero.acted: return null
	input_handler.combat_node.activate_swap()
	var spr = TextureRect.new()
	spr.texture = hero.portrait_circle()
	set_drag_preview(spr)
	return dragdata

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
