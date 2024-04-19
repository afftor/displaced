extends "res://files/Close Panel Button/ClosingPanel.gd"

#var tabnames = {Audio = "AUDIO", Graphics = "GRAPHICS", Text = "TEXT"}
var menu_open_sound = "sound/menu_open"

onready var hotkeys_list = $TabContainer/Hotkeys/ScrollContainer/VBoxContainer
onready var remap_panel = $remap_panel
onready var locale_panel = $TabContainer/Text/locale
var remaping_hotkey :String = ""
var demaping_hotkey :String = ""
var hotkeys

func _ready():
	set_process_input(false)
	resources.preload_res(menu_open_sound)
	if resources.is_busy(): yield(resources, "done_work")

	for i in $TabContainer/Audio/VBoxContainer.get_children():
		i.get_node("HSlider").connect("value_changed", self, 'soundsliderchange',[i.name])
		i.get_node("CheckBox").connect('pressed', self, 'mutepressed', [i.get_node("CheckBox")])
#warning-ignore:return_value_discarded
	$TabContainer/Text/textspeed.connect("value_changed", self, 'textspeed')
#warning-ignore:return_value_discarded
	$TabContainer/Text/skipread.connect("pressed", self, 'pressedskipread')
	$TabContainer/Text/disabletut.connect("pressed", self, 'pressed_disable_tutorial')
	for locale in globals.localizations:
		assert(locale_panel.has_node(locale), "options screen has no %s locale checkbox" % locale)
		locale_panel.get_node(locale).connect("pressed", self, 'pressed_locale', [locale])
#warning-ignore:return_value_discarded
	$TabContainer/Graphics/fullscreen.connect("pressed",self,"togglefullscreen")
	$TabContainer/Game/forced.connect("pressed", self, "toggleforced")
#warning-ignore:return_value_discarded
	$close_button.connect("pressed",self,'close')
	var tabs = $TabContainer
	tabs.set_tab_title(0, tr('AUDIO'))
	tabs.set_tab_title(1, tr('GRAPHICS'))
	tabs.set_tab_title(2, tr('OPT_TEXT'))
	tabs.set_tab_title(3, tr('OPT_GAME'))
	tabs.set_tab_title(4, tr('HOTKEYS'))

	hotkeys = globals.get_hotkeys_handler()
	for remap_node in hotkeys_list.get_children():
		if remap_node.has_signal("remap"):
			remap_node.connect("remap",self,"remap_hotkey_start")
		if remap_node.name == "default" and remap_node.has_node("Button"):
			remap_node.get_node("Button").connect("pressed", self, "default_hotkeys_ask")

func open():
	show()
	$TabContainer/Text/skipread.pressed = globals.globalsettings.skipread
	$TabContainer/Text/textspeed.value = globals.globalsettings.textspeed
	$TabContainer/Text/disabletut.pressed = globals.globalsettings.disable_tutorial
	$TabContainer/Graphics/fullscreen.pressed = globals.globalsettings.fullscreen
	$TabContainer/Game/forced.pressed = globals.globalsettings.forced_content
	for i in $TabContainer/Audio/VBoxContainer.get_children():
		i.get_node("HSlider").value = globals.globalsettings[i.name+'vol']
		i.get_node("CheckBox").pressed = globals.globalsettings[i.name+'mute']
		i.get_node("HSlider").editable = !i.get_node("CheckBox").pressed
	locale_update()

func togglefullscreen():
	globals.globalsettings.fullscreen = $TabContainer/Graphics/fullscreen.pressed
	OS.window_fullscreen = globals.globalsettings.fullscreen
	if globals.globalsettings.fullscreen == false:
		OS.window_position = Vector2(0,0)

func toggleforced():
	globals.globalsettings.forced_content = $TabContainer/Game/forced.pressed

func soundsliderchange(value,name):
	if value <= -39:
		value = -80
	globals.globalsettings[name+'vol'] = value
	if name == 'sound':
		input_handler.PlaySound(menu_open_sound)
	updatesounds()

func mutepressed(node):
	var name = node.get_parent().name
	globals.globalsettings[name + 'mute'] = node.pressed
	node.get_node("../HSlider").editable = !node.pressed
	updatesounds()

func updatesounds():
	var counter = 0
	for i in ['master','music','sound']:
		AudioServer.set_bus_mute(counter, globals.globalsettings[i+'mute'])
		AudioServer.set_bus_volume_db(counter, globals.globalsettings[i+'vol'])
		counter += 1

func textspeed(value):
	globals.globalsettings.textspeed = value

func pressedskipread():
	globals.globalsettings.skipread = $TabContainer/Text/skipread.pressed

func pressed_disable_tutorial():
	globals.globalsettings.disable_tutorial = $TabContainer/Text/disabletut.pressed

func close():
	hide()

func remap_hotkey_start(hotkey :String):
	var remap_text_node = $remap_panel/TextureRect/Label
	remap_text_node.text = tr("REMAP_TEXT") % hotkeys.get_action_name(hotkey)
	remaping_hotkey = hotkey
	remap_panel.show()
	set_process_input(true)

func remap_hotkey(scancode :int):
	if remaping_hotkey.empty() or !InputMap.has_action(remaping_hotkey):
		assert(false, "Options.gd has error on remaping hotkey")
		return
	var cur_event = InputMap.get_action_list(remaping_hotkey)[0]
	if cur_event.scancode == scancode:
		return
	var existing_map :String = hotkeys.find_hotkey_by_scancode(scancode)
	if !existing_map.empty():
		demaping_hotkey = existing_map
		var old_name = hotkeys.get_action_name(existing_map)
		input_handler.get_spec_node(input_handler.NODE_CONFIRMPANEL, [self, 'remap_hotkey_switch',tr("REMAP_SWITCH_TEXT") % old_name])
		return
	remap_hotkey_finish(scancode)

func remap_hotkey_switch():
	assert(!(remaping_hotkey.empty() or demaping_hotkey.empty()), "Options.gd used remap_hotkey_switch inappropriately")
	var new_scancode = InputMap.get_action_list(demaping_hotkey)[0].scancode
	var switched_scancode = InputMap.get_action_list(remaping_hotkey)[0].scancode
	hotkeys.remap_hotkey(demaping_hotkey, switched_scancode)
	demaping_hotkey = ""
	remap_hotkey_finish(new_scancode)

func remap_hotkey_finish(scancode :int):
	hotkeys.remap_hotkey(remaping_hotkey, scancode)
	remaping_hotkey = ""
	update_hotkey_tab()

func _input(event):
	if event is InputEventKey:
		if !event.is_action("ESC"):
			remap_hotkey(event.scancode)
		remap_panel.hide()
		get_tree().set_input_as_handled()
		set_process_input(false)

func update_hotkey_tab():
	for hotkey_line in hotkeys_list.get_children():
		if hotkey_line.has_method("update_me"):
			hotkey_line.update_me()

func default_hotkeys_ask():
	input_handler.get_spec_node(input_handler.NODE_CONFIRMPANEL, [self, 'default_hotkeys',tr("REMAP_DEFAULT")])

func default_hotkeys():
	hotkeys.to_default()
	update_hotkey_tab()

func pressed_locale(new_locale :String):
	globals.globalsettings.ActiveLocalization = new_locale
#	TranslationServer.set_locale(new_locale)
	locale_update()
	input_handler.get_spec_node(input_handler.NODE_NOTIFICATION, [tr("REBOOTNOTE")])

func locale_update():
	for locale in globals.localizations:
		locale_panel.get_node(locale).pressed = (globals.globalsettings.ActiveLocalization == locale)
