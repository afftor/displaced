extends Tabs

func _ready() -> void:
	$ItemList.clear()
	for i in $TextSystem.scenes_map.keys():
		$ItemList.add_item(i)
	
	yield($ItemList, "item_selected")
	$Button.disabled = false


func play_scene(scn_name: String) -> void:
	$"..".current_tab = 0
	$TextSystem.show()
	$TextSystem.play_scene(scn_name)
	yield($TextSystem, "scene_end")

func preload_scene(scn_name: String) -> void:
	$TextSystem.preload_scene(scn_name)

func _on_Button_pressed() -> void:
	play_scene($ItemList.get_item_text($ItemList.get_selected_items()[0]))
