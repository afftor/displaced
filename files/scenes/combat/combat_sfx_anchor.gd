extends Control

var animation_node

func process_sfx(code):
	var data 
	if code.begins_with('anim_'):
		data = {node = self, time = input_handler.combat_node.turns,type = 'default_animation', slot = 'sprite2', params = {animation = code.trim_prefix('anim_')}}
	elif code.begins_with('sfx_'):
		data = {node = self, time = input_handler.combat_node.turns, type = 'default_sfx', slot = 'SFX', params = {animation = code.trim_prefix('sfx_')}}
	else:
		data = {node = self, time = input_handler.combat_node.turns, type = code, slot = 'SFX', params = {}}
	animation_node.add_new_data(data)
