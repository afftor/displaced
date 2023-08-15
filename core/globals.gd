extends Node

# warning-ignore-all:warning-id

const gameversion = '0.1.3'

#const worker = preload("res://files/scripts/worker.gd");
#const Item = preload("res://src/ItemClass.gd")
#const combatant = preload ('res://src/combatant.gd')

var SpriteDict = {}
var TranslationData = {}
var CurrentScene #holds reference to instanced scene

#var EventList = events.checks

var scenedict = {
	menu = "res://files/scenes/Menu.tscn",
	town = "res://files/scenes/village/MainScreen_new.tscn",
	map = "res://files/scenes/map/map.tscn"
}

var events_path = "res://assets/data/events"

#var items
#var TownData
var workersdict
#var enemydata
var randomgroups

var enemylist

#var skillsdata
#var effectdata

#var combatantdata = load("res://files/CombatantClass.gd").new()

#var classes = combatantdata.classlist
#var characters = combatantdata.charlist
var skills
var effects
var combateffects
var explorationares

var rng := RandomNumberGenerator.new()

#var gearlist = ['helm', 'chest', 'gloves', 'boots', 'rhand', 'lhand', 'neck', 'ring1', 'ring2']
var gearlist = ['weapon1', 'weapon2', 'armor']
var file = File.new()
var dir = Directory.new()

var LocalizationFolder = "res://localization/"
#var state

var userfolder = 'user://'

#var images = load("res://files/scripts/ResourceImages.gd").new()
#var audio = load("res://files/scripts/ResourceAudio.gd").new()
var scenes = {}

#var combat_node

var hotkeys_handler

var hexcolordict = {
	red = '#ff0000',
	yellow = "#ffff00",
	brown = "#8B572A",
	gray = "#4B4B4B",
	green = '#00b700',
}
var textcodedict = {
	color = {start = '[color=', end = '[/color]'},
	url = {start = '[url=',end = '[/url]'}
}

var globalsettings = {
	ActiveLocalization = 'en',
	mastervol = -15,
	mastermute = false,
	musicvol = -20,
	musicmute = false,
	soundvol = -15,
	soundmute = false,

	#Window settings
	fullscreen = true,
	window_size = Vector2(1366,768),
	window_pos = Vector2(0,0),

	textspeed = 60,
	skipread = false,
	textmonocolor = false,
	warnseen = false,
	disabletips = false,
	disable_tutorial = false,
	
	tuts_enabled = false
} setget settings_save

func settings_load():
	var config = ConfigFile.new()
	if file.file_exists(userfolder + "Settings.ini") == false:
		settings_save(globalsettings)
	config.load(userfolder + "Settings.ini")
	var settings = config.get_section_keys("settings")
	for i in settings:
		globalsettings[i] = config.get_value("settings", i, null)
	if config.has_section("hotkeys"):
		var hotkeys :Dictionary
		var hotkeys_keys = config.get_section_keys("hotkeys")
		for i in hotkeys_keys:
			hotkeys[i] = config.get_value("hotkeys", i)
		hotkeys_handler.deserialize(hotkeys)
	#updatevolume
	var counter = 0
	for i in ['master','music','sound']:
		AudioServer.set_bus_mute(counter, globalsettings[i+'mute'])
		AudioServer.set_bus_volume_db(counter, globalsettings[i+'vol'])
		counter += 1


func settings_save(value):
	globalsettings = value
	var config = ConfigFile.new()
	config.load(userfolder + "Settings.ini")
	for i in globalsettings:
		config.set_value('settings', i, globalsettings[i])
	if config.has_section('hotkeys'):
		config.erase_section('hotkeys')
	var hotkeys :Dictionary = hotkeys_handler.serialize()
	for i in hotkeys:
		config.set_value('hotkeys', i, hotkeys[i])
	config.save(userfolder + "Settings.ini")

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		globalsettings.window_size = OS.window_size
		globalsettings.window_pos = OS.window_position
		settings_save(globalsettings)
		get_tree().quit()

func _init():
	if dir.dir_exists(userfolder + 'saves') == false:
		dir.make_dir(userfolder + 'saves')
	
	#Storing available translations
	for i in scanfolder(LocalizationFolder):
		for ifile in dir_contents(i):
			TranslationData[i.replace(LocalizationFolder, '')] = ifile
#			file.open(ifile, File.READ)
#			var data = file.get_as_text()
#	for i in dir_contents(LocalizationFolder):
#		TranslationData[i.replace(LocalizationFolder + '/', '').replace('.gd','')] = i
	
	#Applying active translation
	var activetranslation = Translation.new()
	var translationscript = load(TranslationData[globalsettings.ActiveLocalization]).new()
	activetranslation.set_locale(globalsettings.ActiveLocalization)
	for i in translationscript.TranslationDict:
		activetranslation.add_message(i, translationscript.TranslationDict[i])
	TranslationServer.add_translation(activetranslation)


func preload_backgrounds():
	var path = resources.RES_ROOT.bg + '/bg'
	var dir = dir_contents(path)
	if dir != null:
		for fl in dir:
			if fl.ends_with('.import'): continue
			resources.preload_res(fl.trim_prefix(resources.RES_ROOT.bg + '/').trim_suffix('.' + resources.RES_EXT.bg))
	path = resources.RES_ROOT.bg + '/abg'
	dir = dir_contents(path)
	if dir != null:
		for fl in dir:
			if fl.ends_with('.import'): continue
			resources.preload_res(fl.trim_prefix(resources.RES_ROOT.abg + '/').trim_suffix('.' + resources.RES_EXT.abg))
	if resources.is_busy(): yield(resources, "done_work") #not absolutely correct due to chance of no pathes processed to preloading


func _ready():
#	OS.window_size = Vector2(1280,720)
#	OS.window_position = Vector2(300,0)
	randomize()
	rng.randomize()
	hotkeys_handler = HotkeysHandler.new()
	#Settings and folders
	settings_load()
	OS.window_size = globalsettings.window_size
	OS.window_position = globalsettings.window_pos
	#LoadEventData()
#	if globalsettings.fullscreen == true:
#		OS.window_fullscreen = true
	#===Necessary to apply translation===

	#Items = load("res://files/Items.gd").new()
	#Enemydata = load("res://assets/data/enemydata.gd").new()
	#Skillsdata = load("res://assets/data/Skills.gd").new()
	#Effectdata = load("res://assets/data/Effects.gd").new()
	#TownData = load("res://files/TownData.gd").new()
	#Traitdata = load("res://assets/data/Traits.gd").new()
	#combatantdata = load("res://files/CombatantClass.gd").new()
	explorationares = load("res://assets/data/explorationareasdata.gd").new().areas

#	upgradelist = load("res://assets/data/upgradedata.gd").new().upgradelist

	#====================================

#	yield(preload_backgrounds(), 'completed')
#	print("Backgrounds preloaded")
	if resources.is_busy(): yield(resources, "done_work")
	print("preload finished")



func logupdate(text):
	state.logupdate(text)


#warning-ignore:unused_signal
signal scene_changed

func ChangeScene(name):
	input_handler.CloseableWindowsArray.clear()
	var loadscreen = load("res://files/scenes/LoadScreen.tscn").instance()
	get_tree().get_root().add_child(loadscreen)
	loadscreen.goto_scene(scenedict[name])


func StartGame():
	change_screen('map')
	if resources.is_busy(): yield(resources, "done_work")
	print('start')
	var output = run_seq('intro')
	if output == variables.SEQ_SCENE_STARTED :
		input_handler.curtains.show_inst(variables.CURTAIN_SCENE)

func run_seq(id, forced = false):
	if !state.check_sequence(id, forced): return
	if !state.OldSeqs.has(id): forced = false
	var output = run_actions_list(Explorationdata.scene_sequences[id].actions, forced)
	state.store_sequence(id)
	return output


#we may need to analyse this func further deep, so simple bool output for scene could make refactoring harder in future
func run_actions_list(list, replay = false) ->int:
	var stop_syncronous = false
	var output = variables.SEQ_NONE
	for action in list:
		match action.type:
			'scene':
				if stop_syncronous: break
				if action.has('reqs') and !state.checkreqs(action.reqs):
					continue #stub, for this can lead to missing unlock opportunity, cant simply unlock either
				stop_syncronous = play_scene(action.value, replay)
				if stop_syncronous:
					output = variables.SEQ_SCENE_STARTED
			'system':
				if !replay: state.system_action(action)
			'show_screen':
				if !replay: change_screen(action.value)
			'mission':
				if replay: continue
				if stop_syncronous: break
				stop_syncronous = true
				force_start_mission(action.value)
				if action.has('auto_advance') and action.auto_advance:
					input_handler.explore_node.auto_advance()
			'tutorial':
				if replay: continue
				TutorialCore.start_tut(action.value)
	return output


func change_screen(screen):
	match screen:
		'map', 'exploration':
			if input_handler.explore_node != null:
				input_handler.explore_node.hide()
			if input_handler.village_node != null and input_handler.village_node.visible:
				input_handler.village_node.ReturnToMap()
			if input_handler.combat_node != null: 
				input_handler.combat_node.hide()
		'mission':
			if state.activearea == null: return
			if input_handler.village_node != null: input_handler.village_node.hide()
			
#			input_handler.explore_node.area = state.activearea
			input_handler.explore_node.location = 'mission'
			input_handler.explore_node.show()
#			input_handler.explore_node.open_mission()
		'village':
			input_handler.explore_node.hide()
			if input_handler.village_node != null: input_handler.village_node.show()


func force_start_mission(mission_id):
	var missiondata = Explorationdata.areas[mission_id]
	if state.stashedarea != null:
		print("error - script missions interrupting")
	if state.activearea != null:
		state.stashedarea = state.activearea
	state.start_area(mission_id)
	change_screen('mission')


func play_scene(scene_id, enforce_replay = false, restore = false):
	if input_handler.scene_node == null:
		print("scene node not open")
		return false
	if !enforce_replay and state.OldEvents.has(scene_id):
		return false
	state.CurEvent = scene_id
	input_handler.OpenUnfade(input_handler.scene_node)
#	if scene_id != 'intro_1': #not good but no other way currently
#		input_handler.OpenUnfade(input_handler.scene_node)
#	else:
#		input_handler.OpenInstant(input_handler.scene_node)
	input_handler.scene_node.replay_mode = state.OldEvents.has(scene_id)
	input_handler.scene_node.play_scene(scene_id, restore)
	return true


func CreateUsableItem(item, amount = 1): #obsolete, but keep for now
#	var newitem = Item.new()
#	newitem.CreateUsable(item, amount)
#	return newitem
	state.add_materials(item, amount)


func dir_contents(target):
	var dir = Directory.new()
	var array = []
	if dir.open(target) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				array.append(target + "/" + file_name)
			elif !file_name in ['.','..', null] && dir.current_is_dir():
				array += dir_contents(target + "/" + file_name)
			file_name = dir.get_next()
		return array
	else:
		print("An error occurred when trying to access the path.")

func evaluate(input): #used to read strings as conditions when needed
	var script = GDScript.new()
	script.set_source_code("func eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	return obj.eval()



func connecttooltip(node, text):
	if node.is_connected("mouse_entered",self,'showtooltip'):
		node.disconnect("mouse_entered",self,'showtooltip')
	node.connect("mouse_entered",self,'showtooltip', [text,node])

func disconnecttooltip(node):
	if node.is_connected("mouse_entered",self,'showtooltip'):
		node.disconnect("mouse_entered",self,'showtooltip')

#func connectitemtooltip(node, item):
#	if node.is_connected("mouse_entered",self,'showitemtooltip'):
#		node.disconnect("mouse_entered",self,'showitemtooltip')
#	node.connect("mouse_entered", self ,'showitemtooltip', [node, item])
#
#func showitemtooltip(targetnode, data):
#	var node = input_handler.get_spec_node(input_handler.NODE_ITEMTOOLTIP)#GetItemTooltip()
#	node.showup(targetnode, data)

func connectitemtooltip(node, item):
	if node.is_connected("mouse_entered",self,'showitemtooltip'):
		node.disconnect("mouse_entered",self,'showitemtooltip')
	node.connect("mouse_entered", self ,'showitemtooltip', [node, item])

func showitemtooltip(targetnode, data):
	var node = input_handler.get_spec_node(input_handler.NODE_ITEMTOOLTIP)#GetItemTooltip()
	node.showup_usable(targetnode, data)

func connectgeartooltip(node, item):
	if node.is_connected("mouse_entered",self,'showgeartooltip'):
		node.disconnect("mouse_entered",self,'showgeartooltip')
	node.connect("mouse_entered", self ,'showgeartooltip', [node, item])

func showgeartooltip(targetnode, data):
	var node = input_handler.get_spec_node(input_handler.NODE_ITEMTOOLTIP)#GetItemTooltip()
	node.showup_gear(targetnode, data)

#func connectslottooltip(node, hero_id, slot, position = Vector2(0, 0)):
#	if node.is_connected("mouse_entered",self,'showslottooltip'):
#		node.disconnect("mouse_entered",self,'showslottooltip')
#	node.connect("mouse_entered", self ,'showslottooltip', [node, hero_id, slot, position])
#	if !node.is_connected("mouse_exited", self ,'hideslottooltip'):
#		node.connect("mouse_exited", self ,'hideslottooltip')
#	if !node.is_connected("hide", self ,'hideslottooltip'):
#		node.connect("hide", self ,'hideslottooltip')

func showslottooltip(hero_id, slot, position):#targtenode
	var node = input_handler.get_spec_node(input_handler.NODE_GEARTOOLTIP)
	node.showup(hero_id, slot, position)

func hideslottooltip():
	var node = input_handler.get_spec_node(input_handler.NODE_GEARTOOLTIP)
	node.hide()


func connectskilltooltip(node, character_id, skill):
	if node.is_connected("mouse_entered",self,'showskilltooltip'):
		node.disconnect("mouse_entered",self,'showskilltooltip')
	node.connect("mouse_entered",self,'showskilltooltip', [skill, node, character_id])
	if !node.is_connected("mouse_exited", self ,'hideskilltooltip'):
		node.connect("mouse_exited", self ,'hideskilltooltip')

func showskilltooltip(skill, node, character_id):
	var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)
	skilltooltip.showup(node, character_id, skill)
	var pos = node.get_global_rect()
	var pos2 = skilltooltip.rect_size
#	pos = Vector2(pos.end.x - pos2.x, pos.position.y - pos2.y)
	pos = Vector2(pos.position.x + pos.size.x * 0.5 - pos2.x * 0.5,
		pos.position.y - pos2.y)
	skilltooltip.set_global_position(pos)


func hideskilltooltip():
	var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)
	skilltooltip.hide()

#func disconnectitemtooltip(node, item):
#	if node.is_connected("mouse_entered",item,'tooltip'):
#		node.disconnect("mouse_entered",item,'tooltip')

func connectmaterialtooltip(node, material):
	if node.is_connected("mouse_entered",self,'mattooltip'):
		node.disconnect("mouse_entered",self,'mattooltip')
	node.connect("mouse_entered",self,'mattooltip', [node, material])

func mattooltip(targetnode, material):
	var image
	var node = input_handler.get_spec_node(input_handler.NODE_ITEMTOOLTIP)#GetItemTooltip()
	node.showup_material(targetnode, material)


func showtooltip(text, node):
	var screen = get_viewport().get_visible_rect()
	var tooltip
	if get_tree().get_root().has_node("tooltip") == false:
		tooltip = load("res://files/Simple Tooltip/SimpleTooltip.tscn").instance()
		get_tree().get_root().add_child(tooltip)
		tooltip.name = 'tooltip'
	else:
		tooltip = get_tree().get_root().get_node('tooltip')
	tooltip.get_node("RichTextLabel").bbcode_text = text
	var pos = node.get_global_rect()
	pos = Vector2(pos.position.x, pos.end.y + 10)
	tooltip.set_global_position(pos)
	tooltip.showup(node, text)
#	tooltip.get_node("RichTextLabel").rect_size.y = tooltip.get_node("RichTextLabel").get_v_scroll().get_max()
#	tooltip.rect_size.y = tooltip.get_node("RichTextLabel").rect_size.y + 30
#	if tooltip.get_rect().end.x >= screen.size.x:
#		tooltip.rect_global_position.x -= tooltip.get_rect().end.x - screen.size.x
#	if tooltip.get_rect().end.y >= screen.size.y:
#		tooltip.rect_global_position.y -= tooltip.get_rect().end.y - screen.size.y

func hidetooltip(empty = null):
	if get_tree().get_root().has_node("tooltip") == false:
		var tooltip = load("res://files/Simple Tooltip/SimpleTooltip.tscn").instance()
		get_tree().get_root().add_child(tooltip)
		tooltip.name = 'tooltip'
	get_tree().get_root().get_node("tooltip").parentnode = null
	get_tree().get_root().get_node("tooltip").hide()

func RomanNumberConvert(value):
	var rval = ''
	match value:
		1:
			rval = 'I'
		2:
			rval = 'II'
		3:
			rval = 'III'
		4:
			rval = 'IV'
		5:
			rval = 'V'
		6:
			rval = 'VI'
		7:
			rval = 'VII'
		8:
			rval = 'VIII'
		9:
			rval = 'IX'
		10:
			rval = 'X'

func AddPanelOpenCloseAnimation(node):
	if node.get_script() == null:
		node.set_script(load("res://files/Close Panel Button/ClosingPanel.gd"))
	node._ready()

func MaterialTooltip(value):
	var text = '[center][color=yellow]' + Items.Items[value].name + '[/color][/center]\n' + Items.Items[value].description + '\n\n' + tr("INPOSESSION") + ': ' + str(state.materials[value])
	return text




func TextEncoder(text, node = null):
	var tooltiparray = []
	var counter = 0
	while text.find("{") != -1:
		var newtext = text.substr(text.find("{"), text.find("}") - text.find("{")+1)
		var newtextarray = newtext.split("|")
		var originaltext = newtextarray[newtextarray.size()-1].replace("}",'')
		newtextarray.remove(newtextarray.size()-1)
		var startcode = ''
		var endcode = ''
		for data in newtextarray:
			data = data.replace('{','').split("=")

			match data[0]:
				'color':
					startcode += '[color=' + hexcolordict[data[1]] + ']'
					endcode = '[/color]' + endcode
				'url':
					tooltiparray.append(data[1])
					startcode += '[url=' + str(counter) + ']'
					endcode = '[/url]' + endcode
					counter += 1


		text = text.replace(newtext, startcode + originaltext + endcode)
	if node != null:
		node.bbcode_text = text
		if tooltiparray.size() != 0:
			node.set_meta('tooltips', tooltiparray)
			if node.is_connected("meta_hover_started", self, "BBCodeTooltip") == false:
				node.connect("meta_hover_started", self, "BBCodeTooltip", [node])
				node.connect("meta_hover_ended",self, 'hidetooltip')
	else:
		return text

func BBCodeTooltip(meta, node):
	var text = node.get_meta('tooltips')[int(meta)]
	showtooltip(text, node)

func CharacterSelect(targetscript, type, function, requirements):
	var node
	if get_tree().get_root().has_node("CharacterSelect"):
		node = get_tree().get_root().get_node("CharacterSelect")
		get_tree().get_root().remove_child(node)
		get_tree().get_root().add_child(node)
	else:
		node = load("res://WorkerSelect.tscn").instance()
		node.name = 'CharacterSelect'
		get_tree().get_root().add_child(node)
		AddPanelOpenCloseAnimation(node)

	node.show()
	#node.set_as_toplevel(true)
	input_handler.ClearContainer(node.get_node("ScrollContainer/VBoxContainer"))

	var array = []
#	if type == 'workers':
#		array = state.workers.values()

	for i in array:
		if requirements == 'notask' && i.task != null:
			continue
		var newnode = input_handler.DuplicateContainerTemplate(node.get_node("ScrollContainer/VBoxContainer"))
		newnode.get_node("Label").text = i.name
		newnode.get_node("Icon").texture = load(i.icon)
		newnode.get_node("Energy").text = str(i.energy) + '/' + str(i.maxenergy)
		newnode.connect('pressed', targetscript, function, [i.id])
		newnode.connect('pressed',self,'CloseSelection', [node])


func CloseSelection(panel):
	panel.hide()


func closeskilltooltip():
	#var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)
	var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)#GetSkillTooltip()
	skilltooltip.set_process(false)
	skilltooltip.hide()


func calculatepercent(value1, value2):
	return value1*100/max(value2,1)


func AddOrIncrementDict(dict, newdict):
	for i in newdict:
		if dict.has(i):
			dict[i] += newdict[i]
		else:
			dict[i] = newdict[i]


func MergeDicts(dict1, dict2, overwrite = false):
	var returndict = dict1
	for i in dict2:
		if returndict.has(i) && overwrite == false:
			returndict[i] += dict2[i]
		else:
			returndict[i] = dict2[i]

	return returndict


func scanfolder(path): #makes an array of all folders in modfolder
	var dir = Directory.new()
	var array = []
	if dir.dir_exists(path) == false:
		dir.make_dir(path)
	if dir.open(path) == OK:
		dir.list_dir_begin()

		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() && !file_name in ['.','..',null]:
				array.append(path + file_name)
			file_name = dir.get_next()
		return array


func QuickSave():
	SaveGame('QuickSave');
	pass




func SaveGame(name):
#	if state.CurEvent != '':
#		state.CurrentLine = input_handler.get_spec_node(input_handler.NODE_EVENT).CurrentLine
	var savedict = state.serialize();
	file.open(userfolder + 'saves/' + name + '.sav', File.WRITE)
	file.store_line(to_json(savedict))
	file.close()


func LoadGame(filename):
	if !file.file_exists(userfolder+'saves/'+ filename + '.sav') :
		print("no file %s" % (userfolder+'saves/'+ filename + '.sav'))
		return

	input_handler.BlackScreenTransition(1)
	yield(get_tree().create_timer(1), 'timeout')
	input_handler.CloseableWindowsArray.clear()
	CurrentScene.queue_free()
	ChangeScene('map');
	yield(self, "scene_changed")

	file.open(userfolder+'saves/'+ filename + '.sav', File.READ)
	var savedict = parse_json(file.get_as_text())
	file.close()
	state.deserialize(savedict)
	CurrentScene.buildscreen()

	#here was state.CurBuild condition to open back building's window
	#for now it all removed so as CurBuild param in saving serialization in gamestate
	if state.CurrentScreen == 'Village':
		input_handler.village_node.show()

	#opentextscene
#	if state.CurEvent != "":
#		StartEventScene(state.CurEvent, false, state.CurrentLine);


func datetime_comp(a, b):
	if a.year > b.year: return true
	if a.month > b.month: return true
	if a.day > b.day: return true
	if a.hour > b.hour: return true
	if a.minute > b.minute: return true
	if a.second > b.second: return true
	return false
	pass


func get_last_save():
	var dir = dir_contents(userfolder + 'saves')

	if dir == null: return

	var dated_dir = {}
	var tmp = File.new()
	for i in dir_contents(userfolder + 'saves'):
		if i.ends_with('.sav') == false:
			continue
		dated_dir[i] = OS.get_datetime_from_unix_time(tmp.get_modified_time(i))
	if dated_dir.size() == 0: return null
	var b = dated_dir.keys()[0]
	for i in range(dated_dir.keys().size()):
		if datetime_comp(dated_dir[dated_dir.keys()[i]], dated_dir[b]):
			b = dated_dir.keys()[i]
	return b
	pass

func get_hotkeys_handler() ->Object:
	return hotkeys_handler


