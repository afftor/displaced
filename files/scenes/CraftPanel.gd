extends Control

onready var charlist = $Panel/ScrollContainer/HBoxContainer
onready var w1panel = $Panel/Panel/HBoxContainer/weapon1
onready var w2panel = $Panel/Panel/HBoxContainer/weapon2
onready var armpanel = $Panel/Panel/HBoxContainer/weapon3
onready var tooltip_label = $Tooltip/RichTextLabel


var selected_char


export var test_mode = false

func _ready():
	for ch in charlist.get_children():
		var cid = ch.name.to_lower()
		ch.set_meta('hero', cid)
		ch.connect('pressed', self, 'select_hero', [cid])
	if test_mode:
		testmode()
		if resources.is_busy(): yield(resources, "done_work")
		open()

func testmode():
	for cid in state.characters:
		state.unlock_char(cid)
#	state.unlock_char('rose', false)


func open():
	for ch in charlist.get_children():
		var cid = ch.name.to_lower()
		ch.visible = (state.heroes[cid].unlocked)
	$Tooltip.hide()
	select_hero('arron')
	hide_slot_tooltip()
	input_handler.UnfadeAnimation(self)
	show()


func select_hero(cid):
	if cid == selected_char: return
	selected_char = cid
	for ch in charlist.get_children():
		ch.pressed = (ch.get_meta('hero') == cid)
	rebuild_gear(cid)


func rebuild_gear(cid = selected_char):
	var hero = state.heroes[cid]
	rebuild_gear_slot(w1panel, hero.get_item_data('weapon1'), hero.get_item_upgrade_data('weapon1'))
	rebuild_gear_slot(w2panel, hero.get_item_data('weapon2'), hero.get_item_upgrade_data('weapon2'))
	rebuild_gear_slot(armpanel, hero.get_item_data('armor'), hero.get_item_upgrade_data('armor'))


func rebuild_gear_slot(node, data, newdata):
	node.get_node("Icon").texture = data.icon
	node.get_node("Icon").connect("mouse_entered", self, 'show_slot_tooltip', [data.type])
	node.get_node("Icon").connect("mouse_exited", self, 'hide_slot_tooltip')
	if data.level > 0:
		node.get_node("Label").text = "%s Lv%d" % [data.name, data.level]
	else:
		node.get_node("Label").text = data.name
	if newdata != null:
		node.get_node("Button").visible = true
		node.get_node("Button").disabled = false
		node.get_node("VBoxContainer").visible = true
		input_handler.ClearContainer(node.get_node("VBoxContainer"))
		for res in newdata.cost:
			var panel = input_handler.DuplicateContainerTemplate(node.get_node("VBoxContainer"))
			panel.texture = Items.Items[res].icon #as it is now - items icons are loaded directly on start
			panel.get_node("Label").text = "%s: %d/%d" % [Items.Items[res].name, newdata.cost[res], state.materials[res]]
			if newdata.cost[res] > state.materials[res]:
				node.get_node("Button").disabled = true
				panel.get_node("Label").set("custom_colors/font_color", variables.hexcolordict.red)
		node.get_node("Button").connect("pressed", self, 'upgrade_slot', [data.type])
	else:
		node.get_node("Button").visible = false
		node.get_node("VBoxContainer").visible = false


func upgrade_slot(slot):
	var hero = state.heroes[selected_char]
	var cost = hero.get_item_upgrade_data(slot).cost
	hero.upgrade_gear(slot)
	for res in cost:
		state.materials[res] -= cost[res]
	rebuild_gear()


func show_slot_tooltip(slot):
	var itemdata = Items.hero_items_data["%s_%s" % [selected_char, slot]]
	var hero = state.heroes[selected_char]
	var text = ""
	for i in range(1, 5):
		var text2 = "Level %d\n" % i
		text2 += itemdata.leveldata[i].lvldesc
		text2 += "\n"
		if hero.gear_level[slot] >= i:
			text2 = "[color=green]%s[/color]" % text2
		text += text2
	tooltip_label.bbcode_text = "[center]%s[/center]" % text
	$Tooltip.show()

func hide_slot_tooltip():
	$Tooltip.hide()
