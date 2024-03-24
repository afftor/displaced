extends Control

onready var container = $VBoxContainer

func _ready():
	container.connect("resized", self, "size_up")

func size_up():
	var rect = container.get_rect()
	rect_size.y = rect.end.y + 10;

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
	container.get_node("level").text = tr("LEVEL") + " %d" % itemdata.level
	container.get_node("desc").text = itemdata.description
	container.get_node("divider").hide()
	container.get_node("next_level").hide()
	container.get_node("next_desc").hide()

func build_upgrade_tooltip(hero_id, slot):
	build_slot_tooltip(hero_id, slot)
	container.get_node("divider").show()
	var next_level = container.get_node("next_level")
	var hero = state.heroes[hero_id]
	var upgrade_data = hero.get_item_upgrade_data(slot)
	if !upgrade_data:
		next_level.text = tr("MAXLEVEL")
		next_level.show()
		return
	next_level.text = tr("NEXTLEVEL") + " %d" % upgrade_data.level
	next_level.show()
	var next_desc = container.get_node("next_desc")
	next_desc.text = upgrade_data.description
	next_desc.show()
