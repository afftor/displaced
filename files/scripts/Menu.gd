extends Node

func _ready():
	var buttonlist = ['newgame','loadwindow','options','quit']
	$version.text = "ver. " + globals.gameversion
	globals.CurrentScene = self
	for i in range(0,4):
		$VBoxContainer.get_child(i).connect("pressed",self,buttonlist[i])
		#input_handler.ConnectSound($VBoxContainer.get_child(i), 'button_click', 'button_up')
	
	for i in $Panel/VBoxContainer.get_children():
		i.connect("pressed", input_handler, 'open_shell', [i.name])

func newgame():
	state.newgame = true
	get_node("/root").remove_child(self)
	globals.ChangeScene('town')
	
	yield(globals, 'scene_changed')
	#globals.StartEventScene("Intro")
	self.queue_free()

func loadwindow():
	$saveloadpanel.LoadPanelOpen()

func options():
	$Options.open()

func quit():
	get_tree().quit()