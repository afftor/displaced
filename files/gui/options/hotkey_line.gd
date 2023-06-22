extends Control

export var hotkey :String

signal remap

func _ready():
	$remap.connect("pressed",self,"emit_signal",["remap", hotkey])
	update_me()

func update_me():
	var hotkeys = globals.get_hotkeys_handler()
	$name.text = hotkeys.get_action_name(hotkey)
	$default.text = hotkeys.get_hotkey_default_as_text(hotkey)
	$remap.text = hotkeys.get_hotkey_as_text(hotkey)
