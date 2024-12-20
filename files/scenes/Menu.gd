extends Node

var lastsave = null
onready var difficulty_node = $difficulty_ask

func _ready():

	get_tree().set_auto_accept_quit(false)

	var buttonlist = ['continueb','newgame','loadwindow','options','credits','quit']
	$version.text = "ver. " + globals.get_game_version()
	globals.CurrentScene = self
	#input_handler.StopMusic()
	check_last_save()
	for i in range(0,buttonlist.size()):
#warning-ignore:return_value_discarded
		$VBoxContainer.get_child(i).connect("pressed",self,buttonlist[i])
		#input_handler.ConnectSound($VBoxContainer.get_child(i), 'button_click', 'button_up')

#warning-ignore:return_value_discarded
	$DemoPanel/Button.connect("pressed", self, "CloseDemoWarn")

	$difficulty_ask/TextureRect/Normal.connect("pressed", self, "start_newgame", [variables.DF_NORMAL])
	$difficulty_ask/TextureRect/Hard.connect("pressed", self, "start_newgame", [variables.DF_HARD])
	$difficulty_ask/TextureRect/cancel.connect("pressed", difficulty_node, "hide")

	if globals.globalsettings.warnseen == true:
		$DemoPanel.hide()

	OS.window_fullscreen = globals.globalsettings.fullscreen
	if OS.window_fullscreen == false:
		OS.window_size = globals.globalsettings.window_size
		OS.window_position = globals.globalsettings.window_pos

	for i in $Panel/VBoxContainer.get_children():
		i.connect("pressed", input_handler, 'open_shell', [i.name])
	
	
	resources.preload_res("music/intro")
	
	var preload_screen = $preload_screen
	if resources.is_busy():
		yield(resources, "done_work")
		input_handler.FadeAnimation(preload_screen, 0.5)
		yield(get_tree().create_timer(0.5), 'timeout')
	preload_screen.hide()

func check_last_save():
	lastsave = globals.get_last_save();
	if lastsave == null:
		$VBoxContainer/continuebutton.visible = false
	else:
		$VBoxContainer/continuebutton.visible = true

func continueb():
	globals.LoadGame(lastsave.get_file().get_basename());

func newgame():
	difficulty_node.show()

func start_newgame(difficulty):
	difficulty_node.hide()
	state.set_difficulty(difficulty)
	#state = load("res://src/gamestate.gd").new()
	input_handler.BlackScreenTransition(1)
	yield(get_tree().create_timer(1), 'timeout')

	TutorialCore.clear_buttons()
	state.revert()
#	state.newgame = true
	state._ready()
	get_node("/root").remove_child(self)
	globals.ChangeScene('map')
	yield(globals, 'scene_changed')
	#temporaly removed until tutorials reworked
	globals.StartGame()
	#globals.StartEventScene("Intro")
	self.queue_free()

func CloseDemoWarn():
	globals.globalsettings.warnseen = true
	$DemoPanel.hide()

func loadwindow():
	$saveloadpanel.show(true)

func options():
	$Options.open()

func credits():
	input_handler.get_spec_node(input_handler.NODE_CREDITS).show_credits()

func quit():
	globals.globalsettings.window_size = OS.window_size
	globals.globalsettings.window_pos = OS.window_position
	get_tree().quit()
