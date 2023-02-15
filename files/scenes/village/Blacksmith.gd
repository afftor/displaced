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
	TutorialCore.check_event("village_blacksmith_open")
	state.CurBuild = "blacksmith"
	input_handler.ShowGameTip('blacksmith')
	input_handler.menu_node.visible = false
#	globals.check_signal("BuildingEntered", 'blacksmith')
	.show()


func hide():
	input_handler.menu_node.visible = true
	state.CurBuild = "";
	.hide();


func opencraft():
	if !TutorialCore.check_action("village_craft_open"): return
	$craft.open()
