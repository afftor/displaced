extends Panel

func _ready():
	$Accept.connect("pressed",self,"Accept")
	$Quit.connect("pressed",self, "Quit")

func Accept():
	hide()

func Quit():
	get_tree().quit()