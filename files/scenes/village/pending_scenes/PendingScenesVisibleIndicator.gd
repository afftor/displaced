class_name PendingScenesVisibleIndicator extends PendingScenesIndicator


func _on_scene_list_update():
	visual_node.visible = !state.pending_scenes.empty()

