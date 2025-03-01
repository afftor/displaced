extends Node

# warning-ignore-all:warning-id

const gameversion = '1.0.2'
var release_steam = false
var release_demo = false
var opened_gallery = false

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

#var events_path = "res://assets/data/events"

#var items
#var TownData
#var workersdict
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
#var explorationares

var rng := RandomNumberGenerator.new()

#var gearlist = ['helm', 'chest', 'gloves', 'boots', 'rhand', 'lhand', 'neck', 'ring1', 'ring2']
var gearlist = ['weapon1', 'weapon2', 'armor']
var file = File.new()
var dir = Directory.new()

var LocalizationFolder = "res://localization/"
#var state

var userfolder = 'user://'
var save_path_template = userfolder + 'saves/%s.sav'

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
var save_screenshot :Image

const base_locale = 'en'
var localizations = [base_locale, 'ru']

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
#	disabletips = false,
	disable_tutorial = false,
	
#	tuts_enabled = false,#what is this?
	forced_content = true
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
	
	#Applying translation
	var base_dict
	assert(localizations[0] == base_locale, "base_locale has to be first in localizations array!")
	for locale_num in range(localizations.size()):
		var locale = localizations[locale_num]
		var activetranslation = Translation.new()
		var translation_data = load(TranslationData[locale]).new()
		var translation_dict = translation_data.TranslationDict
		#-------should probably be commented befor release------
		if locale_num == 0:
			base_dict = translation_dict
		else:
			var integrity_failure = false
			for i in base_dict:
				if !translation_dict.has(i):
					print("locale %s has no %s string" % [locale, i])
					integrity_failure = true
			if translation_dict.size() != base_dict.size():
				print("Locale %s has %d strings against %d" % 
					[locale, translation_dict.size(), base_dict.size()])
				integrity_failure = true
			assert(!integrity_failure, "Integrity failure for locale %s!" % locale)
		#--------------------------
		activetranslation.set_locale(locale)
		for i in translation_dict:
			activetranslation.add_message(i, translation_dict[i])
		TranslationServer.add_translation(activetranslation)
	#Settings and folders
	hotkeys_handler = HotkeysHandler.new()
	settings_load()
	TranslationServer.set_locale(globalsettings.ActiveLocalization)

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
	variables.tune_up_max_level()
#	OS.window_size = Vector2(1280,720)
#	OS.window_position = Vector2(300,0)
	randomize()
	rng.randomize()
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
#	explorationares = load("res://assets/data/explorationareasdata.gd").new().areas

#	upgradelist = load("res://assets/data/upgradedata.gd").new().upgradelist

	#====================================

#	yield(preload_backgrounds(), 'completed')
#	print("Backgrounds preloaded")
#	if resources.is_busy(): yield(resources, "done_work")
#	print("globals _ready finished")


func logupdate(text):
	state.logupdate(text)


#warning-ignore:unused_signal
signal scene_changed

func ChangeScene(name):
	input_handler.clear_closeable_windows()
	var loadscreen = load("res://files/scenes/LoadScreen.tscn").instance()
	get_tree().get_root().add_child(loadscreen)
	loadscreen.goto_scene(scenedict[name])


func StartGame():
	change_screen('map')
	if resources.is_busy(): yield(resources, "done_work")
#	print('start')
	var output = run_seq('intro')
	if output == variables.SEQ_SCENE_STARTED :
		input_handler.curtains.show_inst(variables.CURTAIN_SCENE)

func run_seq(id, force_replay = false):
	var replay = (force_replay or state.OldSeqs.has(id))
	if !replay and !state.check_sequence(id): return
	if Explorationdata.is_seq_needs_autosave(id):
		globals.auto_save()
	var output = run_actions_list(Explorationdata.scene_sequences[id].actions, replay)
	state.store_sequence(id)
	return output


#we may need to analyse this func further deep, so simple bool output for scene could make refactoring harder in future
#mind that 'list' can come from either sequence or postevent so 'replay' can have different nature (OldSeqs or OldEvents)
func run_actions_list(list, replay :bool) ->int:
	var stop_syncronous = false
	var output = variables.SEQ_NONE
	for action in list:
		if action.has('reqs') and !state.checkreqs(action.reqs):
			continue #stub, for this can lead to missing unlock opportunity, cant simply unlock either
		match action.type:
			'scene':
				if stop_syncronous: break
				stop_syncronous = play_scene(action.value)
				if stop_syncronous:
					output = variables.SEQ_SCENE_STARTED
			'system':
				if replay: continue
				state.system_action(action)
			'show_screen':
				if replay: continue
				var arg :String = ''
				if action.has('arg'): arg = action.arg
				change_screen(action.value, arg)
			'mission':
				if replay: continue#caution advised, event replay never should consider replaying mission
				if stop_syncronous: break
				stop_syncronous = true
				force_start_mission(action.value)
				if action.has('auto_advance') and action.auto_advance:
					input_handler.explore_node.auto_advance()
			'tutorial':
				if replay: continue
				TutorialCore.start_tut(action.value)
			'force_seq_seen':
				state.store_sequence(action.value)
	return output


func change_screen(screen, loc :String = ''):
	match screen:
		'map':
			if input_handler.explore_node != null:
				input_handler.explore_node.hide()
			if input_handler.village_node != null and input_handler.village_node.visible:
				input_handler.village_node.ReturnToMap()
			if input_handler.combat_node != null: 
				input_handler.combat_node.hide()
		'exploration':
			input_handler.map_node.location_pressed(loc)
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
#	var missiondata = Explorationdata.areas[mission_id]
#	if state.stashedarea != null:
#		print("error - script missions interrupting")
	if state.activearea != null:
		state.stop_area()#not really necessary, but better to be
#		state.stashedarea = state.activearea
	state.start_area(mission_id)
	change_screen('mission')


func play_scene(scene_id, restore = false):
	if input_handler.scene_node == null:
		print("scene node not open")
		return false
	state.CurEvent = scene_id
	input_handler.scene_node.show()
	input_handler.UnfadeAnimation(input_handler.scene_node)
#	if scene_id != 'intro_1': #not good but no other way currently
#		input_handler.OpenUnfade(input_handler.scene_node)
#	else:
#		input_handler.OpenInstant(input_handler.scene_node)
	input_handler.scene_node.play_scene(scene_id, restore)
	return true


#func CreateUsableItem(item, amount = 1): #obsolete, but keep for now
#	var newitem = Item.new()
#	newitem.CreateUsable(item, amount)
#	return newitem
#	state.add_materials(item, amount)


func dir_contents(target):
	var dir = Directory.new()
	var array = []
	if !dir.dir_exists(target):
		return array
	if dir.open(target) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				array.append(target + "/" + file_name)
			elif !file_name in ['.','..', null] && dir.current_is_dir():
				array += dir_contents(target + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return array

#seems not to be in use. Memory leak possible
#func evaluate(input): #used to read strings as conditions when needed
#	var script = GDScript.new()
#	script.set_source_code("func eval():\n\treturn " + input)
#	script.reload()
#	var obj = Reference.new()
#	obj.set_script(script)
#	return obj.eval()



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

#func connectitemtooltip(node, item):
#	if node.is_connected("mouse_entered",self,'showitemtooltip'):
#		node.disconnect("mouse_entered",self,'showitemtooltip')
#	node.connect("mouse_entered", self ,'showitemtooltip', [node, item])
#
#func showitemtooltip(targetnode, data):
#	var node = input_handler.get_spec_node(input_handler.NODE_ITEMTOOLTIP)#GetItemTooltip()
#	node.showup_usable(targetnode, data)

#func connectgeartooltip(node, item):
#	if node.is_connected("mouse_entered",self,'showgeartooltip'):
#		node.disconnect("mouse_entered",self,'showgeartooltip')
#	node.connect("mouse_entered", self ,'showgeartooltip', [node, item])
#
#func showgeartooltip(targetnode, data):
#	var node = input_handler.get_spec_node(input_handler.NODE_ITEMTOOLTIP)#GetItemTooltip()
#	node.showup_gear(targetnode, data)

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
	if node.is_connected("hide", self, 'hidemyskilltooltip'):
		node.disconnect("hide", self, 'hidemyskilltooltip')
	node.connect("hide", self, 'hidemyskilltooltip', [skill])

func showskilltooltip(skill, node, character_id):
	var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)
	skilltooltip.prepare(character_id, skill)
	var node_rect = node.get_global_rect()
	var tip_width = skilltooltip.rect_size.x
	var tip_height = skilltooltip.get_estimated_height()
	var pos = Vector2(node_rect.position.x + node_rect.size.x * 0.5 - tip_width * 0.5,
		node_rect.position.y - tip_height)
	skilltooltip.set_global_position(pos)
	skilltooltip.show()


func hideskilltooltip():
	var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)
	skilltooltip.hide()

func hidemyskilltooltip(skill):
	var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)
	if skilltooltip.get_skillcode() == skill:
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
	var text = '[center][color=yellow]' + tr(Items.Items[value].name) + '[/color][/center]\n' + tr(Items.Items[value].description) + '\n\n' + tr("INPOSESSION") + ': ' + str(state.materials[value])
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

#not in use
#func CharacterSelect(targetscript, type, function, requirements):
#	var node
#	if get_tree().get_root().has_node("CharacterSelect"):
#		node = get_tree().get_root().get_node("CharacterSelect")
#		get_tree().get_root().remove_child(node)
#		get_tree().get_root().add_child(node)
#	else:
#		node = load("res://WorkerSelect.tscn").instance()
#		node.name = 'CharacterSelect'
#		get_tree().get_root().add_child(node)
#		AddPanelOpenCloseAnimation(node)

#	node.show()
#	#node.set_as_toplevel(true)
#	input_handler.ClearContainer(node.get_node("ScrollContainer/VBoxContainer"))
#
#	var array = []
##	if type == 'workers':
##		array = state.workers.values()
#
#	for i in array:
#		if requirements == 'notask' && i.task != null:
#			continue
#		var newnode = input_handler.DuplicateContainerTemplate(node.get_node("ScrollContainer/VBoxContainer"))
#		newnode.get_node("Label").text = i.name
#		newnode.get_node("Icon").texture = load(i.icon)
#		newnode.get_node("Energy").text = str(i.energy) + '/' + str(i.maxenergy)
#		newnode.connect('pressed', targetscript, function, [i.id])
#		newnode.connect('pressed',self,'CloseSelection', [node])


func CloseSelection(panel):
	panel.hide()


#func closeskilltooltip():
#	#var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)
#	var skilltooltip = input_handler.get_spec_node(input_handler.NODE_SKILLTOOLTIP)#GetSkillTooltip()
#	skilltooltip.set_process(false)
#	skilltooltip.hide()


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

#seems not in use
#func QuickSave():
#	make_save_screenshot()
#	SaveGame('QuickSave')
#	free_save_screenshot()

func make_save_screenshot():
	save_screenshot = get_viewport().get_texture().get_data()

func free_save_screenshot():
	save_screenshot = null

func auto_save():
	free_save_screenshot()#or add screenshotless param to SaveGame()
	SaveGame(variables.autosave_name)

func SaveGame(file_name, save_name = ""):
#	if state.CurEvent != '':
#		state.CurrentLine = input_handler.get_spec_node(input_handler.NODE_EVENT).CurrentLine
	if file_name.empty():#new save
		var success = false
		for i in range(100000):#who needs more then 100000 save files?
			file_name = "save%d" % i
			if !file.file_exists(save_path_template % file_name):
				success = true
				break
		if !success:
			input_handler.get_spec_node(input_handler.NODE_NOTIFICATION, ["ERROR! Max file count reached. Save is impossible!"])
			return
	if save_name.empty():
		save_name = file_name
	var savedict = state.serialize();
	var file_path = save_path_template % file_name
	file.open(file_path, File.WRITE)
	file.store_line("name=" + save_name)
	file.store_line(to_json(savedict))
	file.close()
	
	if save_screenshot:
		var target_width :int = 480
		var target_height :int = 270
		if (save_screenshot.get_width() != target_width
				or save_screenshot.get_height() != target_height):
			save_screenshot.flip_y()
			var resize_height :int = (
				(float(target_width) / save_screenshot.get_width())
				* save_screenshot.get_height())
			save_screenshot.resize(target_width, resize_height)
			save_screenshot.crop(target_width, target_height)
		save_screenshot.save_png(file_path.trim_suffix(".sav") + '.png')


func LoadGame(file_name):
	if !file.file_exists(save_path_template % file_name) :
		print("no file %s" % (save_path_template % file_name))
		return

	input_handler.BlackScreenTransition(1)
	yield(get_tree().create_timer(1), 'timeout')
	input_handler.clear_closeable_windows()
	TutorialCore.clear_buttons()
	CurrentScene.queue_free()
	ChangeScene('map');
	yield(self, "scene_changed")

	file.open(save_path_template % file_name, File.READ)
	var cur_line = file.get_line()
	if cur_line.begins_with("name="):
		cur_line = file.get_line()
	file.close()
	var savedict = parse_json(cur_line)
	assert(typeof(savedict) == TYPE_DICTIONARY, "ERROR on parse_json in LoadGame() for %s" % file_name)
	state.deserialize(savedict)
	CurrentScene.buildscreen()

	#here was state.CurBuild condition to open back building's window
	#for now it all removed so as CurBuild param in saving serialization in gamestate
	if state.CurrentScreen == 'Village':
		input_handler.village_node.show()

	#opentextscene
#	if state.CurEvent != "":
#		StartEventScene(state.CurEvent, false, state.CurrentLine);


#func datetime_comp(a, b):
#	if a.year > b.year: return true
#	elif a.year < b.year: return false
#	if a.month > b.month: return true
#	elif a.month < b.month: return false
#	if a.day > b.day: return true
#	elif a.day < b.day: return false
#	if a.hour > b.hour: return true
#	elif a.hour < b.hour: return false
#	if a.minute > b.minute: return true
#	elif a.minute < b.minute: return false
#	if a.second > b.second: return true
#	return false
#	pass


func get_last_save():
	var dir = dir_contents(userfolder + 'saves')

	if dir == null: return

	var tmp = File.new()
	var max_time = 0
	var oldest_file
	for i in dir:
		if !i.ends_with('.sav'):# or i.ends_with('%s.sav' % variables.autosave_name)
			continue
		var file_time = tmp.get_modified_time(i)
		if file_time > max_time:
			max_time = file_time
			oldest_file = i
	if max_time == 0: return null
	return oldest_file

func get_hotkeys_handler() ->Object:
	return hotkeys_handler

func is_normal_type() -> bool:
	return resources.release == variables.R_NUDE

func is_boring_type() ->bool:
	return resources.release in [variables.R_BORING_DEMO, variables.R_BORING]

func is_boring_by_feature() ->bool:
	return (OS.has_feature(variables.feat_boring)
		or OS.has_feature(variables.feat_boring_demo))

func is_demo_type() ->bool:
	return resources.release in [variables.R_NUDE_DEMO, variables.R_BORING_DEMO, variables.R_CENSORED_DEMO]

func is_demo_by_feature() -> bool:
	return (OS.has_feature(variables.feat_nude_demo)
		or OS.has_feature(variables.feat_boring_demo)
		or OS.has_feature(variables.feat_cens_demo))

func is_censored_type() ->bool:
	return resources.release in [variables.R_CENSORED_DEMO, variables.R_CENSORED]

func is_censored_by_feature() ->bool:
	return (OS.has_feature(variables.feat_cens)
		or OS.has_feature(variables.feat_cens_demo))

func get_release_type():
	return resources.release

func get_game_version() ->String:
	var res = gameversion
	if is_boring_type():
		res += " Steam"
	elif is_boring_by_feature():
		#not steam_type but with feature
		res += " Patched-Steam"
	if is_censored_type():
		res += " Censored"
	elif is_censored_by_feature():
		res += " Patched-Censored"
	if is_demo_type():
		res += " Demo"
	return res

func get_sound_loud_vol():
	return globalsettings['soundvol'] + variables.SOUND_LOUD_COR
