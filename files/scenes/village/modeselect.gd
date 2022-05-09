extends "res://files/Close Panel Button/ClosingPanel.gd"

var item_id

func _ready():
	$Button.connect("pressed", self, 's_press')
	$Button2.connect("pressed", self, 'b_press')


func open(id):
	item_id = id
	if state.materials[item_id] <= 0:
		get_parent().amount_panel.open_buy(item_id)
		return
	show()


func b_press():
	get_parent().amount_panel.open_buy(item_id)
	hide()


func s_press():
	get_parent().amount_panel.open_sell(item_id)
	hide()
