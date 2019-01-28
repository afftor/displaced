extends "res://files/Close Panel Button/ClosingPanel.gd"

onready var itemcontainer = $ScrollContainer/GridContainer

var selectedhero

func _ready():
	$ScrollContainer/GridContainer/Button.set_meta('type', 'none')
	for i in $HBoxContainer.get_children():
		i.connect('pressed',self,'selectcategory', [i])

func open(hero = null):
	selectedhero = hero
	show()
	buildinventory()
	selectcategory($HBoxContainer/all)

func buildinventory():
	globals.ClearContainer(itemcontainer)
	for i in globals.state.materials:
		if globals.state.materials[i] <= 0:
			continue
		var newbutton = globals.DuplicateContainerTemplate(itemcontainer)
		var material = globals.items.Materials[i]
		newbutton.get_node('Image').texture = material.icon
		newbutton.get_node('Number').text = str(globals.state.materials[i])
		newbutton.get_node('Number').show()
		newbutton.set_meta('type', 'mat')
		globals.connecttooltip(newbutton, '[center]' + material.name + '[/center]\n' + material.description)
	for i in globals.state.items.values():
		if i.owner != null:
			continue
		var newnode = globals.DuplicateContainerTemplate(itemcontainer)
		input_handler.itemshadeimage(newnode.get_node('Image'), i)
		if i.durability != null:
			newnode.get_node("Number").show()
			newnode.get_node("Number").text = str(globals.calculatepercent(i.durability, i.maxdurability)) + '%'
		if i.amount != null && i.amount > 1:
			newnode.get_node("Number").show()
			newnode.get_node("Number").text = str(i.amount)
		globals.connecttooltip(newnode, i.tooltip())
		newnode.set_meta('type', i.itemtype)
		newnode.connect("pressed",self,'useitem', [i])


func selectcategory(button):
	var type = button.name
	for i in $HBoxContainer.get_children():
		i.pressed = i == button
	
	for i in itemcontainer.get_children():
		i.visible = i.get_meta('type') == type || type == 'all'
		if i.get_meta('type') == 'none':
			i.hide()
	$ScrollContainer/GridContainer.queue_sort()

func useitem(item):
	if selectedhero == null:
		return
	selectedhero.equip(item)
	get_parent().get_node("HeroList/HeroPanel").open(selectedhero)
	globals.hidetooltip()
	buildinventory()
