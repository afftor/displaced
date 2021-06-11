extends Control

var debug = true

#warning-ignore-all:return_value_discarded
var gamespeed = 1
var gamepaused = false
var gamepaused_nonplayer = false
var previouspeed
var daycolorchange = false
var tasks #Task Data Dict var data = {function = selectedtask.triggerfunction, taskdata = selectedtask, time = 0, threshold = selectedtask.basetimer, worker = selectedworker, instrument = selectedtool}
onready var timebuttons = [$"TimeNode/0speed", $"TimeNode/1speed", $"TimeNode/2speed"]
onready var BS = $BlackScreen;

var sounds = {
	"defeat" : "sound/defeat",
	"morning" : "sound/morning_rooster",
	"time_stop" : "sound/time_stop",
	"time_start" : "sound/time_start",
	"time_up" : "sound/time_up"
}

func _ready():
	for i in sounds.values():
		resources.preload_res(i)
	if resources.is_busy(): yield(resources, "done_work")

	get_tree().set_auto_accept_quit(false)
	input_handler.SystemMessageNode = $SystemMessageLabel
	globals.CurrentScene = self
	tasks = state.tasks
	input_handler.SetMusic("towntheme")

	var speedvalues = [0,1,10]
	var tooltips = [tr('PAUSEBUTTONTOOLTIP'),tr('NORMALBUTTONTOOLTIP'),tr('FASTBUTTONTOOLTIP')]
	var counter = 0
	for i in timebuttons:
		i.hint_tooltip = tooltips[counter]
		i.connect("pressed",self,'changespeed',[i])
		i.set_meta('value', speedvalues[counter])
		counter += 1
	$ControlPanel/Inventory.connect('pressed',self,'openinventory')
	$ControlPanel/Slavelist.connect('pressed',self,'SlavePanelShow')
	$ControlPanel/Options.connect("pressed",self, 'openmenu')
	$ControlPanel/Herolist.connect('pressed',self, 'openherolist')
	$Gate.connect("pressed",self,'ReturnToMap')

	$GameOverPanel/ExitButton.connect("pressed",self,"GameOver")

	######Vote stuff

	input_handler.connect("QuestStarted", self, "VotePanelShow")
	$VotePanel/Links.connect("pressed", self, "VoteLinkOpen")
	$VotePanel/Close.connect("pressed", self, "VotePanelClose")

	####

	if debug == true:
		$ExploreScreen/combat/ItemPanel/debugvictory.show()
		state.OldEvents['Market'] = 0
		state.townupgrades['bridge'] = 1
		state.townupgrades.blacksmith = 0
		state.OldEvents['bridge'] = 0
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
	$testbutton.connect("pressed", self, "testfunction")
	changespeed($"TimeNode/0speed", false)
	input_handler.connect("UpgradeUnlocked", self, "buildscreen")
	input_handler.connect("EventFinished", self, "buildscreen")
	#$TutorialNode.activatetutorial(state.currenttutorial)
	buildscreen()
	yield(get_tree(),'idle_frame')
	if floor(state.daytime) >= 0 && floor(state.daytime) < floor(variables.TimePerDay/4):
		EnvironmentColor('morning', true)
	elif floor(state.daytime) >= floor(variables.TimePerDay/4) && floor(state.daytime) < floor(variables.TimePerDay/4*2):
		EnvironmentColor('day', true)
	elif floor(state.daytime) >= floor(variables.TimePerDay/4*2) && floor(state.daytime) < floor(variables.TimePerDay/4*3):
		EnvironmentColor('evening', true)
	elif floor(state.daytime) >= floor(variables.TimePerDay/4*3) && floor(state.daytime) < floor(variables.TimePerDay):
		EnvironmentColor('night',true)
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

var forgeimage = {
	base = {normal = load("res://assets/images/buildings/forge.png"), hl = load("res://assets/images/buildings/forge_hl.png")},
	first = {normal = load("res://assets/images/buildings/forge_1.png"), hl = load("res://assets/images/buildings/forge1_hl.png")},
	second = {normal = load("res://assets/images/buildings/forge_2.png"), hl = load("res://assets/images/buildings/forge2_hl.png")},

}


func buildscreen(empty = null):
	$Background/bridge.visible = state.townupgrades.has('bridge')
	$Background/mine.visible = state.townupgrades.has("mine")
	$Background/farm.visible = state.townupgrades.has("farm")
	$Background/house.visible = state.townupgrades.has("houses")
	$Background/lumbermill.visible = state.townupgrades.has("lumbermill")
	$BlacksmithNode.visible = state.decisions.has("blacksmith")
	if state.townupgrades.has('blacksmith') == false:
		$BlacksmithNode.regenerate_click_mask()
		$BlacksmithNode.texture_normal = forgeimage.base.normal
		#$BlacksmithNode.texture_hover = forgeimage.base.hl
	else:
		match state.townupgrades.blacksmith:
			1:
				$BlacksmithNode.regenerate_click_mask()
				$BlacksmithNode.texture_normal = forgeimage.first.normal
				#$BlacksmithNode.texture_hover = forgeimage.first.hl
			2:
				$BlacksmithNode.regenerate_click_mask()
				$BlacksmithNode.texture_normal = forgeimage.second.normal
				#$BlacksmithNode.texture_hover = forgeimage.second.hl

func testfunction():
	input_handler.gfx_sprite($testbutton, "slash")
	#input_handler.ActivateTutorial('tutorial1')

func _process(delta):
	if self.visible == false:
		return
	$TimeNode/HidePanel.visible = gamepaused_nonplayer
	settime()

	#buildscreen()

	if gamepaused == false:
		for i in get_tree().get_nodes_in_group("pauseprocess"):
			if i.visible == true:
				previouspeed = gamespeed
				changespeed(timebuttons[0], false)
				gamepaused = true
				gamepaused_nonplayer = true
	else:
		var allnodeshidden = true
		for i in get_tree().get_nodes_in_group("pauseprocess"):
			if i.visible == true:
				allnodeshidden = false
				break



		if allnodeshidden == true && gamepaused_nonplayer == true:
			restoreoldspeed(previouspeed)
			gamepaused_nonplayer = false
			gamepaused = false

	$ControlPanel/Gold.text = str(state.money)
	$ControlPanel/Food.text = str(state.food)

	$BlackScreen.visible = $BlackScreen.modulate.a > 0.0
	if gamespeed != 0:
		state.daytime += delta * gamespeed

		for i in state.heroes.values():
			i.regen_tick(delta*gamespeed)

		movesky()
#		for i in state.tasks:
#			i.time += delta*gamespeed
#			updatecounter(i)
#
#			if i.time >= i.threshold:
#				i.time -= i.threshold
#				taskperiod(i)
#				#call(i.function, i)
#
		if daycolorchange == false:

			if floor(state.daytime) == 0.0:
				EnvironmentColor('morning')
				yield(get_tree().create_timer(1), "timeout")
				input_handler.PlaySoundIsolated(sounds["morning"], 1) #prevents multiple sounds stacking

			elif floor(state.daytime) == floor(variables.TimePerDay/4):
				EnvironmentColor('day')
			elif floor(state.daytime) == floor(variables.TimePerDay/4*2):
				EnvironmentColor('evening')
			elif floor(state.daytime) == floor(variables.TimePerDay/4*3):
				EnvironmentColor('night')


func movesky():
	$Sky.region_rect.position.x += gamespeed
	if $Sky.region_rect.position.x > 3500:
		$Sky.region_rect.position.x = -500

var currenttime

func EnvironmentColor(time, instant = false):
	var morning = Color8(229,226,174)
	var day = Color8(255,255,255)
	var night = Color8(73,73,91)
	var evening = Color8(120, 96, 96)
	var tween = input_handler.GetTweenNode(self)
	var array = [$Background, $Sky, $WorkBuildNode, $TavernNode, $BlacksmithNode, $Gate, $TownHallNode]

	var currentcolor
	var nextcolor

	var changetime = 2

	if instant == true:
		changetime = 0.01

	if currenttime != time:
		daycolorchange = true
		match time:
			'morning':
				currentcolor = night
				nextcolor = morning
				#tween.inte
				tween.interpolate_property($NightSky, 'modulate', Color(1,1,1,1), Color(1,1,1,0), changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			'day':
				currentcolor = morning
				nextcolor = day
			'evening':
				currentcolor = day
				nextcolor = evening
				tween.interpolate_property($NightSky, 'modulate', Color(1,1,1,0), Color(1,1,1,0.5), changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			'night':
				currentcolor = evening
				nextcolor = night
				tween.interpolate_property($NightSky, 'modulate', Color(1,1,1,0.5), Color(1,1,1,1), changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		currenttime = time
		for i in array:
			tween.interpolate_property(i, 'modulate', currentcolor, nextcolor, changetime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		tween.interpolate_callback(self, changetime, 'finishcolorchange')

func finishcolorchange():
	daycolorchange = false

func buildcounter(task):
	var newnode = globals.DuplicateContainerTemplate($TaskCounter)
	newnode.get_node('Icon').texture = load(state.workers[task.worker].icon)
	newnode.get_node("Progress").value = globals.calculatepercent(task.time, task.threshold)
	newnode.connect("pressed", self, "OpenWorkerTask", [task])
	newnode.set_meta('task', task)
	task.counter = newnode


func updatecounter(task):
	if task.counter == null:
		return
	task.counter.get_node("Progress").value = globals.calculatepercent(task.time, task.threshold)

func deletecounter(task):
	task.counter.queue_free()

func OpenWorkerTask(task):
	$SlavePanel.BuildSlaveList()
	$SlavePanel.SelectSlave(task.worker)


func openmenu():
	if !$MenuPanel.visible:
		$MenuPanel.show()
	else:
		$MenuPanel.hide()

func openherolist():
	if $HeroList.visible == false:
		$HeroList.open()
	else:
		$HeroList.hide()


func OpenTownhall():
	$TownHall.open()

func OpenSlaveMarket():
	$SlaveMarket.open()

func changespeed(button, playsound = true):
	var oldvalue = gamespeed
	var newvalue = button.get_meta('value')
	for i in timebuttons:
		i.pressed = i == button
	gamespeed = newvalue
	var soundarray = [
		sounds['time_stop'],
		sounds['time_start'],
		sounds['time_up']
	]
	if oldvalue != newvalue && playsound:
		input_handler.PlaySound(soundarray[int(button.name[0])])

	gamepaused = newvalue == 0
	input_handler.emit_signal("SpeedChanged", gamespeed)

func restoreoldspeed(value):
	for i in timebuttons:
		if i.get_meta("value") == value:
			changespeed(i, false)

func settime():
	if state.daytime > variables.TimePerDay:
		state.date += 1
		state.daytime = 0
	$TimeNode/Date.text = tr("DAY") + ": " + str(state.date)
	$TimeNode/TimeWheel.rect_rotation = (state.daytime / variables.TimePerDay * 360) - 90

func FadeToBlackAnimation(time = 1):
	input_handler.UnfadeAnimation($BlackScreen, time)
	input_handler.emit_signal("ScreenChanged")
	input_handler.FadeAnimation($BlackScreen, time, time)


func openinventory(hero = null):
	$Inventory.open('hero', hero)

func openinventorytrade():
	$Inventory.open("shop")

func openblacksmith():
	$blacksmith.open()

func openherohiretab():
	$herohire.show()



func BuildingOptions(building = {}):
	var node = $BuildingOptions
	var targetnode = building.node
	globals.ClearContainer($BuildingOptions/VBoxContainer)
	node.popup()
	var pos = targetnode.get_global_rect()
	pos = Vector2(pos.position.x, pos.end.y + 10)
	node.set_global_position(pos)
#
#func assignworker(data):
#	buildcounter(data)
#	if data.instrument != null:
#		state.items[data.instrument].owner = data.worker
#	state.tasks.append(data)
#
#func stoptask(data):
#	deletecounter(data)
#	if data.instrument != null:
#		state.items[data.instrument].owner = null
#	state.tasks.erase(data)
#
#func taskperiod(data):
#	var taskdata = data.taskdata
#	var worker = state.workers[data.worker]
#	for i in taskdata.workerproducts[worker.type]:
#		#Calculate results and reward player
#
#		#Check if requirements are met
#		if randf()*100 >= i.chance:
#			continue
#
#		var taskresult = i.amount
#
#		if randf()*100 <= i.critchance:
#			taskresult = i.critamount
#			#print('crit triggered')
#
#
#
#
#		#Check if need to access multiple subcategory
#		if i.code.find('.') != -1:
#			var array = i.code.split('.')
#			if array[0] == 'materials':
#				state[array[0]][array[1]] += taskresult
#				while taskresult > 0:
#					flyingitemicon(data.counter, Items.Materials[array[1]].icon)
#					taskresult -= 1
#					yield(get_tree().create_timer(0.2),"timeout")
#			elif array[0] == 'usables':
#				globals.AddItemToInventory(globals.CreateUsableItem(array[1]))
#				flyingitemicon(data.counter, Items.Items[array[1]].icon)
#			yield(get_tree().create_timer(0.2),"timeout")
#		else:
#			state[i] += taskresult
#
#		#targetvalue
##		if data.instrument != null:
##			data.instrument.durability -= taskdata.tasktool.durabilityfactor
##			if data.instrument.durability <= 0:
##				stoptask(data)
#				#globals.logupdate(data.instrument.name + tr("TOOLBROKEN"))
#
#	worker.energy -= taskdata.energycost
#
#	if data.iterations > 0:
#		data.iterations -= 1
#		if data.iterations == 0:
#			stoptask(data)
#
#
#	if worker.energy < taskdata.energycost:
#		if data.autoconsume == true:
#			var state = worker.restoreenergy()
#			if state == false:
#				input_handler.SystemMessage("SYSNOFOOD")
#				stoptask(data)
#		else:
#			input_handler.SystemMessage("SYSNOWORKERENERGY")
#			stoptask(data)
#	elif data.instrument != null && state.items[data.instrument].durability <= 0 && taskdata.tasktool.required != false:
#		tasks.erase(data)

var itemicon = preload("res://files/scenes/ItemIcon.tscn")

func flyingitemicon(taskbar, icon):
	var x = itemicon.instance()
	add_child(x)
	x.texture = icon
	x.rect_global_position = taskbar.rect_global_position
	input_handler.PlaySound("itemget")
	input_handler.ResourceGetAnimation(x, taskbar.rect_global_position, $ControlPanel/Inventory.rect_global_position)
	yield(get_tree().create_timer(0.7), 'timeout')
	x.queue_free()




func _on_Lumber_pressed():
	$SelectWorker.show()
	$SelectWorker.OpenSelectTab(TownData.tasksdict.woodcutting)


func SlavePanelShow():
	$SlavePanel.BuildSlaveList()


func _on_Herolist_pressed():
	globals.ClearContainer($HeroList/VBoxContainer)
	for i in state.heroes.values():
		var newbutton = globals.DuplicateContainerTemplate($HeroList/VBoxContainer)
		newbutton.text = i.name
		newbutton.connect("pressed",self,'OpenHeroTab', [i])

func OpenHeroTab(hero):
	$HeroPanel.open(hero)

func openheroguild():
	$HeroGuild.open()

#func explorescreen():
#	if state.townupgrades.has('bridge'):
#		$ExploreScreen.show()
##		globals.call_deferred('EventCheck');
#	else:
#		input_handler.SystemMessage("Purchase 'Bridge' Upgrade first")

func ReturnToMap():
	hide()
	input_handler.CurrentScreen = 'Map'
