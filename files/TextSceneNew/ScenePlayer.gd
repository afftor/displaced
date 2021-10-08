extends Tabs

func _ready() -> void:
	$ItemList.clear()
	for i in $TextSystem.scenes_map.keys():
		$ItemList.add_item(i)

	yield($ItemList, "item_selected")
	$Button.disabled = false


func play_scene(scn_name: String, replay_mode: bool) -> void:
	$"..".current_tab = 0
#	$TextSystem.show()
	input_handler.OpenClose($TextSystem)
	$TextSystem.replay_mode = replay_mode
	$TextSystem.play_scene(scn_name)
#	yield($TextSystem, "scene_end")
	yield(input_handler,"EventFinished")

func preload_scene(scn_name: String) -> void:
	$TextSystem.preload_scene(scn_name)

func _on_Button_pressed() -> void:
	play_scene($ItemList.get_item_text($ItemList.get_selected_items()[0]), false)

func _on_Button_pressed_1() -> void:
	play_scene($ItemList.get_item_text($ItemList.get_selected_items()[0]), true)
