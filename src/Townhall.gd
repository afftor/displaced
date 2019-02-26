	extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedworker

func _ready():
	$ButtonPanel/VBoxContainer/Tasks.connect("pressed",self,'tasklist')
	globals.AddPanelOpenCloseAnimation($TaskList)

func open():
	show()

func tasklist():
	$TaskList.show()
	globals.ClearContainer($TaskList/ScrollContainer/VBoxContainer)
	for i in TownData.tasksdict:
		var newbutton = globals.DuplicateContainerTemplate($TaskList/ScrollContainer/VBoxContainer)
		newbutton.get_node("name").text = i.name
		newbutton.connect("pressed", self, 'selecttaskfromlist', [i])


func selecttaskfromlist(task):
	pass
	#$SelectWorker.show()
	#$SelectWorker.OpenSelectTab(TownData.tasksdict.woodcutting)
