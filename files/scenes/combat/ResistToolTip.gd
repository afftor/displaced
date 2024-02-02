extends Control

onready var grid_node :CanvasItem = $GridContainer

func _ready():
	var template = grid_node.get_node('template')
	for resist_type in variables.resistlist + variables.status_list:
		var new_node = template.duplicate()
		grid_node.add_child(new_node)
		new_node.name = resist_type
		new_node.set_resist_type(resist_type)
	template.queue_free()
	grid_node.connect("item_rect_changed", self, "on_grid_rect_changed")

func on_grid_rect_changed() ->void:
	rect_min_size = grid_node.rect_size + grid_node.rect_position * 2


func show_up(char_id: String) ->void:
	var chara = state.heroes[char_id]
	var data :Dictionary = chara.get_resists().duplicate()#in fact get_resists() return unique dict for now, but it's better to duplicate it once more in case of future changes
	data.merge(chara.get_s_resists())
	var show_me :bool = false
	for resist_node in grid_node.get_children():
		var resist_type = resist_node.get_resist_type()
		if (!data.has(resist_type)
				or data[resist_type] == 0
				or !state.is_resist_unlocked(resist_type)):
			resist_node.hide()
		else:
			resist_node.update_value(data[resist_type], "+")
			resist_node.show()
			show_me = true
	if show_me:
		show()


