class_name PendingScenesIndicator extends Node


export(NodePath) var visual

var visual_node: CanvasItem


func _ready():
	visual_node = get_node(visual)
	state.connect("pending_scenes_updated", self, "_on_scene_list_update")

func _on_scene_list_update():
	pass
