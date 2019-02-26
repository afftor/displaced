extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedtask
var selectedworker
var selectedtool

func _ready():
	#globals.AddPanelOpenCloseAnimation(self)
	$SelectWorkerButton.connect("pressed", self, 'SelectWorker')
	$SelectToolButton.connect("pressed",self,'SelectTool')
	$ConfirmButton.connect("pressed", self, 'ConfirmTask')

func OpenSelectTab(task):
	show()
	selectedtask = task
	selectedtool = null
	selectedworker = null
	globals.ClearContainer($HBoxContainer)
	for i in task.product:
		var newresource = globals.DuplicateContainerTemplate($HBoxContainer)
		var material = Items.Materials[i]
		globals.connecttooltip(newresource, '[center]' + material.name + '[/center]\n' + material.description + '\n' +tr('BASECHANCE') + ' - [color=yellow]' + str(task.product[i].chance) + '%[/color]')
		
		newresource.texture = Items.Materials[i].icon
	
	$RichTextLabel.bbcode_text = task.description
	$Time.text = str(task.basetimer)
	$Energy.text = str(task.energycost)
	UpdateButtons()

func SelectWorker():
	globals.CharacterSelect(self, 'workers', 'WorkerSelected', 'notask')

func SelectTool():
	globals.ItemSelect(self, 'gear','ToolSelected', selectedtask.tasktool.type)

func WorkerSelected(worker):
	selectedworker = worker
	UpdateButtons()

func ToolSelected(item):
	selectedtool = item
	UpdateButtons()

func UpdateButtons():
	if selectedtool != null:
		input_handler.itemshadeimage($SelectToolButton, selectedtool)
	else:
		$SelectToolButton.texture_normal = load("res://icon.png")
	
	if selectedworker != null:
		$SelectWorkerButton.texture_normal = selectedworker.icon
	else:
		$SelectWorkerButton.texture_normal = load("res://icon.png")
	
	var conditioncheck = true
	if selectedworker == null:
		conditioncheck = false
	if selectedtool == null && selectedtask.tasktool.required == true:
		conditioncheck = false
	
	$ConfirmButton.disabled = !conditioncheck
	


func ConfirmTask():
	hide()
	#Task Data Dict
	var data = {function = selectedtask.triggerfunction, taskdata = selectedtask, time = 0, threshold = selectedtask.basetimer, worker = selectedworker, instrument = selectedtool}
	
	globals.CurrentScene.assignworker(data)