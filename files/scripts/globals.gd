extends Node

const worker = preload("res://files/scripts/worker.gd");
const Item = preload("res://src/ItemClass.gd")

var SpriteDict = {}
var TranslationData = {}
var CurrentScene #holds reference to instanced scene

var EventList = events.checks;

var scenedict = {
	menu = "res://files/Menu.tscn",
	town = "res://files/MainScreen.tscn"
	
}

#var items
#var TownData
var workersdict
#var enemydata
var randomgroups

#var enemylist
var upgradelist

#var skillsdata
#var effectdata

#var combatantdata = load("res://files/CombatantClass.gd").new()

var classes = combatantdata.classlist
var characters = combatantdata.charlist
var skills
var traits = combatantdata.traitlist
var effects
var combateffects


var gearlist = ['helm', 'chest', 'gloves', 'boots', 'rhand', 'lhand', 'neck', 'ring1', 'ring2']

var file = File.new()
var dir = Directory.new()

var LocalizationFolder = "res://localization/"
#var state

var userfolder = 'user://'

#var images = load("res://files/scripts/ResourceImages.gd").new()
#var audio = load("res://files/scripts/ResourceAudio.gd").new()
var scenes = {}

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
	musicvol = -15,
	musicmute = false,
	soundvol = -15,
	soundmute = false,
	fullscreen = false,
	textspeed = 60,
	skipread = false,
} setget settings_save

func settings_load():
	var config = ConfigFile.new()
	if file.file_exists(userfolder + "Settings.ini") == false:
		settings_save(globalsettings)
	config.load(userfolder + "Settings.ini")
	var settings = config.get_section_keys("settings") 
	for i in settings:
		globalsettings[i] = config.get_value("settings", i, null)
	
	#updatevolume
	var counter = 0
	for i in ['master','music','sound']:
		AudioServer.set_bus_mute(counter, globals.globalsettings[i+'mute'])
		AudioServer.set_bus_volume_db(counter, globals.globalsettings[i+'vol'])
		counter += 1
	

func settings_save(value):
	globalsettings = value
	var config = ConfigFile.new()
	config.load(userfolder + "Settings.ini")
	for i in globalsettings:
		config.set_value('settings', i, globalsettings[i])
	config.save(userfolder + "Settings.ini")


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

func _ready():
	OS.window_size = Vector2(1280,720)
	OS.window_position = Vector2(300,0)
	randomize()
	#Settings and folders
	settings_load()
	#LoadEventData()
	
	#===Necessary to apply translation===

	Items = load("res://files/Items.gd").new()
	Enemydata = load("res://assets/data/enemydata.gd").new()
	Skillsdata = load("res://assets/data/Skills.gd").new()
	Effectdata = load("res://assets/data/Effects.gd").new()
	TownData = load("res://files/TownData.gd").new()

	upgradelist = load("res://assets/data/upgradedata.gd").new().upgradelist

	#====================================
	
	
	#randomgroups = Enemydata.randomgroups
	#enemylist = Enemydata.enemylist
	effects = Effectdata.effects
	#combateffects = Effectdata.combateffects
	#skills = Skillsdata.skilllist
	
	#workersdict = TownData.workersdict
	
	for i in Items.Materials:
		state.materials[i] = 0
	state.materials.wood = 10
	state.materials.elvenwood = 10
	state.materials.elvenmetal = 10
	#state.materials.stone = 5
	state.money = 200
	

func logupdate(text):
	state.logupdate(text)




signal scene_changed

func ChangeScene(name):
	input_handler.CloseableWindowsArray.clear()
	var loadscreen = load("res://files/LoadScreen.tscn").instance()
	get_tree().get_root().add_child(loadscreen)
	loadscreen.goto_scene(scenedict[name])

func StartCombat(enemygroup):
	pass

#func LoadEventData():
#	if file.file_exists("res://assets/data/eventdata.json"):
#		file.open("res://assets/data/eventdata.json", File.READ);
#		EventList = parse_json(file.get_as_text());
#		file.close();
#	else:
#		print('Event not found: ' + name)
#	pass

func EventCheck():
	if state.CurEvent != "": return;
	for s in get_tree().get_nodes_in_group('char_sprite'):
		s.set_active_val();
		pass
	for event in EventList.keys():
		if SimpleEventCheck(event, false):
			StartEventScene(event);
			break;
	pass

func SimpleEventCheck(event, skip = true):
	var tmp_d = {global = 'skip'};
	if state.OldEvents.has(event): return false;
	for check in EventList[event]:
		if check.size() == 0:
			if skip: continue;
			else: return false;
		if !state.valuecheck(check): 
			return false;
		pass
	return true;
	pass

func LoadEvent(name):
	var dict
	
	if file.file_exists("res://assets/data/events/"+ name + '.json'):
		file.open("res://assets/data/events/"+ name + '.json', File.READ)
		dict = parse_json(file.get_as_text())
		file.close()
	else:
		print('Event not found: ' + name)
	return dict

func StartEventScene(name, debug = false):
	state.CurEvent = name;
	scenes[name] = LoadEvent(name)
	var scene = input_handler.GetEventNode()
	scene.visible = true
	scene.Start(scenes[name], debug)

func CreateGearItem(item, parts, newname = null):
	var newitem = Item.new()
	newitem.CreateGear(item, parts)
	if newname != null:
		newitem.name = newname
	
	return newitem

func CreateUsableItem(item, amount = 1):
	var newitem = Item.new()
	newitem.CreateUsable(item, amount)
	return newitem

func AddItemToInventory(item):
	item.inventory = state.items
	if item.stackable == false:
		item.id = state.itemidcounter
		state.items[item.id] = item
		state.itemidcounter += 1
	else:
		var id = get_item_id_by_code(item.itembase)
		if id != null:
			state.items[id].amount += item.amount
		else:
			item.id = state.itemidcounter
			state.items[item.id] = item
			state.itemidcounter += 1
		

func get_item_id_by_code(itembase):
	for item in state.items.values():
		if item.itembase == itembase:
			return item.id
	
	return null

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



func ClearContainer(container):
	for i in container.get_children():
		if i.name != 'Button':
			i.hide()
			i.queue_free()

func DuplicateContainerTemplate(container):
	var newbutton = container.get_node('Button').duplicate()
	newbutton.show()
	container.add_child(newbutton)
	container.move_child(container.get_node('Button'), newbutton.get_position_in_parent())
	return newbutton

func connecttooltip(node, text):
	if node.is_connected("mouse_entered",self,'showtooltip'):
		node.disconnect("mouse_entered",self,'showtooltip')
	node.connect("mouse_entered",self,'showtooltip', [text,node])

func disconnecttooltip(node):
	if node.is_connected("mouse_entered",self,'showtooltip'):
		node.disconnect("mouse_entered",self,'showtooltip')

func connectitemtooltip(node, item):
	if node.is_connected("mouse_entered",item,'tooltip'):
		node.disconnect("mouse_entered",item,'tooltip')
	node.connect("mouse_entered",item,'tooltip', [node])

func connectmaterialtooltip(node, material):
	if node.is_connected("mouse_entered",self,'mattooltip'):
		node.disconnect("mouse_entered",self,'mattooltip')
	node.connect("mouse_entered",self,'mattooltip', [node, material])

func mattooltip(targetnode, material):
	var image
	var node = input_handler.GetItemTooltip()
	node.showup(targetnode, material)


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
	var text = '[center][color=yellow]' + Items.Materials[value].name + '[/color][/center]\n' + Items.Materials[value].description + '\n\n' + tr("INPOSESSION") + ': ' + str(state.materials[value])
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
	else:
		node = load("res://WorkerSelect.tscn").instance()
		get_tree().get_root().add_child(node)
		node.name = 'CharacterSelect'
		AddPanelOpenCloseAnimation(node)
	
	node.show()
	node.set_as_toplevel(true)
	ClearContainer(node.get_node("ScrollContainer/VBoxContainer"))
	
	var array = []
	if type == 'workers':
		array = state.workers.values()
	
	for i in array:
		if requirements == 'notask' && i.task != null:
			continue
		var newnode = globals.DuplicateContainerTemplate(node.get_node("ScrollContainer/VBoxContainer"))
		newnode.get_node("Label").text = i.name
		newnode.get_node("Icon").texture = i.icon
		newnode.get_node("Energy").text = str(i.energy) + '/' + str(i.maxenergy)
		newnode.connect('pressed', targetscript, function, [i])
		newnode.connect('pressed',self,'CloseSelection', [node])

func HeroSelect(targetscript, type, function, requirements):
	var node 
	if get_tree().get_root().has_node("HeroSelect"):
		node = get_tree().get_root().get_node("HeroSelect")
	else:
		node = load("res://HeroSelect.tscn").instance()
		get_tree().get_root().add_child(node)
		node.name = 'HeroSelect'
		AddPanelOpenCloseAnimation(node)
	
	node.show()
	node.set_as_toplevel(true)
	ClearContainer(node.get_node("ScrollContainer/VBoxContainer"))
	
	var array = []
	var newnode
	if type == 'heroposition':
		array = state.heroes.values()
		newnode = globals.DuplicateContainerTemplate(node.get_node("ScrollContainer/VBoxContainer"))
		newnode.get_node("Label").text = tr("REMOVE")
		newnode.connect('pressed', targetscript, function, [null])
		newnode.connect('pressed',self,'CloseSelection', [node])
	
	for i in array:
		newnode = globals.DuplicateContainerTemplate(node.get_node("ScrollContainer/VBoxContainer"))
		newnode.get_node("Label").text = i.name

		newnode.get_node("Icon").texture = images.portraits[i.icon]

		newnode.connect('pressed', targetscript, function, [i])
		newnode.connect('pressed',self,'CloseSelection', [node])


func ItemSelect(targetscript, type, function, requirements = true):
	var node 
	if get_tree().get_root().has_node("ItemSelect"):
		node = get_tree().get_root().get_node("ItemSelect")
	else:
		node = load("res://ItemSelect.tscn").instance()
		get_tree().get_root().add_child(node)
		AddPanelOpenCloseAnimation(node)
		node.name = 'ItemSelect'
	node.show()
	node.set_as_toplevel(true)
	
	ClearContainer(node.get_node("ScrollContainer/GridContainer"))
	
	var array = []
	if type == 'gear':
		for i in state.items.values():
			if i.geartype == requirements && i.task == null && i.owner == null && i.durability > 0:
				array.append(i)
	elif type == 'repairable':
		for i in state.items:
			if i.durability < i.maxdurability:
				array.append(i)
	
	for i in array:
		var newnode = globals.DuplicateContainerTemplate(node.get_node("ScrollContainer/GridContainer"))
		if type == 'gear':
			input_handler.itemshadeimage(newnode, i)
			newnode.get_node("Percent").show()
			newnode.get_node("Percent").text = str(calculatepercent(i.durability, i.maxdurability)) + '%'
			connectitemtooltip(newnode, i)
		newnode.connect('pressed', targetscript, function, [i])
		newnode.connect('pressed',self,'CloseSelection', [node])

func CloseSelection(panel):
	panel.hide()



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
	pass

func EndGame(result):
	pass

func SaveGame(name):
	var savedict = {}
	savedict.gameprogress = inst2dict(state)
	file.open(userfolder + 'saves/' + name + '.sav', File.WRITE)
	file.store_line(to_json(savedict))
	file.close()

func LoadGame(name):
	var gamefile = file.open(userfolder+'saves/'+name + '.sav', File.READ)
	
	ChangeScene("MainMenu")
