extends Node

func _ready():
	pass

signal signal_RMB
signal signal_RMB_release
signal signal_LMB

var position = 0
var fighter
var RMBpressed = false

var hp
var mp

func _process(delta):
	if $hplabel.visible:
		update_hp_label()
	if $mplabel.visible:
		update_mp_label()

func _input(event):
	if get_global_rect().has_point(get_global_mouse_position()):
		if event.is_pressed():
			if event.is_action("RMB"):
				emit_signal("signal_RMB", fighter)
				RMBpressed = true
			elif event.is_action('LMB'):
				emit_signal("signal_LMB", position)
	if event.is_action_released("RMB") && RMBpressed == true:
		emit_signal("signal_RMB_release")
		RMBpressed = false

func update_hp():
	var tween = input_handler.GetTweenNode(self)
	var node = get_node("HP")
	if hp != null && hp != fighter.hp:
		var difference = fighter.hp - hp
		var color
		if difference < 0:
			color = Color(1,0.2,0.2)
		else:
			color = Color(0.2,1,0.2)
		input_handler.FloatText(self, str(difference), color, 2, 0.2, get_node('Icon').rect_size/2-Vector2(20,20))
	hp = fighter.hp
	
	tween.interpolate_property(node, 'value', node.value, globals.calculatepercent(fighter.hp, fighter.hpmax()), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func update_mana():
	var tween = input_handler.GetTweenNode(self)
	var node = get_node("Mana")
	mp = fighter.mana
	
	tween.interpolate_property(node, 'value', node.value, globals.calculatepercent(fighter.mana, fighter.manamax()), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func update_hp_label():
	if fighter.combatgroup == 'ally':
		$hplabel.text = str(fighter.hp) + '/' + str(fighter.hpmax())
	else:
		$hplabel.text = str(globals.calculatepercent(fighter.hp, fighter.hpmax())) + '%'

func update_mp_label():
	if fighter.combatgroup == 'ally':
		$mplabel.text = str(fighter.mana) + '/' + str(fighter.manamax())
	else:
		$mplabel.text = str(globals.calculatepercent(fighter.mana, fighter.manamax())) + '%'

