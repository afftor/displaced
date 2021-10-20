extends TextureRect


func _ready():
	pass # Replace with function body.


func showup(hero_id, slot, position):
	if is_visible_in_tree():
		hide()
	build_slot_tooltip(hero_id, slot)
	set_global_position(position)
	show()

func build_slot_tooltip(hero_id, slot):
	var itemdata = Items.hero_items_data["%s_%s" % [hero_id, slot]]
	var hero = state.heroes[hero_id]
	input_handler.ClearContainer($VBoxContainer, ['level', 'desc', 'separator'])
	for i in range(1, 5):
		var text = input_handler.DuplicateContainerTemplate($VBoxContainer, 'level')
		text.text = "Level %d\n" % i
		var text2 = input_handler.DuplicateContainerTemplate($VBoxContainer, 'desc')
		text2.text = itemdata.leveldata[i].lvldesc
#		if hero.gear_level[slot] >= i:
#			text2 = "[color=green]%s[/color]" % text2
		if i != 4:
			var tmp = input_handler.DuplicateContainerTemplate($VBoxContainer, 'separator')
