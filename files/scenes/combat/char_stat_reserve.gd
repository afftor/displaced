extends TextureButton

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
