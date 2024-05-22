extends "res://files/Close Panel Button/ClosingPanel.gd"

var shop_menu
var max_v = 1

var item_id = 'item_6_1'
enum {M_SELL, M_BUY}
var mode = M_SELL
var amount = 0

func _enter_tree():
	closebuttonoffset = [8,5]

func _ready():
	shop_menu = get_parent().get_parent()
	$LineEdit.connect("text_entered", self, 'enter_amount')
	$LineEdit.connect("text_changed", self, 'check_text')
	$up.connect("pressed", self, 'change_amount', [1])
	$down.connect("pressed", self, 'change_amount', [-1])
	$Button.connect("pressed", self, 'confirm')


func confirm_sell():
	var itemdata = Items.Items[item_id]
	state.add_materials(item_id, -amount, false)
	state.add_money(itemdata.price * amount, false)


func confirm_buy():
	var itemdata = Items.Items[item_id]
	state.add_materials(item_id, amount, false)
	state.add_money(-itemdata.price * amount, false)


func confirm():
	enter_amount($LineEdit.text)
	match mode:
		M_BUY:
			confirm_buy()
		M_SELL:
			confirm_sell()
	shop_menu.update_data()
	hide()


func setup_res():
	set_amount(1)
	var itemdata = Items.Items[item_id]
	$Icon.texture = itemdata.icon
	$HBoxContainer/name.text = tr(itemdata.name)
	$desc.bbcode_text = tr(itemdata.description)
	$HBoxContainer/cost.text = str(itemdata.price)
	$amount1.text = tr("INPOSESSION") + ": %d" % state.materials[item_id]


func open_buy(id):
	item_id = id
	var itemdata = Items.Items[item_id]
	max_v = int(state.money / itemdata.price)
	mode = M_BUY
	$Button.text = tr("BUY")
	setup_res()
	show()


func open_sell(id):
	item_id = id
	max_v = state.materials[item_id]
	mode = M_SELL
	$Button.text = tr("SELL")
	setup_res()
	show()


func set_amount(value):
	update_amount(value)
	$LineEdit.text = str(amount)


func update_amount(value):
	amount = value
	$down.disabled = false
	$up.disabled = false
	if amount <= 1:
		amount = 1
		$down.disabled = true
	if amount >= max_v:
		amount = max_v
		$up.disabled = true
	$HBoxContainer2/money.text = str(amount * Items.Items[item_id].price)


func enter_amount(txt):
	if txt.is_valid_integer():
		set_amount(int(txt))
	else:
		$LineEdit.text = str(amount)


func check_text(txt :String):
	if !txt.is_valid_integer():
		return
	update_amount(int(txt))


func change_amount(val):
	set_amount(amount + val)
