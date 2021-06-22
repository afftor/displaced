extends Control

var debug = true

#warning-ignore-all:return_value_discarded
var gamespeed = 1
var gamepaused = false
var gamepaused_nonplayer = false
var previouspeed
var daycolorchange = false
onready var timebuttons = [$"TimeNode/0speed", $"TimeNode/1speed", $"TimeNode/2speed"]

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

func _ready():
	get_tree().set_auto_accept_quit(false)
	globals.CurrentScene = self
	input_handler.SetMusic("towntheme")

	var speedvalues = [0,1,10]
	var tooltips = [tr('PAUSEBUTTONTOOLTIP'),tr('NORMALBUTTONTOOLTIP'),tr('FASTBUTTONTOOLTIP')]
	var counter = 0
	for i in timebuttons:
		i.hint_tooltip = tooltips[counter]
		i.connect("pressed",self,'changespeed',[i])
		i.set_meta('value', speedvalues[counter])
		counter += 1

	######Vote stuff

	input_handler.connect("QuestStarted", self, "VotePanelShow")
	$VotePanel/Links.connect("pressed", self, "VoteLinkOpen")
	$VotePanel/Close.connect("pressed", self, "VotePanelClose")

	####

	if debug == true:
#		$ExploreScreen/combat/ItemPanel/debugvictory.show()
#		state.OldEvents['Market'] = 0
#		state.townupgrades['bridge'] = 1
#		state.townupgrades.blacksmith = 0
#		state.OldEvents['bridge'] = 0
		state.MakeQuest("demofinish")
		state.completedquests.append('elves')
		#state.FinishQuest('elves')
		state.MakeQuest("demitrus")
		state.areaprogress.cavedemitrius = 9
		for i in state.materials:
			state.materials[i] = 20
#		state.materials.goblinmetal = 20
#		state.materials.wood = 20
#		state.materials.elvenwood = 20
		#state.townupgrades.lumbermill = 1
		state.decisions.append("blacksmith")
#		var hero = combatantdata.MakeCharacterFromData('arron')
		state.unlock_char('arron')
#		state.unlock_char('rose')
#		state.unlock_char('erika')
#		state.unlock_char('ember')
#		state.unlock_char('rilu')
#		state.unlock_char('iola')
#		hero = combatantdata.MakeCharacterFromData('rose')
#		combatantdata.MakeCharacterFromData('erika')
#		combatantdata.MakeCharacterFromData('ember')
		var x = 5
		while x > 0:
			x -= 1
			for i in state.heroes.values():
				i.levelup()
#		var _worker = worker.new()
#		_worker.create(TownData.workersdict.goblin)
		#_worker.energy = 0
		#isn't this ^ requied?
#		_worker = worker.new()
#		_worker.create(TownData.workersdict.elf)
#		_worker.energy = 0
		#globals.AddItemToInventory(globals.crea
#		globals.AddItemToInventory(globals.CreateGearItem('axe', {ToolHandle = 'wood', Blade = 'wood'}))
		#state.items[0].durability = floor(rand_range(1,5))
#		globals.AddItemToInventory(globals.CreateGearItem('axe', {ToolHandle = 'wood', Blade = 'elvenwood'}))
#		globals.AddItemToInventory(globals.CreateGearItem('basicchest', {ArmorBase = 'goblinmetal', ArmorTrim = 'wood'}))
#		globals.AddItemToInventory(globals.CreateGearItem('basicchest', {ArmorBase = 'cloth', ArmorTrim = 'wood'}))
#		globals.AddItemToInventory(globals.CreateGearItem('sword', {ToolHandle = 'elvenwood', Blade = 'goblinmetal'}))
		globals.AddItemToInventory(globals.CreateUsableItem('morsel', 2))
		globals.AddItemToInventory(globals.CreateUsableItem('barricade', 2))
		globals.AddItemToInventory(globals.CreateUsableItem('protectivecharm', 2))


#	globals.call_deferred('EventCheck');
#	changespeed($"TimeNode/0speed", false)
	input_handler.connect("UpgradeUnlocked", self, "buildscreen")
	input_handler.connect("EventFinished", self, "buildscreen")
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
	set_process(true)


func VotePanelShow(quest):
	if quest == 'demofinish' && state.votelinksseen == false && debug == false:
		$VotePanel.show()
		state.votelinksseen = true


func VoteLinkOpen():
	OS.shell_open("https://forms.gle/fADzTnSbg94HauBP8")
	OS.shell_open("https://forms.gle/5qHPJ57ngB61LuBq6")


func VotePanelClose():
	$VotePanel.hide()



func buildscreen(empty = null):
	for build in globals.upgradelist:
		var node = get_node(build)
		if node != null: node.build_icon()

		binded_events[build] = globals.check_signal_test('BuildingEntered', build)

		if binded_events[build] != null:
			node.set_active()
		else:
			node.set_inactive()


func _process(delta):
	if self.visible == false:
		return
#	$TimeNode/HidePanel.visible = gamepaused_nonplayer
#	settime()
#
#	#buildscreen()
#
#	if gamepaused == false:
#		for i in get_tree().get_nodes_in_group("pauseprocess"):
#			if i.visible == true:
#				previouspeed = gamespeed
#				changespeed(timebuttons[0], false)
#				gamepaused = true
#				gamepaused_nonplayer = true
#	else:
#		var allnodeshidden = true
#		for i in get_tree().get_nodes_in_group("pauseprocess"):
#			if i.visible == true:
#				allnodeshidden = false
#				break
#
#
#
#		if allnodeshidden == true && gamepaused_nonplayer == true:
#			restoreoldspeed(previouspeed)
#			gamepaused_nonplayer = false
#			gamepaused = false
#
#	if gamespeed != 0:
#		state.daytime += delta * gamespeed
#
#		for i in state.heroes.values():
#			i.regen_tick(delta*gamespeed)
#
#		movesky()
#		if daycolorchange == false:
#
#			if floor(state.daytime) == 0.0:
#				EnvironmentColor('morning')
#				yield(get_tree().create_timer(1), "timeout")
#				input_handler.PlaySoundIsolated("morning", 1) #prevents multiple sounds stacking
#
#			elif floor(state.daytime) == floor(variables.TimePerDay/4):
#				EnvironmentColor('day')
#			elif floor(state.daytime) == floor(variables.TimePerDay/4*2):
#				EnvironmentColor('evening')
#			elif floor(state.daytime) == floor(variables.TimePerDay/4*3):
#				EnvironmentColor('night')


#func movesky():
#	$Sky.region_rect.position.x += gamespeed
#	if $Sky.region_rect.position.x > 3500:
#		$Sky.region_rect.position.x = -500
#
#var currenttime

#
#func changespeed(button, playsound = true):
#	var oldvalue = gamespeed
#	var newvalue = button.get_meta('value')
#	for i in timebuttons:
#		i.pressed = i == button
#	gamespeed = newvalue
#	var soundarray = ['time_stop', 'time_start', 'time_up']
#	if oldvalue != newvalue && playsound:
#		input_handler.PlaySound(soundarray[int(button.name[0])])
#
#	gamepaused = newvalue == 0
#	input_handler.emit_signal("SpeedChanged", gamespeed)
#
#
#func restoreoldspeed(value):
#	for i in timebuttons:
#		if i.get_meta("value") == value:
#			changespeed(i, false)

#
#func settime():
#	if state.daytime > variables.TimePerDay:
#		state.date += 1
#		state.daytime = 0
#	$TimeNode/Date.text = tr("DAY") + ": " + str(state.date)
#	$TimeNode/TimeWheel.rect_rotation = (state.daytime / variables.TimePerDay * 360) - 90
#
#func EnvironmentColor(time, instant = false):
#	var morning = Color8(229,226,174)
#	var day = Color8(255,255,255)
#	var night = Color8(73,73,91)
#	var evening = Color8(120, 96, 96)
#	var tween = input_handler.GetTweenNode(self)
#	var array = [$Background, $Sky, $WorkBuildNode, $TavernNode, $BlacksmithNode, $Gate, $TownHallNode]
#
#	var currentcolor
#	var nextcolor
#
#	var changetime = 2
#
#	if instant == true:
#		changetime = 0.01
#
#	if currenttime != time:
#		daycolorchange = true
#		match time:
#			'morning':
#				currentcolor = night
#				nextcolor = morning
#				#tween.inte
#				tween.interpolate_property($NightSky, 'modulate', Color(1,1,1,1), Color(1,1,1,0), changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#			'day':
#				currentcolor = morning
#				nextcolor = day
#			'evening':
#				currentcolor = day
#				nextcolor = evening
#				tween.interpolate_property($NightSky, 'modulate', Color(1,1,1,0), Color(1,1,1,0.5), changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#			'night':
#				currentcolor = evening
#				nextcolor = night
#				tween.interpolate_property($NightSky, 'modulate', Color(1,1,1,0.5), Color(1,1,1,1), changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#		currenttime = time
#		for i in array:
#			tween.interpolate_property(i, 'modulate', currentcolor, nextcolor, changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#			tween.start()
#		tween.interpolate_callback(self, changetime, 'finishcolorchange')
#
#
#func finishcolorchange():
#	daycolorchange = false


func building_entered(b_name):
	if binded_events[b_name] != null:
		globals.StartEventScene(binded_events[b_name])
		yield(input_handler, "EventFinished")
		buildscreen()
	else:
		match b_name:
			'townhall': OpenTownhall()
			'forge': openblacksmith()
			'market': openmarket()
			'bridge': ReturnToMap()
			_: pass #todo


func OpenTownhall():
	$TownHall.open()


func OpenSlaveMarket():
	$SlaveMarket.open()


func openblacksmith():
	$blacksmith.open()


func openherohiretab():
	$herohire.show()

func openmarket():
	pass

func ReturnToMap():
	hide()
	input_handler.CurrentScreen = 'Map'
