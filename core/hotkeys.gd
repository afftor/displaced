extends Reference
class_name HotkeysHandler

var actions = {
	hotkey_skill_1 = "SKILL_ATTACK",
	hotkey_skill_2 = "SKILL_PERSONAL1",
	hotkey_skill_3 = "SKILL_PERSONAL2",
	hotkey_skill_4 = "SKILL_PERSONAL3",
	hotkey_skill_5 = "SKILL_PERSONAL4",
	hotkey_skill_6 = "SKILL_DEFENCE",
	hotkey_skill_7 = "SKILL_PERSONAL5",
	hotkey_skill_8 = "SKILL_PERSONAL6",
	hotkey_skill_9 = "SKILL_PERSONAL7",
	hotkey_skill_10 = "SKILL_PERSONAL8",
}

func get_hotkey_as_text(hotkey :String) ->String:
	if !InputMap.has_action(hotkey):
		assert(false, "hotkeys trying to get unexistant hotkey")
		return "err"
	return InputMap.get_action_list(hotkey)[0].as_text()

func get_hotkey_default_as_text(hotkey :String) ->String:
	if !InputMap.has_action(hotkey):
		assert(false, "hotkeys trying to get unexistant hotkey")
		return "err"
	var event = ProjectSettings.get_setting("input/%s" % hotkey).events[0]
	return event.as_text()

func set_hotkey_for_node(node: Node, hotkey :String) ->void:
	if !node.has_node("hotkey"):
		assert(false, "hotkeys trying to set hotkey for node %s, but there is no lable" % node.name)
		return
	var hotkey_node = node.get_node("hotkey")
	hotkey_node.text = get_hotkey_as_text(hotkey)
	hotkey_node.show()

func disable_hotkey_for_node(node: Node) ->void:
	if !node.has_node("hotkey"):
		assert(false, "hotkeys trying to disable hotkey for node %s, but there is no lable" % node.name)
		return
	node.get_node("hotkey").hide()

func get_action_name(hotkey :String) ->String:
	if !actions.has(hotkey):
		assert(false, "hotkeys trying to get name of unexistant hotkey")
		return ""
	return tr(actions[hotkey])

#func is_exists(hotkey :String) ->bool:
#	return actions.has(hotkey)

func find_hotkey_by_scancode(scancode :int) ->String:
	for hotkey in actions:
		var event = InputMap.get_action_list(hotkey)[0]
		if event.scancode == scancode:
			return hotkey
	return ""

func remap_hotkey(hotkey :String, scancode :int):
	if !actions.has(hotkey) or !InputMap.has_action(hotkey):
		assert(false, "hotkeys trying to map unexistant hotkey")
		return
	InputMap.action_erase_events(hotkey)
	var new_event = InputEventKey.new()
	new_event.scancode = scancode
	InputMap.action_add_event(hotkey, new_event)

func serialize() ->Dictionary:
	var result = {}
	for hotkey in actions :
		var cur_scancode = InputMap.get_action_list(hotkey)[0].scancode
		if cur_scancode != get_default_scancode(hotkey):
			result[hotkey] = cur_scancode
	return result

func deserialize(scancodes :Dictionary):
	for hotkey in scancodes :
		if actions.has(hotkey):
			remap_hotkey(hotkey, scancodes[hotkey])

func to_default():
	InputMap.load_from_globals()

func get_default_scancode(hotkey :String) ->int:
	var event = ProjectSettings.get_setting("input/%s" % hotkey).events[0]
	return event.scancode
