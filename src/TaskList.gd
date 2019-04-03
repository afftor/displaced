extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedworker
var selectedtask
var selectedtool


func _ready():
	hide()
	globals.AddPanelOpenCloseAnimation($SelectWorker)
	$SelectWorker/SelectWorkerButton.connect("pressed", self, 'SelectWorker')
	$SelectWorker/SelectToolButton.connect("pressed",self,'SelectTool')
	$SelectWorker/ConfirmButton.connect("pressed", self, 'ConfirmTask')

func tasklist():
	show()
	$SelectWorker.hide()
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	for i in TownData.tasksdict.values():
		var check = true
		for k in i.unlockreqs:
			if state.valuecheck(k) == false:
				check = false
		if check == false:
			continue
		
		
		var newbutton = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newbutton.get_node("name").text = i.name + " " + calculateworkers(i, 'string')
		if calculateworkers(i) == false:
			newbutton.disabled = true
		newbutton.connect("pressed", self, 'selecttaskfromlist', [i])

func selecttaskfromlist(task):
	OpenSelectTab(task, selectedworker)

func calculateworkers(task, mode = 'default'):
	var aimtask = task.code
	var counter = 0
	var limit = workerlimit(task)
	for i in state.tasks:
		if i.taskdata.code == aimtask:
			counter += 1
	if mode == 'default':
		if counter >= limit:
			return false
		else:
			return true
	elif mode == 'string':
		return str(counter) + "/" + str(limit)

func workerlimit(task):
	var rval = task.baselimit
	if task.upgradelimit != null && state.townupgrades.has(task.upgradelimit):
		rval = globals.upgradelist[task.upgradelimit].levels[state.townupgrades[task.upgradelimit]].limitchange
	return rval 

func OpenSelectTab(task, worker):
	$SelectWorker.show()
	selectedtask = task
	selectedtool = null
	selectedworker = worker
	#worker = state.workers[worker]
	
	
	
	$SelectWorker/RichTextLabel.bbcode_text = task.description
	$SelectWorker/Time.text = str(task.basetimer)
	$SelectWorker/Energy.text = str(task.energycost)
	
	
	
	
	UpdateButtons()

func SelectWorker():
	globals.CharacterSelect(self, 'workers', 'WorkerSelected', 'notask')

func SelectTool():
	globals.ItemSelect(self, 'gear','ToolSelected', selectedtask.tasktool.type)

func WorkerSelected(worker):
	selectedworker = worker
	UpdateButtons()

func ToolSelected(item):
	selectedtool = item.id
	UpdateButtons()

func UpdateButtons():
	$SelectWorker/SelectToolButton/Icon.material = null
	if selectedtool != null:
		input_handler.itemshadeimage($SelectWorker/SelectToolButton/Icon, state.items[selectedtool])
		state.items[selectedtool].tooltip($SelectWorker/SelectToolButton)
	else:
		$SelectWorker/SelectToolButton/Icon.texture = load("res://assets/images/gui/ui_slot_cross.png")
	
	if selectedworker != null:
		$SelectWorker/SelectWorkerButton/Icon.texture = load(state.workers[selectedworker].icon)
	else:
		$SelectWorker/SelectWorkerButton/Icon.texture = load("res://assets/images/gui/ui_slot_cross.png")
	
	var conditioncheck = true
	if selectedworker == null:
		conditioncheck = false
	if selectedtool == null && selectedtask.tasktool.required == true:
		conditioncheck = false
	if state.workers[selectedworker].energy + state.food < selectedtask.energycost:
		conditioncheck = false
	
	$SelectWorker/ConfirmButton.disabled = !conditioncheck
	
	globals.ClearContainer($SelectWorker/HBoxContainer)
	var worker = state.workers[selectedworker]
	var task = selectedtask
	for i in task.workerproducts[worker.type]:
		var newresource = globals.DuplicateContainerTemplate($SelectWorker/HBoxContainer)
		var item = i.code.split('.')
		
		if item[0] == 'materials':
			var material = Items.Materials[item[1]]
			newresource.get_node("amount").text = str(i.amount)
			globals.connecttooltip(newresource, '[center]' + material.name + '[/center]\n' + material.description + '\n' +tr('BASECHANCE') + ' - [color=green]' + str(i.chance) + '%[/color]')
			newresource.texture = material.icon
		elif item[0] == 'usables':
			var usable = Items.Items[item[1]]
			newresource.get_node("amount").text = str(i.amount)
			newresource.texture = usable.icon
			globals.connecttooltip(newresource, '[center]' + usable.name + '[/center]\n' + usable.description + '\n' +tr('BASECHANCE') + ' - [color=green]' + str(i.chance) + '%[/color]')
	


func ConfirmTask():
	hide()
	var threshold = selectedtask.basetimer
	
	if selectedtool != null && selectedtask.tasktool.required == false:
		threshold -= threshold/2
#		for i in state.items[selectedtool].effects:
#			if i.code == 'speed':
#				threshold -= i.value
	
	
	var data = {taskdata = selectedtask, time = 0, threshold = threshold, worker = selectedworker, instrument = selectedtool}
	globals.CurrentScene.assignworker(data)
	input_handler.emit_signal("WorkerAssigned", data)