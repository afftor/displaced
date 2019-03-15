extends "res://files/Close Panel Button/ClosingPanel.gd"

var queststext = {
	elves = {
		1 : "Search Eastern Forest for elves",
		2 : "Report your discoveries to Flak"
		},
	demitrus = {
		1 : "Explore Caves with Dimitrus",
		},
	demofinish = {
		1 : "You have completed the demo!"
	}
	
}

func open():
	show()
	globals.ClearContainer($ScrollContainer/VBoxContainer)
	for i in state.activequests: #{code = name, stage = value}
		var newquest = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newquest.get_node("RichTextLabel").bbcode_text = queststext[i.code][i.stage]
	if state.activequests.size() == 0:
		var newquest = globals.DuplicateContainerTemplate($ScrollContainer/VBoxContainer)
		newquest.get_node("RichTextLabel").bbcode_text = tr("NOACTIVEQUESTS")