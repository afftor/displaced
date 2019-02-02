extends "res://files/Close Panel Button/ClosingPanel.gd"

var currenttask
var currentworker

func _ready():
	$TaskPanel/StopButton.connect("pressed", self, 'StopTask')

func BuildSlaveList():
	ClearScene()
	show()
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	for i in globals.state.workers.values():
		var newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.get_node("Icon").texture = i.icon
		newbutton.get_node("Name").text = i.name
		newbutton.get_node("Task").visible = i.task != null
		newbutton.get_node("Line").connect("mouse_entered",self, 'SelectSlave', [i])
		newbutton.get_node("Use").connect("pressed",self, 'SlaveFeed', [i])
		newbutton.get_node("Remove").connect("pressed",self, 'SlaveRemove', [i])
		newbutton.get_node("Energy").text = str(i.energy) + '/' + str(i.maxenergy)

func SlaveFeed(worker):
	currentworker = worker
	itemselect(self, 'edible', 'SlaveFeedItem')

func SlaveFeedItem(item):
	pass

func SlaveRemove(worker):
	currentworker = worker
	if worker.task != null:
		globals.CurrentScene.stoptask(worker.task)
	input_handler.ShowConfirmPanel(self, 'SlaveRemoveConfirm', tr('SLAVEREMOVECONFIRM'))

func SlaveRemoveConfirm():
	globals.state.workers.erase(currentworker.id)
	BuildSlaveList()

func ClearScene():
	currenttask = null
	$TaskPanel.hide()

func SelectSlave(worker):
	var text = tr("CURRENTTASK") + ': '
	currentworker = worker
	if worker.task == null:
		$TaskPanel.hide()
	else:
		$TaskPanel.show()
		text += worker.task.taskdata.name
		ShowTaskInformation(worker.task)


func ShowTaskInformation(task):
	currenttask = task
	if task.instrument != null:
		input_handler.itemshadeimage($TaskPanel/ToolImage, task.instrument)
		globals.connecttooltip($TaskPanel/ToolImage, task.instrument.tooltip())
	var text = task.taskdata.name
	$TaskPanel/EnergyIcon/EnergyCost.text = str(task.taskdata.energycost)
	$TaskPanel/TimeIcon/TimeCost.text = str(task.threshold)
	$TaskPanel/TaskDescript.bbcode_text = text
	$TaskPanel/Head.text = text
	$TaskPanel/TaskProgress.value = globals.calculatepercent(task.time,task.threshold)

func StopTask():
	input_handler.ShowConfirmPanel(self, 'StopTaskConfirm', tr("STOPTASKCONFIRM"))

func StopTaskConfirm():
	globals.CurrentScene.stoptask(currenttask)
	BuildSlaveList()