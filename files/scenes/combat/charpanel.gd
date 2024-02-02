extends Control
#stub.
var ch_id = ""
const panel_bottom_margin = 14
onready var container = $VBoxContainer

func _ready():
	var template = container.get_node('template')
	for resist_type in variables.resistlist + variables.status_list:
		var new_node = template.duplicate()
		var resist_data = variables.get_resist_data(resist_type)
		container.add_child(new_node)
		new_node.name = resist_type
		new_node.get_node('ResistIcon').set_resist_type(resist_type)
		new_node.get_node('Label').text = tr(resist_data.name)
	template.queue_free()
	container.connect("item_rect_changed", self, "on_container_rect_changed")

func on_container_rect_changed() ->void:
	rect_size.y = (container.rect_position.y
		+ container.rect_size.y
		+ panel_bottom_margin)

#func build_for_hero(hero):
#	ch_id = hero

func build_for_fighter(fighter):
	ch_id = fighter
#	$Label.text = ""
	var person = state.heroes[ch_id]
	$icon.texture = person.combat_portrait()
	var data :Dictionary = person.get_resists().duplicate()#in fact get_resists() return unique dict for now, but it's better to duplicate it once more in case of future changes
	data.merge(person.get_s_resists())
	for container in $VBoxContainer.get_children():
		if (!state.is_resist_unlocked(container.name)
				or !data.has(container.name)):
			container.hide()
		else:
			container.show()
			container.get_node("ResistIcon").update_value(
				data[container.name], "%.1f")
#	for res in data:
#		$Label.text += "%s: %.1f\n" % [res, data[res]]
