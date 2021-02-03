extends Control

var positiondict = {
	1 : "Positions/HBoxContainer/frontrow/1",
	2 : "Positions/HBoxContainer/frontrow/2",
	3 : "Positions/HBoxContainer/frontrow/3",
	4 : "Positions/HBoxContainer/backrow/4",
	5 : "Positions/HBoxContainer/backrow/5",
	6 : "Positions/HBoxContainer/backrow/6",
	
}

var charpanel = load("res://assets/images/gui/combat/combatpanel.png")

func _ready():
#warning-ignore:return_value_discarded
	$AreaProgress/ProceedButton.connect("pressed", self, "startexploration")
#warning-ignore:return_value_discarded
	$areaspanel/Return.connect("pressed", self, "ReturnToVillage")
	globals.CurrentScene = self
	for i in positiondict:
#warning-ignore:return_value_discarded
		get_node(positiondict[i]).connect('pressed', self, 'selectfighter', [i])



func show():
	input_handler.BlackScreenTransition(0.5)
	yield(get_tree().create_timer(0.5), 'timeout')
	
	.show()
	state.CurBuild = 'ExploreScreen'
	input_handler.CurrentScreen = 'Explore'
	$HeroList.open()
#	state.combatparty[1] = state.heroes[0].id
#	state.combatparty[2] = state.heroes[1].id
#	state.heroes[1].mana = 10
	UpdatePositions()
	showexplorelist()
	#2rework
	if state.currentarea != null && Explorationdata.areas[state.currentarea].stages < state.areaprogress[state.currentarea]:
		updateexplorepanel(Explorationdata.areas[state.currentarea])
	else:
		$AreaProgress.hide()

func hide():
	input_handler.BlackScreenTransition(0.5)
	yield(get_tree().create_timer(0.5), 'timeout')
	state.CurBuild = '';
	.hide()


var SelectingPosition


func selectfighter(pos):
	SelectingPosition = pos
	globals.HeroSelect(self, 'heroposition', 'HeroSelected', 'any')
	input_handler.ShowGameTip('explorepositioning')

func HeroSelected(hero):
	if hero == null:
		state.combatparty[SelectingPosition] = null
		UpdatePositions() 
		return
	
	var positiontaken = false
	var oldheroposition = null
	if state.combatparty[SelectingPosition] != null:
		positiontaken = true
	
	for i in state.combatparty:
		if state.combatparty[i] == hero.id:
			oldheroposition = i
			state.combatparty[i] = null
	
	if oldheroposition != null && positiontaken == true:
		state.combatparty[oldheroposition] = state.combatparty[SelectingPosition]
	
	state.combatparty[SelectingPosition] = hero.id
	UpdatePositions()


var encountercode


func StartCombat(data):
	var enemygroup = {}
	var enemies
	var music = 'combattheme'
	if typeof(data) == TYPE_ARRAY:
		enemies = data.duplicate()
		for i in data:
			var currentgroup = Enemydata.randomgroups[i]
			if state.checkreqs(currentgroup.reqs) == false:
				continue
			enemygroup[i] = currentgroup
		enemygroup = input_handler.weightedrandom(enemygroup.values())
		enemies = makerandomgroup(enemygroup)
	else:
		enemies = makespecificgroup(data)
	
	input_handler.emit_signal("CombatStarted", encountercode)
	input_handler.BlackScreenTransition(0.5)
	yield(get_tree().create_timer(0.5), 'timeout')
	$combat.encountercode = encountercode 
	$combat.start_combat(enemies, area.level, area.category, music)
	$combat.show()


func makespecificgroup(group): #to remake
	var enemies = Enemydata.predeterminatedgroups[group]
	var combatparty = {1 : null, 2 : null, 3 : null, 4:null, 5:null, 6:null}
	for i in enemies.group:
		combatparty[i] = enemies.group[i]
	
	var res = [combatparty.duplicate()]
	return res
	

func makerandomgroup(enemygroup):#to remake
	var array = []
	for i in enemygroup.units:
		var size = round(rand_range(enemygroup.units[i][0],enemygroup.units[i][1]))
		if size != 0:
			array.append({units = i, number = size})
	var countunits = 0
	for i in array:
		countunits += i.number
	if countunits > 6:
		#potential error
		#array[randi()%array.size()].size - (countunits-6)
		array[randi()%array.size()].number -= (countunits-6)
	
	#Assign units to rows
	var combatparty = {1 : null, 2 : null, 3 : null, 4 : null, 5 : null, 6 : null}
	for i in array:
		var unit = Enemydata.enemylist[i.units]
		while i.number > 0:
			var temparray = []
			
			if true:
				#smart way
				for ii in combatparty:
					if combatparty[ii] != null:
						continue
					if unit.aiposition == 'melee' && ii in [1,2,3]:
						temparray.append(ii)
					if unit.aiposition == 'ranged' && ii in [4,5,6]:
						temparray.append(ii)
				
				if temparray.size() <= 0:
					for ii in combatparty:
						if combatparty[ii] == null:
							temparray.append(ii)
			else:
				#stupid way
				for ii in combatparty:
					if combatparty[ii] != null:
						temparray.append(ii)
			
			
			
			combatparty[temparray[randi()%temparray.size()]] = i.units
			i.number -= 1
	
	encountercode = enemygroup.code
	var res = [combatparty.duplicate()]
	return res


func ReturnToVillage():
	hide()
	input_handler.CurrentScreen = 'Town'


func ReturnToMap():
	hide()
	input_handler.CurrentScreen = 'Map'


func UpdatePositions():
	for i in positiondict.values():
		get_node(i+'/Image').hide()
	
	for i in range(1, 3):
		if state.combatparty[i] != null:
			get_node(positiondict[i] + "/Image").texture = state.heroes[state.combatparty[i]].portrait()
			get_node(positiondict[i] + "/Image").show()
	$AreaProgress/ProceedButton.disabled = state.if_party_level('lte', 0)
	if $AreaProgress/ProceedButton.disabled:
		$AreaProgress/ProceedButton.hint_tooltip = "You must assign party before venturing"
	else:
		$AreaProgress/ProceedButton.hint_tooltip = ''

func openinventory(hero):
	$Inventory.open(hero)

#
#func showareas():
#	var container
#	globals.ClearContainer(container)
#	#what was this? and for what? did you forget to set container up?
#	for i in Explorationdata.areas:
#		var check = true
#		for k in i.requirements:
#			if state.valuecheck(k) == false:
#				check = false
#		if check == false: continue
#		var newbutton = globals.DuplicateContainerTemplate(container)
#		newbutton.text = i.name
#		newbutton.connect("pressed", self, "startexploration", [i])

#exploration vars
var location
var area
var stage
var period

func set_location(newloc):
	location = newloc
	if typeof(Explorationdata.locations[location].background) == TYPE_STRING:
		$BackGround.texture = resources.get_res("bg/%s" % Explorationdata.locations[location].background)#images.backgrounds[Explorationdata.locations[location].background]
	else:
		$BackGround.texture = Explorationdata.locations[location].background
	

func showexplorelist():
	globals.ClearContainer($areaspanel/ScrollContainer/VBoxContainer)
	for i in Explorationdata.areas.values():
		if i.category != location : continue
		if !Explorationdata.check_area_avail(i): continue
		var newbutton = globals.DuplicateContainerTemplate($areaspanel/ScrollContainer/VBoxContainer)
		newbutton.get_node("Label").text = "%s - %d lv." % [i.name, i.level]
		newbutton.connect("pressed", self, 'updateexplorepanel', [i])


func updateexplorepanel(newarea = null):
	$AreaProgress.show()
	input_handler.ShowGameTip('explore')
	if newarea != null:
		area = newarea
#	else:
#		area = newarea
	if state.areaprogress.has(area.code):
		stage = state.areaprogress[area.code]
	else:
		stage = 0
		state.areaprogress[area.code] = stage
	state.currentarea = area.code
	period = 'prefight'
	$AreaProgress/Label.text = area.name
	$AreaProgress/TextureRect.texture = resources.get_res("bg/%s" % area.category)#images.backgrounds[area.category]
	var text = ''
	if area.stages > 0:
		$AreaProgress/ProgressBar.value = globals.calculatepercent(stage, area.stages)
		text = tr("PROGRESS") + ": " + str(stage) + '/' + str(area.stages)
	else:
		$AreaProgress/ProgressBar.value = 100
		text = tr("AREAISENDLESS")
	$AreaProgress/Label2.text = text


func startexploration():
	period = 'fight'
	stage += 1
	if area.stagedenemies.has(int(stage)):
		StartCombat(area.stagedenemies[stage])
	else:
		StartCombat(area.enemygroups)


func wincontinue():
	state.areaprogress[area.code] = stage
	for i in state.heroes.values():
		if i.hp <= 0:
			i.hp = 1
			i.defeated = false
	
	if stage >= area.stages && area.stages > 0:
		showexplorelist()
		$AreaProgress.hide()
	else:
		updateexplorepanel(area)


func levelupscheck():
	for i in state.heroes.values():
		if i.recentlevelups > 0:
			levelupwindow(i)
			return


func levelupwindow(character):
	pass
#	$LevelupTrait.levelup(character)
#	character.recentlevelups -= 1
