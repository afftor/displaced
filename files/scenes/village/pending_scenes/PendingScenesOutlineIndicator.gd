#class_name PendingScenesOutlineIndicator
extends PendingScenesIndicator

export(Material) var outline_material


func _on_scene_list_update():
	if !state.pending_scenes.empty(): 
		visual_node.material = outline_material
	else:
		visual_node.material = null
