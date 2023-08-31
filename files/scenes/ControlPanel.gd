extends Control

onready var BS = $BlackScreen;
var sounds = {
	"defeat" : "sound/defeat",
	"itemget" : "sound/itemget"
}

func _ready():
	for i in sounds.values():
		resources.preload_res(i)
	if resources.is_busy(): yield(resources, "done_work")
	
#	input_handler.SystemMessageNode = $SystemMessageLabel
	$ControlPanel/Return.connect('pressed',self,'openvillage')
	$ControlPanel/Inventory.connect('pressed',self,'openinventory')
	$ControlPanel/Options.connect("pressed",self, 'openmenu')
	$ControlPanel/Herolist.connect('toggled',self, 'openherolist')
	$GameOverPanel/ExitButton.connect("pressed",self,"GameOver")
	$test_combat.connect("pressed",get_parent().get_node("combat"),"test_combat")


func _process(delta):
	$ControlPanel/Gold.text = str(state.money)
#	$ControlPanel/Food.text = str(state.food)
	
	$BlackScreen.visible = $BlackScreen.modulate.a > 0.0


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
	if !$MenuPanel.visible:
		$MenuPanel.show()
	else:
		$MenuPanel.hide()

func openherolist(toggled):
	if $HeroList.visible == false:
		$HeroList.open()
		$ControlPanel/Herolist.pressed = true
	else:
		$HeroList.hide()
		$ControlPanel/Herolist.pressed = false


func openinventory(hero = null):
	$Inventory.open('hero', hero)


func openinventorytrade():
	$Inventory.open("shop")

func openvillage():
#	input_handler.village_node.switch_show()
	var village = input_handler.village_node
	if village.visible:
		village.building_entered("bridge")
	else:
		input_handler.map_node.location_pressed("village")

func FadeToBlackAnimation(time = 1):
	input_handler.UnfadeAnimation($BlackScreen, time)
	input_handler.emit_signal("ScreenChanged")
	input_handler.FadeAnimation($BlackScreen, time, time)


var itemicon = preload("res://files/scenes/ItemIcon.tscn")

func flyingitemicon(taskbar, icon):
	var x = itemicon.instance()
	add_child(x)
	x.texture = icon
	x.rect_global_position = taskbar.rect_global_position
	input_handler.PlaySound(sounds["itemget"])
	input_handler.ResourceGetAnimation(x, taskbar.rect_global_position, $ControlPanel/Inventory.rect_global_position)
	yield(get_tree().create_timer(0.7), 'timeout')
	x.queue_free()


