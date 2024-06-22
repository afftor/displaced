extends Control

export var test_mode = false



var binded_events = {
	dragon_mountains = null,
	castle = null,
	town = null,
	cave = null,
	forest = null,
	village = null,
	cult = null,
	modern_city = null
}
var village_inside_event = false
var map_has_event = false
#should probably use native godot's pause
var daytime_paused = false

func _ready():
	input_handler.queue_connection("scene_node", "EventFinished", self, "buildscreen")
	
	input_handler.set_handler_node('map_node', self)
	input_handler.set_handler_node('village_node', $MainScreen)
#	input_handler.set_handler_node('explore_node', $explore)
#	input_handler.set_handler_node('combat_node', $combat)
#	input_handler.set_handler_node('scene_node', $TextSystem)
	input_handler.set_handler_node('menu_node', $menu_node)
	input_handler.SystemMessageNode = $SystemMessageLabel
	input_handler.scene_node.preload_scene('intro_1')
	input_handler.curtains = $curtains
	
	if test_mode:
		test()
	
	update_map()
	state.connect("daytime_dawn", self, "set_environment_day")
	state.connect("daytime_sunset", self, "set_environment_night")
	state.connect("daytime_forced", self, "update_environment")
	update_environment()
	
	TutorialCore.register_static_button("exploration_loc", get_area('forest'), "pressed")
# test functions
#	unlock_area('village')
	resources.preload_res("music/towntheme")
	if resources.is_busy(): yield(resources, "done_work")
	input_handler.SetMusic("towntheme")

func test():
	for ch in state.characters:
		state.unlock_char(ch)
#		state.heroes[ch].unlock_all_skills()
#	unlock_area('forest')
	input_handler.curtains.hide_anim(variables.CURTAIN_SCENE)


func buildscreen(empty = null):
	update_map()

#seems not to be in use
#func unlock_area(area):
#	var area_node = get_node(area)
#	area_node.visible = true
#	area_node.m_show()
#	area_node.set_active()
#	area_node.set_border_type('safe')

#real functions
func location_pressed(locname):
	if !state.location_unlock[locname]: return
	if binded_events[locname] != null:
		globals.run_seq(binded_events[locname])
	else:
		if locname == 'village':
			input_handler.village_node.show_anim()
		else:
			input_handler.explore_node.set_location(locname)
			input_handler.explore_node.show()
	update_map()


func update_map():
	map_has_event = false
	for loc in binded_events:
		check_location(loc)
		var area_node = get_area(loc)

		if loc == 'cult':
			if state.location_unlock['modern_city']:
				area_node.hide()
				area_node.set_inactive()
				continue
			else:
				area_node.show()
		elif loc == 'modern_city':
			if state.location_unlock[loc]:
				area_node.show()
			else:
				area_node.hide()
				area_node.set_inactive()
				continue
		
		if state.location_unlock[loc]:
			area_node.m_show()
		else:
			area_node.m_hide()
			area_node.set_inactive()
			area_node.set_current(false)
			continue

		if binded_events[loc] != null:
			area_node.set_border_type('event')
			area_node.set_active()
			area_node.set_current(true)
			map_has_event = true
		elif loc == 'village':
			area_node.set_border_type('safe')
			area_node.set_active()
			area_node.set_current(village_inside_event)
#		elif loc == 'town':
#			area_node.set_inactive()
		else:
			if Explorationdata.check_location_activity(loc):
				area_node.set_active()
				if Explorationdata.check_new_location_activity(loc):
					area_node.set_border_type('event')
					area_node.set_current(true)
					map_has_event = true
				else:
					area_node.set_border_type('combat_replays')
					area_node.set_current(false)
				if (state.activearea != null
						and Explorationdata.locations[loc].missions.has(state.activearea)):
					area_node.set_border_type('combat')
			else:
				area_node.set_current(false)
				area_node.set_inactive()
		assert(
			loc != 'cult'
			or !state.location_unlock['modern_city']
			or !area_node.is_current(),
			"Cult has active mark, but hidden under modern_city")



func check_location(loc_id):
	binded_events[loc_id] = null
	if !Explorationdata.locations.has(loc_id):
		return
	if !Explorationdata.locations[loc_id].has('events'):
		return
	for seq in Explorationdata.locations[loc_id].events:
		if state.check_sequence(seq):
			binded_events[loc_id] = seq
			break
	if loc_id == 'village':
		village_inside_event = input_handler.village_node.buildscreen()

func switch_block_screen(value :bool):
	$block_screen.visible = value

func set_environment_day():
	input_handler.tween_property($ground, 'modulate',
		Color(variables.hexcolordict.night),
		Color(variables.hexcolordict.day),
		variables.DayTransitionTime)

func set_environment_night():
	input_handler.tween_property($ground, 'modulate',
		Color(variables.hexcolordict.day),
		Color(variables.hexcolordict.night),
		variables.DayTransitionTime)

func update_environment():
	var ground = $ground
	if state.is_daytime_day():
		ground.modulate = Color(variables.hexcolordict.day)
	else:
		ground.modulate = Color(variables.hexcolordict.night)

func get_area(a_name):
	return $ground.get_node(a_name)

func pause_daytime(value):
	daytime_paused = value

func _process(delta):
	if !daytime_paused:
		state.add_daytime(delta)
