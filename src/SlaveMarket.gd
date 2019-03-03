	extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedworker

func _ready():
	$ButtonPanel/PurchaseButton.connect("pressed", self, "purchase")
	globals.AddPanelOpenCloseAnimation($PurchaseMenu)

func open():
	show()
	$PurchaseMenu.hide()

func purchase():
	$PurchaseMenu.show()
	globals.ClearContainer($PurchaseMenu/ScrollContainer/VBoxContainer)
	for i in TownData.workersdict.values():
		var newbutton = globals.DuplicateContainerTemplate($PurchaseMenu/ScrollContainer/VBoxContainer)
		newbutton.get_node("Icon").texture = i.icon
		newbutton.get_node("Label").text = i.name
		newbutton.get_node("Cost").text = str(i.price)
		newbutton.connect("pressed", self, "PurchaseSlave", [i])

func PurchaseSlave(worker):
	selectedworker = worker
	input_handler.ShowConfirmPanel(self, "HireConfirm", "Hire this worker for " + str(worker.price) + "?")

func HireConfirm():
	var newworker = globals.worker.new()
	globals.state.money -= selectedworker.price
	newworker.create(selectedworker)

func show():
	state.CurBuild = "slave"
	.show();
	pass

func hide():
		state.CurBuild = "";
		.hide();