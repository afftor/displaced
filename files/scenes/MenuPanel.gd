extends "res://files/Close Panel Button/ClosingPanel.gd"
var click_sound = "sound/menu_btn"

func _ready():
	resources.preload_res(click_sound)
	if resources.is_busy(): yield(resources, "done_work")
#warning-ignore:return_value_discarded
	$VBoxContainer/Save.connect('pressed', $saveloadpanel, 'SavePanelOpen')
#warning-ignore:return_value_discarded
	$VBoxContainer/Load.connect('pressed', $saveloadpanel, 'LoadPanelOpen')
#warning-ignore:return_value_discarded
	$VBoxContainer/Options.connect('pressed', self, 'OptionsOpen')
#warning-ignore:return_value_discarded
	$VBoxContainer/Exit.connect('pressed', self, 'Exit')
	move_child($InputBlock, 0)
	for i in $VBoxContainer.get_children():
		i.connect("pressed", self, "PlayClickSound")

func show():
	.show()
	if globals.CurrentScene.get_node("ExploreScreen/combat") != null && globals.CurrentScene.get_node("ExploreScreen/combat").visible:
		$VBoxContainer/Save.disabled = true
	else:
		$VBoxContainer/Save.disabled = false

func OptionsOpen():
	$Options.open()

func PlayClickSound():
	input_handler.PlaySound(click_sound)


func Exit():
	input_handler.get_spec_node(input_handler.NODE_CONFIRMPANEL, [self, 'MainMenu', tr('LEAVECONFIRM')])#ShowConfirmPanel(self, 'MainMenu', tr('LEAVECONFIRM'))

func MainMenu():
	globals.CurrentScene.queue_free()
	globals.ChangeScene('menu')
	get_parent().queue_free()
