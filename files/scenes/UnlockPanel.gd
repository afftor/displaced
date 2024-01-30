extends Control

onready var info_container = $HBoxContainer
#onready var close_all_btn = $close_all_btn#not needed in combat's Rewards
var active_panel_count = 0


#func _ready():
#	close_all_btn.connect('pressed', self, 'hide')

func check_visibility():
	if is_visible_in_tree():
		return
	input_handler.ClearContainer(info_container, ['panel'])
	active_panel_count = 0
#	check_close_all()
	show()

#func check_close_all():
#	close_all_btn.visible = active_panel_count > 1

func close_panel(panel_name :String):
	var panel = info_container.get_node(panel_name)
	panel.hide()
	panel.queue_free()
	active_panel_count -= 1
	if active_panel_count <= 0:
		hide()
		return
#	check_close_all()

func show_material(id :String):
	assert(Items.Items.has(id), "show_material trying to show unexistant material!")
	check_visibility()
	var panel = input_handler.DuplicateContainerTemplate(info_container, 'panel')
	var itemdata = Items.Items[id]
	var icon = panel.get_node("HBoxContainer/icon_border/icon")
	icon.texture = itemdata.icon
	globals.connectmaterialtooltip(icon, itemdata)
	if itemdata.itemtype == "material":
		panel.get_node("info").text = tr("UNLOCKMATERIAL")
	elif itemdata.itemtype == "usable_combat":
		panel.get_node("info").text = tr("UNLOCKUSABLE")
	else:
		print("show_material trying to show material with unknowen itemtype")
	panel.get_node("HBoxContainer/name").text = tr(itemdata.name)
	panel.get_node("close_btn").connect('pressed', self, 'close_panel', [panel.name])
	active_panel_count += 1
#	check_close_all()
