extends Object

var animation_node
var animated_obj

func _init(parent = self):
	animated_obj = parent

func set_animation_node(anim):
	animation_node = anim

func prepare_data(code):
	var data = {
		node = animated_obj,
		time = input_handler.combat_node.turns
	}
	if code.begins_with('anim_'):
		data.type = 'default_animation'
		data.slot = 'sprite2'
		data.params = {animation = code.trim_prefix('anim_')}
	elif code.begins_with('sfx_'):
		data.type = 'default_sfx'
		data.slot = 'SFX'
		data.params = {animation = code.trim_prefix('sfx_')}
	else:
		data.type = code
		data.slot = 'SFX'
		data.params = {}
	return data

func process_sfx(code):
	animation_node.add_new_data(prepare_data(code))

func process_sfx_dict(dict):
	var data = prepare_data(dict.code)
	var dict_params = dict.duplicate()
	if data.params.has("animation"):
		dict_params.animation = data.params.animation
	data.params = dict_params
	animation_node.add_new_data(data)



