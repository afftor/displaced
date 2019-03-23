	extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedworker

func _ready():
	$ButtonPanel/PurchaseButton.connect("pressed", self, "purchase")
	$ButtonPanel/SellButton.connect('pressed', self, 'shop')
	globals.AddPanelOpenCloseAnimation($PurchaseMenu)

func open():
	show()
	input_handler.emit_signal("BuildingEntered", 'market')
	$PurchaseMenu.hide()

func shop():
	globals.CurrentScene.openinventorytrade()

func purchase():
	$PurchaseMenu.show()
	$PurchaseMenu/Label.text = tr("TOTALWORKERS") + ": " + str(state.workers.size()) + '/' + str(state.GetWorkerLimit())
	globals.ClearContainer($PurchaseMenu/ScrollContainer/VBoxContainer)
	for i in TownData.workersdict.values():
		var check = true
		for k in i.unlockreqs:
			if state.valuecheck(k) == false:
				check = false
		if check == false:
			continue
		var newbutton = globals.DuplicateContainerTemplate($PurchaseMenu/ScrollContainer/VBoxContainer)
		newbutton.get_node("Icon").texture = i.icon
		newbutton.get_node("Label").text = i.name
		newbutton.get_node("Cost").text = str(i.price)
		newbutton.connect("pressed", self, "PurchaseSlave", [i])

func PurchaseSlave(worker):
	if state.workers.size() >= state.GetWorkerLimit():
		input_handler.SystemMessage(tr("WORKERLIMITREACHER"))
		return
	selectedworker = worker
	input_handler.ShowConfirmPanel(self, "HireConfirm", "Hire this worker for " + str(worker.price) + "?")

func HireConfirm():
	var newworker = globals.worker.new()
	state.money -= selectedworker.price
	newworker.create(selectedworker)

func show():
	state.CurBuild = "SlaveMarket"
	.show()

func hide():
	state.CurBuild = ""
	.hide()