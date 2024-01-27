extends "res://files/Close Panel Button/ClosingPanel.gd"

var item_id
var shop_menu

func _ready():
	shop_menu = get_parent().get_parent()
	$Button.connect("pressed", self, 's_press')
	$Button2.connect("pressed", self, 'b_press')


func open(id):
	item_id = id
	if state.materials[item_id] <= 0:
		shop_menu.amount_panel.open_buy(item_id)
		return
	show()


func b_press():
	shop_menu.amount_panel.open_buy(item_id)
	hide()


func s_press():
	shop_menu.amount_panel.open_sell(item_id)
	hide()
