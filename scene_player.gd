extends Control

func _ready() -> void:
	$Button.disabled = true
	$Button.connect("pressed", self, "button_pressed")
	
	$ItemList.clear()
	for i in $TextSystem.scenes_map.keys():
		$ItemList.add_item(i)
	
	yield($ItemList, "item_selected")
	$Button.disabled = false

func button_pressed() -> void:
	$TextSystem.show()
	$TextSystem.play_scene($ItemList.get_item_text($ItemList.get_selected_items()[0]))
