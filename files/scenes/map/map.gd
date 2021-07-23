extends TextureRect

export var test_mode = false



var binded_events = {
	dragon_mountains = null,
	castle = null,
	town = null,
	cave = null,
	forest = null,
	village = null,
	temple = null
}


func _ready():
	input_handler.map_node = self
	input_handler.village_node = $MainScreen
	input_handler.explore_node = $explore
#	input_handler.combat_node = $combat
	input_handler.scene_node = $TextSystem
	input_handler.menu_node = $menu_node
	
	if test_mode:
		test()
	
	update_map()
# test functions
#	unlock_area('village')

func test():
	for ch in state.characters:
		state.unlock_char(ch)
		state.heroes[ch].unlock_all_skills()
	unlock_area('forest')


func buildscreen(empty = null):
	update_map()



func unlock_area(area):
	var area_node = get_node(area)
	area_node.m_show()
	area_node.set_active()
	area_node.set_border_type('safe')

#real functions
func location_pressed(locname):
	if binded_events[locname] != null:
		globals.StartEventScene(binded_events[locname])
	else:
		if locname == 'village':
			input_handler.village_node.show()
		else:
			input_handler.explore_node.set_location(locname)
			input_handler.explore_node.show()
	update_map()


func update_map():
	for loc in binded_events:
		binded_events[loc] = globals.check_signal_test('LocationEntered', loc)
		var area_node = get_node(loc)

		if state.location_unlock[loc]:
			area_node.m_show()
		else:
			area_node.m_hide()

		if binded_events[loc] != null:
			area_node.set_border_type('event')
			area_node.set_active()
		elif loc == 'village':
			area_node.set_border_type('safe')
			area_node.set_active()
		elif loc == 'town':
			area_node.set_inactive()
		else:
			area_node.set_border_type('combat')
			
			if Explorationdata.check_location_activity(loc):
				area_node.set_active()
				if state.activearea != null:
					area_node.set_current(Explorationdata.areas[state.activearea].category == loc)
			else:
				area_node.set_inactive()
