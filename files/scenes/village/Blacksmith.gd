extends "res://files/Close Panel Button/ClosingPanel.gd"

var chosenpartbutton
var itemparts = {}
var itemtemplate
var repairitemlist = [] #obsolete
var craft_sound = "sound/itemcraft"


func _ready():
	resources.preload_res(craft_sound)
	if resources.is_busy(): yield(resources, "done_work")
	$ButtonPanel/CraftButton.connect("pressed", self, 'opencraft')


func mattooltip(item):
	return ("[center]" + item.name + "[/center]\n" + item.description)


func geartooltip(item):
	return item.tooltip()


func open():
#	input_handler.ShowGameTip('blacksmith')
#	globals.check_signal("BuildingEntered", 'blacksmith')
	show()

func show():
	input_handler.menu_node.visible = false
	state.CurBuild = "blacksmith"
	.show()

func hide():
	input_handler.menu_node.visible = true
	state.CurBuild = "";
	.hide();


func opencraft():
	$craft.open()
