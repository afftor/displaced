#class_name PendingScenesOutlineIndicator
extends PendingScenesIndicator

export(Material) var outline_material

var old_material = null
var indicator_on :bool = false

func _on_scene_list_update():
	if !state.pending_scenes.empty(): 
		if !indicator_on:
			old_material = visual_node.material
			visual_node.material = outline_material
			indicator_on = true
	else:
		if indicator_on:
			visual_node.material = old_material
			indicator_on = false
