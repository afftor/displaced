extends "res://files/Close Panel Button/ClosingPanel.gd"

onready var mode_panel = $modeselect
onready var amount_panel = $SelectAmountPanel
onready var reslist = $ScrollContainer/VBoxContainer



func update_data():
	input_handler.ClearContainer(reslist, ['Button'])
	for id in Items.Items:
		var panel = input_handler.DuplicateContainerTemplate(reslist, 'Button')
		build_res(panel, id)
		panel.connect('pressed', mode_panel, 'open', [id])
	$HBoxContainer/money.text = str(state.money)


func build_res(panel, item_id):
	var itemdata = Items.Items[item_id]
	panel.get_node('Icon').texture = itemdata.icon 
	panel.get_node('HBoxContainer/name').text = tr(itemdata.name) #do not think these translations should be made in data file
	panel.get_node('desc').bbcode_text = tr(itemdata.description)
	panel.get_node('HBoxContainer/cost').text = str(itemdata.price)
	panel.get_node('amount').text = "in posession: %d" % state.materials[item_id]


func open():
	update_data()
	show()

func show():
	state.CurBuild = 'shop';
	input_handler.menu_node.visible = false
	.show()

func hide():
	state.CurBuild = '';
	input_handler.menu_node.visible = true
	.hide()
