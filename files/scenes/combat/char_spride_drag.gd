extends TextureRect

var dragdata = {type = 'character', id = ''}

func get_drag_data(position):
	dragdata.id = get_parent().name
	var hero = state.heroes[dragdata.id]
	if hero.acted: return null
	input_handler.combat_node.activate_swap()
	var spr = TextureRect.new()
	spr.texture = hero.portrait_circle()
	set_drag_preview(spr)
	return dragdata

