extends "res://files/Close Panel Button/ClosingPanel.gd"


func _ready():
	$VBoxContainer/Save.connect('pressed', $saveloadpanel, 'SavePanelOpen')
	$VBoxContainer/Load.connect('pressed', $saveloadpanel, 'LoadPanelOpen')
	$VBoxContainer/Options.connect('pressed', self, 'OptionsOpen')
	$VBoxContainer/Exit.connect('pressed', self, 'Exit')
	move_child($InputBlock, 0)
	for i in $VBoxContainer.get_children():
		i.connect("pressed", self, "PlayClickSound")


func OptionsOpen():
	$Options.open()

func PlayClickSound():
	input_handler.PlaySound("button_click")


func Exit():
	input_handler.ShowConfirmPanel(self, 'MainMenu', tr('LEAVECONFIRM'))

func MainMenu():
	globals.ChangeScene('menu')
	get_parent().queue_free()