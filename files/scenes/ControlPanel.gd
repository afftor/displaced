extends Control

onready var BS = $BlackScreen;
var sounds = {
	"defeat" : "sound/game_over",
#	"itemget" : "sound/itemget_1"
}

export(Texture) var menu_home_icon
export(Texture) var menu_world_icon

func _ready():
	for i in sounds.values():
		resources.preload_res(i)
	if resources.is_busy(): yield(resources, "done_work")
	
#	input_handler.SystemMessageNode = $SystemMessageLabel
	$ControlPanel/Return.connect('pressed', self, 'openvillage')
	$ControlPanel/Inventory.connect('pressed', self, 'openinventory')
	$ControlPanel/Options.connect("pressed",self, 'openmenu')
	$ControlPanel/Herolist.connect('toggled',self, 'openherolist')
	$GameOverPanel/ExitButton.connect("pressed",self,"GameOver")
	$dev_panel/test_combat.connect("pressed",get_parent().get_node("combat"),"test_combat")
	$dev_panel/test_event.connect("pressed", self, "test_event")
	$dev_panel/dump_ref.connect("pressed", self, "dump_referals")
	state.connect("money_changed", self, "UpdateMoney")
	return_button_home()

func dump_referals():
	if input_handler.scene_node == null:
		print("there is no scene node")
		return
	input_handler.scene_node.dump_referals()

func test_event():
	globals.play_scene('erika_annet_2_1')


func UpdateMoney():
	$ControlPanel/Gold.text = str(state.money)

#func _process(delta):
#	$ControlPanel/Gold.text = str(state.money)
##	$ControlPanel/Food.text = str(state.food)
#
#	BS.visible = BS.modulate.a > 0.0


func GameOverShow():
	if !visible: visible = true
	$GameOverPanel.show()
	input_handler.UnfadeAnimation($GameOverPanel, 2)
	input_handler.StopMusic(500)
	input_handler.PlaySound(sounds["defeat"])
#	GameOver()


func GameOver():
	globals.CurrentScene.queue_free()
	globals.ChangeScene('menu')


func openmenu():
	var node = $MenuPanel
	if !node.visible:
		node.show()
	else:
		node.hide()

func openinventory():
	var node = $Inventory
	if !node.visible:
		node.open()
	else:
		node.hide()

func openherolist(toggled):
	if $HeroList.visible == false:
		$HeroList.open()
		$ControlPanel/Herolist.pressed = true
	else:
		$HeroList.hide()
		$ControlPanel/Herolist.pressed = false


#to delete
#func openinventory(hero = null):
#	$Inventory.open('hero', hero)
#func openinventorytrade():
#	$Inventory.open("shop")

func openvillage():
#	input_handler.village_node.switch_show()
	var village = input_handler.village_node
	if village.visible:
		village.building_entered("bridge")
	else:
		input_handler.map_node.location_pressed("village")

func update_return_button():
	if input_handler.village_node.visible:
		$ControlPanel/Return/TextureRect.texture = menu_world_icon
		$ControlPanel/Return/Label.text = tr('MENU_WORLD')
	else:
		return_button_home()
func return_button_home():
	$ControlPanel/Return/TextureRect.texture = menu_home_icon
	$ControlPanel/Return/Label.text = tr('MENU_HOME')

func FadeToBlackAnimation(time = 1):
	input_handler.UnfadeAnimation(BS, time)
	input_handler.emit_signal("ScreenChanged")
	input_handler.FadeAnimation(BS, time, time)


var itemicon = preload("res://files/scenes/ItemIcon.tscn")

#seems not in use
#func flyingitemicon(taskbar, icon):
#	var x = itemicon.instance()
#	add_child(x)
#	x.texture = icon
#	x.rect_global_position = taskbar.rect_global_position
#	input_handler.PlaySound(sounds["itemget"])
#	input_handler.ResourceGetAnimation(x, taskbar.rect_global_position, $ControlPanel/Inventory.rect_global_position)
#	yield(get_tree().create_timer(0.7), 'timeout')
#	x.queue_free()


