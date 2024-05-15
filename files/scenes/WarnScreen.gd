extends Panel

func _ready():
	$RichTextLabel.bbcode_text = (tr("WARNTEXT"))
	show()
#warning-ignore:return_value_discarded
	$Accept.connect("pressed",self,"Accept")
#warning-ignore:return_value_discarded
	$Quit.connect("pressed",self, "Quit")

func Accept():
	hide()
	if resources.is_busy(): yield(resources, "done_work")
	input_handler.SetMusic("intro")

func Quit():
	get_parent().quit()
