extends Node

func _ready():
	var buttonlist = ['newgame','loadwindow','options','quit']
	globals.CurrentScene = self
	for i in range(0,4):
		$VBoxContainer.get_child(i).connect("pressed",self,buttonlist[i])
	
	for i in $Panel/VBoxContainer.get_children():
		i.connect("pressed", input_handler, 'open_shell', [i.name])

func newgame():
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