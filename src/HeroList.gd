extends Control

var heropanel
var equipopen = false

func _ready():
	set_process(false)

func _process(delta):
	if heropanel.visible == false:
		equipopen = false
	if equipopen == false:
		set_exclusive(false)
		popup()
		set_process(false)

func open():
	globals.ClearContainer($HBoxContainer)
	$HeroPanel.hide()
	show()
	#popup()
	for i in state.heroes.values():
		var newbutton = globals.DuplicateContainerTemplate($HBoxContainer)
		newbutton.get_node("Label").text = i.name
		newbutton.get_node("Icon").texture = i.portrait()
		newbutton.connect("pressed", self, "OpenEquip", [i])

func OpenEquip(hero):
	equipopen = true
	$HeroPanel.open(hero)
