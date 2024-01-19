#extends "res://files/Close Panel Button/ClosingPanel.gd"
#func RepositionCloseButton():
#	var rect = $Panel.get_global_rect()
#	var pos = Vector2(rect.end.x + 6 - closebutton.rect_size.x - closebuttonoffset[0], rect.position.y + closebuttonoffset[1])
#	closebutton.set_global_position(pos)
#it is not ClosingPanel for now, while it's part of Blacksmith.tscn installation
extends Control


onready var charlist = $Panel/ScrollContainer/HBoxContainer
onready var slot_panels = {
	"weapon1" : $Panel/weapon1,
	"weapon2" : $Panel/weapon2,
	"armor" : $Panel/armor
}
onready var tooltip = $Tooltip


var selected_char
#var selected_slot = null


export var test_mode = false

func _ready():
#	visible = false
	if resources.is_busy(): 
		yield(resources, "done_work")
	input_handler.ClearContainer(charlist, ['panel'])
	for cid in state.characters:
		var hero = state.heroes[cid]
		var ch = input_handler.DuplicateContainerTemplate(charlist, 'panel')
		ch.name = cid
		ch.get_node('Label').text = hero.name
		ch.get_node('TextureRect').texture = hero.portrait()
		ch.connect('pressed', self, 'select_hero', [cid])
	
	for slot in slot_panels:
#		slot_panels[slot].connect('pressed', self, 'slot_select', [slot])
		slot_panels[slot].get_node("Button").connect("pressed", self, 'upgrade_slot', [slot])
		var tooltip_sensor = slot_panels[slot].get_node("tooltip_sensor")
		tooltip_sensor.connect("mouse_entered", self, 'show_tooltip', [slot])
		tooltip_sensor.connect("mouse_exited", self, 'hide_tooltip')
	
	if test_mode:
		testmode()
		if resources.is_busy(): 
			yield(resources, "done_work")
		open()

func testmode():
	for cid in state.characters:
		state.unlock_char(cid)
#	state.unlock_char('rose', false)


func open():
	update_content()
#	input_handler.UnfadeAnimation(self)
	show()


func update_content():
	for cid in state.characters:
		var ch = charlist.get_node(cid)
		ch.visible = (state.heroes[cid].unlocked)
	var old_char = selected_char
	if old_char == null: old_char = 'arron'
	selected_char = null
	select_hero(old_char)
	hide_tooltip()


func select_hero(cid):
	for ch in charlist.get_children():
		ch.pressed = (ch.name == cid)
		ch.rebuild()
	if cid == selected_char: return
	selected_char = cid
#	selected_slot = null
	rebuild_gear(cid)
#	slot_select()
	


func rebuild_gear(cid = selected_char):
	var hero = state.heroes[cid]
	for slot in slot_panels:
		rebuild_gear_slot(slot_panels[slot], hero.get_item_data(slot), hero.get_item_upgrade_data(slot))
#	highlight_slot()
	$Panel/goldicon/Label.text = String(state.money)


func rebuild_gear_slot(node, data, newdata):
	node.get_node("Icon").texture = data.icon
	node.get_node("Label2").text = data.name
	if data.level > 0:
		node.get_node("Label").text = "Level %d" % data.level
	else:
		node.get_node("Label").text = ""
	if newdata != null:
		var forge_can :bool = state.if_has_upgrade('forge', newdata.level)
		node.get_node("Button").visible = forge_can
		node.get_node("UpdateText").visible = !forge_can
		node.get_node("Button").disabled = false
		node.get_node("VBoxContainer").visible = true
		node.get_node("ResPanel").visible = true
		input_handler.ClearContainer(node.get_node("VBoxContainer"), ['button'])
		for res in newdata.cost:
			var info
			var icon
			var has_amount
			var res_text
			if res == 'gold':
				info = Items.gold_info
				icon = info.icon
				has_amount = state.money
				res_text = String(newdata.cost[res])
			else:
				info = Items.Items[res]
				icon = info.icon#as it is now - items icons are loaded directly on start
				has_amount = state.materials[res]
				res_text = "%d/%d" % [newdata.cost[res], has_amount]
			var panel = input_handler.DuplicateContainerTemplate(node.get_node("VBoxContainer"), 'button')
			panel.get_node('icon').texture = icon
			panel.get_node("Label").text = res_text
			globals.connectmaterialtooltip(panel, info)
			if newdata.cost[res] > has_amount:
				node.get_node("Button").disabled = true
				panel.get_node("Label").set("custom_colors/font_color", variables.hexcolordict.red)
	else:
		node.get_node("Button").visible = false
		node.get_node("VBoxContainer").visible = false
		node.get_node("ResPanel").visible = false


func upgrade_slot(slot):
	var hero = state.heroes[selected_char]
	var cost = hero.get_item_upgrade_data(slot).cost
	hero.upgrade_gear(slot)
	for res in cost:
		if res == 'gold':
			state.add_money(-cost[res], false)
		else:
			state.materials[res] -= cost[res]
	rebuild_gear()
#	if tooltip.visible:
#		rebuild_tooltip()

func show_tooltip(slot):
	#works till child to Blacksmith.tscn, which is ClosingPanel
	if !get_parent().is_ready_to_use(): return
	
	tooltip.build_upgrade_tooltip(selected_char, slot)
	tooltip.rect_global_position.x = (
		slot_panels[slot].get_global_rect().end.x + 5)
	tooltip.show()

func hide_tooltip():
	tooltip.hide()


#all that stuff is not needed while tooltip is mouse-over pop-up, instead of on-click
#MIND, that slots are buttons and are still clickable, just switch button_filter back on to return to old style
#func rebuild_tooltip():
#	tooltip.build_upgrade_tooltip(selected_char, selected_slot)
#
#func slot_select(slot = selected_slot):
#	if slot == selected_slot:
#		selected_slot = null
#		tooltip.hide()
#	else:
#		selected_slot = slot
#		rebuild_tooltip()
#		tooltip.rect_global_position.x = (
#			slot_panels[selected_slot].get_global_rect().end.x + 5)
##		if selected_slot == 'armor':
##			tooltip.rect_position.x = (
##				slot_panels['armor'].get_global_rect().end.x + 5)
##		else:
##			tooltip.rect_position.x = (
##				slot_panels['weapon1'].rect_global_position.x -
##				tooltip.rect_size.x - 5)
#		tooltip.show()
#	highlight_slot()
#
#func highlight_slot():
#	for sid in slot_panels:
#		var node = slot_panels[sid]
#		if sid == selected_slot:
#			node.pressed = true
#			node.get_node("Label").set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
#			node.get_node("Label2").set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
#			for nd in node.get_node('VBoxContainer').get_children():
#				var lb = nd.get_node('Label')
#				if lb.get("custom_colors/font_color") != Color(variables.hexcolordict.red):
#					lb.set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
#		else:
#			node.pressed = false
#			node.get_node("Label").set("custom_colors/font_color", variables.hexcolordict.light_grey)
#			node.get_node("Label2").set("custom_colors/font_color", variables.hexcolordict.light_grey)
#			for nd in node.get_node('VBoxContainer').get_children():
#				var lb = nd.get_node('Label')
#				if lb.get("custom_colors/font_color") != Color(variables.hexcolordict.red):
#					lb.set("custom_colors/font_color", variables.hexcolordict.light_grey)
