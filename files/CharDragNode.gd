extends Control

var dragdata
export var pos = 0
var parent_node


func get_drag_data(position):
	set_drag_preview(self.duplicate())
	return dragdata
 
func can_drop_data(position, data):
	return true

func drop_data(position, data):
	if data == null and dragdata != null:
#		var hero1 = state.heroes[dragdata]
#		var pos1 = pos
#		if pos1 == 0: pos1 = null
#		hero1.position = pos1
		pass
	elif dragdata == null and data != null:
		var hero1 = state.heroes[data]
		var pos1 = pos
		if pos1 == 0: pos1 = null
		hero1.position = pos1
	elif dragdata != null and data != null:
		var hero1 = state.heroes[data]
		var pos1 = pos
		if pos1 == 0: pos1 = null
		var hero2 = state.heroes[dragdata]
		var pos2 = hero1.position
		hero1.position = pos1
		hero2.position = pos2
	parent_node.build_party()
