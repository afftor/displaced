extends Tabs

func _ready() -> void:
	$EvMap.connect("state_update", self, "state_update")

func play_scene(scn_name: String) -> void:
	yield(get_tree().create_timer(0.5), "timeout")

func state_update(cstate: Array) -> void:
	$AvailActions.clear()
	$AvailScenes.clear()
	$Map.clear()
	for i in cstate:
		match i[0]:
			"scn":
				$AvailScenes.add_item(i[1])
			"bat":
				$AvailActions.add_item(i[0] + " " + i[1])
			"buy":
				$AvailActions.add_item(i[0] + " " + i[1])
			"sel":
				$Map.add_item(i[1])
			"wallet":
				$Wallet.value = i[1]
	
	if $AutoPlayScenes.pressed && $AvailScenes.get_item_count() > 0:
		yield(get_tree().create_timer(0.3), "timeout")
		_on_AvailScenes_item_activated(0)


func _on_Map_item_activated(index: int) -> void:
	var iname = $Map.get_item_text(index)
	$EvMap.ac_to_gets("sel", iname)
	$EvMap.make_a_step()

func _on_AvailScenes_item_activated(index: int) -> void:
	var iname = $AvailScenes.get_item_text(index)
	if $DoPlayScenes.pressed:
		yield($"../scene_player".play_scene(iname), \
											"completed")
		for dec in $"../scene_player/TextSystem".decisions:
			$EvMap.decisions.append(str(dec))
		$"..".current_tab = 1
	$EvMap.ac_to_gets("scn", iname)
	$EvMap.make_a_step()

func _on_AvailActions_item_activated(index: int) -> void:
	var iname = $AvailActions.get_item_text(index).split(" ")
	var type = iname[0]
	iname.remove(0)
	iname = iname.join(" ")
	$EvMap.ac_to_gets(type, iname)
	$EvMap.make_a_step()

func _on_Wallet_value_changed(value: float) -> void:
	$EvMap.wallet = int(value)
	$EvMap.make_a_step()


func _on_AutoPlayScenes_toggled(button_pressed: bool) -> void:
	if button_pressed: $EvMap.make_a_step()
