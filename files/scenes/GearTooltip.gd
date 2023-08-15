extends Control


func _ready():
	pass # Replace with function body.


func showup(hero_id, slot, position):
	if is_visible_in_tree():
		hide()
	build_slot_tooltip(hero_id, slot)
	set_global_position(position)
	show()

func build_slot_tooltip(hero_id, slot):
#	var itemdata = Items.hero_items_data["%s_%s" % [hero_id, slot]]
	var hero = state.heroes[hero_id]
	var itemdata = hero.get_item_data(slot)
	$level.text = "Level %d\n" % itemdata.level
	$desc.text = itemdata.description

func build_upgrade_tooltip(hero_id, slot):
	var hero = state.heroes[hero_id]
	var itemdata = hero.get_item_upgrade_data(slot)
	if !itemdata:
		$level.text = "Current Level is maximum"
		$desc.text = ""
		return
	$level.text = "Next level %d\n" % itemdata.level
	$desc.text = itemdata.description
