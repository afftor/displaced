extends Panel

func _ready():
	globals.ClearContainer($ScrollContainer/GridContainer)
	for i in Traitdata.traitlist.values():
		var newbutton = globals.DuplicateContainerTemplate($ScrollContainer/GridContainer)
		newbutton.get_node('icon').texture = i.icon
		globals.connecttooltip(newbutton, i.description)
