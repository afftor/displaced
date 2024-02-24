extends "res://files/Close Panel Button/ClosingPanel.gd"

var chosenpartbutton
var itemparts = {}
var itemtemplate
var repairitemlist = [] #obsolete


#func _ready():
	#not in use for now
#	$ButtonPanel/CraftButton.connect("pressed", self, 'opencraft')

#func opencraft():
#	$craft.open()

#seems not in use
#func mattooltip(item):
#	return ("[center]" + item.name + "[/center]\n" + item.description)
#func geartooltip(item):
#	return item.tooltip()


func open():
#	input_handler.ShowGameTip('blacksmith')
#	globals.check_signal("BuildingEntered", 'blacksmith')
	
#	if $craft.visible: $craft.update_content()
	#it is always visible for now
	$craft.update_content()
	show()

func show():
	input_handler.menu_node.visible = false
	state.CurBuild = "blacksmith"
	.show()

func hide():
	input_handler.menu_node.visible = true
	state.CurBuild = "";
	.hide();
