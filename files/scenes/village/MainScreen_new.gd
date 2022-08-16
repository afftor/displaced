extends Control

export var debug = false

#warning-ignore-all:return_value_discarded
#var gamespeed = 1
#var gamepaused = false
#var gamepaused_nonplayer = false
#var previouspeed
#var daycolorchange = false
#onready var timebuttons = [$"TimeNode/0speed", $"TimeNode/1speed", $"TimeNode/2speed"]

var binded_events = {
	bridge = null,
	forge = null,
	tavern = null,
	mine = null,
	farm = null,
	mill = null,
	townhall = null,
	market = null,
}


func debug():
#	state.complete_area('forest_erika')
	state.add_test_resources()
#	state.materials.goblinmetal = 20
#	state.materials.wood = 20
#	state.materials.elvenwood = 20
	#state.townupgrades.lumbermill = 1
	state.decisions.append("blacksmith")
#	var hero = combatantdata.MakeCharacterFromData('arron')
	state.unlock_char('arron')
	state.unlock_char('rose')
	state.unlock_char('erika')
	state.unlock_char('ember')
	state.unlock_char('rilu')
#	state.unlock_char('iola')
	for x in range(5):
		for i in state.heroes.values():
			i.levelup()



func _ready():
	get_tree().set_auto_accept_quit(false)
	if input_handler.scene_node == null:
		input_handler.initiate_scennode(self)
	input_handler.SetMusic("towntheme")
	
#	var speedvalues = [0,1,10]
#	var tooltips = [tr('PAUSEBUTTONTOOLTIP'),tr('NORMALBUTTONTOOLTIP'),tr('FASTBUTTONTOOLTIP')]
#	var counter = 0
#	for i in timebuttons:
#		i.hint_tooltip = tooltips[counter]
#		i.connect("pressed",self,'changespeed',[i])
#		i.set_meta('value', speedvalues[counter])
#		counter += 1
	
	######Vote stuff
	
	input_handler.connect("QuestStarted", self, "VotePanelShow")
	$VotePanel/Links.connect("pressed", self, "VoteLinkOpen")
	$VotePanel/Close.connect("pressed", self, "VotePanelClose")
	
	####
	
	input_handler.connect("UpgradeUnlocked", self, "buildscreen")
	input_handler.connect("EventFinished", self, "buildscreen")
	
	if resources.is_busy(): yield(resources, "done_work")
	if debug == true:
		debug()
	
	#$TutorialNode.activatetutorial(state.currenttutorial)
	buildscreen()
	yield(get_tree(),'idle_frame')
#	if floor(state.daytime) >= 0 && floor(state.daytime) < floor(variables.TimePerDay/4):
#		EnvironmentColor('morning', true)
#	elif floor(state.daytime) >= floor(variables.TimePerDay/4) && floor(state.daytime) < floor(variables.TimePerDay/4*2):
#		EnvironmentColor('day', true)
#	elif floor(state.daytime) >= floor(variables.TimePerDay/4*2) && floor(state.daytime) < floor(variables.TimePerDay/4*3):
#		EnvironmentColor('evening', true)
#	elif floor(state.daytime) >= floor(variables.TimePerDay/4*3) && floor(state.daytime) < floor(variables.TimePerDay):
#		EnvironmentColor('night',true)
	#EnvironmentColor('night', true)
#	set_process(true)


func show():
	buildscreen()
	input_handler.CurrentScreen = 'Village'
#	globals.CurrentScene = self
	.show()

func buildscreen(empty = null):
	var res = false
	for build in globals.upgradelist:
		var node = get_node(build)
		if node != null: node.build_icon()
		
		binded_events[build] = null
		if Explorationdata.buildings.has(build) and Explorationdata.buildings[build].has('events'):
			for seq in Explorationdata.buildings[build].events:
				if state.check_sequence(seq):
					binded_events[build] = seq
					break
		
		if binded_events[build] != null:
			node.set_active()
			res = true
		elif build == 'bridge':
			node.set_active()
		else:
			node.set_inactive()
	
	if $TownHall.build_events():
		get_node("townhall").set_active()
		res = true
	return res



func check_townhall_events():
	pass


func building_entered(b_name):
	if binded_events[b_name] != null:
		globals.run_seq(binded_events[b_name])
#		yield(input_handler, "EventFinished")
#		buildscreen()
	else:
		match b_name:
			'townhall': OpenTownhall()
			'forge': openblacksmith()
			'market': openmarket()
			'bridge': ReturnToMap()
			_: pass #todo


func OpenTownhall():
	$TownHall.open()



func openblacksmith():
	$Blacksmith.open()


func openmarket():
	$shop.open()


func ReturnToMap():
	input_handler.map_node.update_map()
	hide()
	input_handler.CurrentScreen = 'Map'


func VotePanelShow(quest):
	if quest == 'demofinish' && state.votelinksseen == false && debug == false:
		$VotePanel.show()
		state.votelinksseen = true


func VoteLinkOpen():
	OS.shell_open("https://forms.gle/fADzTnSbg94HauBP8")
	OS.shell_open("https://forms.gle/5qHPJ57ngB61LuBq6")


func VotePanelClose():
	$VotePanel.hide()
