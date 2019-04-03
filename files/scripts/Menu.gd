extends Node

var lastsave = null

func _ready():
	var buttonlist = ['newgame','continueb','loadwindow','options','quit']
	$version.text = "ver. " + globals.gameversion
	globals.CurrentScene = self
	check_last_save()
	for i in range(0,5):
		$VBoxContainer.get_child(i).connect("pressed",self,buttonlist[i])
		#input_handler.ConnectSound($VBoxContainer.get_child(i), 'button_click', 'button_up')
	
	$DemoPanel/Button.connect("pressed", self, "CloseDemoWarn")
	
	if globals.globalsettings.warnseen == true:
		$DemoPanel.hide()
	
	
	for i in $Panel/VBoxContainer.get_children():
		i.connect("pressed", input_handler, 'open_shell', [i.name])

func check_last_save():
	lastsave = globals.get_last_save();
	if lastsave == null: 
		$VBoxContainer/continuebutton.visible = false
	else:
		$VBoxContainer/continuebutton.visible = true
	pass

func continueb():
	globals.LoadGame(lastsave.get_file().get_basename());

func newgame():
	state = load("res://src/gamestate.gd").new()
	state.newgame = true
	state._ready()
	get_node("/root").remove_child(self)
	globals.ChangeScene('town')
	yield(globals, 'scene_changed')
	input_handler.ActivateTutorial()
	#globals.StartEventScene("Intro")
	self.queue_free()

func CloseDemoWarn():
	globals.globalsettings.warnseen = true
	$DemoPanel.hide()

func loadwindow():
	$saveloadpanel.LoadPanelOpen()

func options():
	$Options.open()

func quit():
	get_tree().quit()