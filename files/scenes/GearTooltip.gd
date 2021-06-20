extends Panel

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
	var text = ""
	for i in range(1, 5):
		var text2 = "Level %d\n" % i
		text2 += itemdata.leveldata[i].lvldesc
		text2 += "\n"
		if hero.gear_level[slot] >= i:
			text2 = "[color=green]%s[/color]" % text2
		text += text2
	$RichTextLabel.bbcode_text = "[center]%s[/center]" % text
