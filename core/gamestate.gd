extends Node

var date := 1
var daytime = 0  setget time_set

var newgame = false
var difficulty = 'normal'

var votelinksseen = false

#resources
var itemidcounter := 0
var heroidcounter := 0
var money = 0
#var food = 50
var townupgrades := {
	bridge = 1,
	townhall = 1,
	market = 1,
}
var town_save
var heroes := {}
var heroes_save
var items := {}
var items_save
var materials := {}
var lognode
var unlocks := []

var combatparty := {1 : null, 2 : null, 3 : null} setget pos_set
var characters = ['arron', 'rose', 'erika', 'ember', 'iola', 'rilu']
var party_save

var CurrentTextScene
var CurrentScreen
var CurrentLine := 0

#var heroguild := {}
#var guild_save

var OldEvents := {}
var gallery_unlocks = []
var CurEvent := "" #event name
var CurBuild := ""
var keyframes := []

#Progress
var mainprogress = 0
var decisions := []
var activequests := []
var completedquests := []
var areaprogress := {}
var location_unlock = {
	dragon_mountains = false,
	castle = false,
	town = false,
	cave = true,
	forest = true,
	village = true,
	temple = false,
}
var area_save
var currentarea
var currenttutorial = 'tutorial1'
var viewed_tips := []

func time_set(value):
	#here may be placed day changing code from main screen
	#but for now i place here only new code for rising midday event
	if (daytime < variables.TimePerDay / 2) and (value >= variables.TimePerDay / 2):
		globals.check_signal('Midday')
	daytime = value

func get_difficulty():
	return difficulty #or change this to settings record if diff to be session-relatad instead of party-related
#	return globals.globalsettings.difficulty

func revert():
	date = 1
	daytime = 0
	newgame = false
	votelinksseen = false
	itemidcounter = 0
	heroidcounter = 0
	money = 0
#	food = 50
	townupgrades.clear()
	reset_heroes()
	items.clear()
	materials.clear()
	lognode = null
	unlocks.clear()
	combatparty = {1 : null, 2 : null, 3 : null}
	CurrentTextScene = null
	CurrentScreen = null
	CurrentLine = 0
	OldEvents.clear()
	CurEvent = "" #event name
	CurBuild = ""
	keyframes.clear()
	mainprogress = 0
	decisions.clear()
	activequests.clear()
	completedquests.clear()
	areaprogress.clear()
	currentarea = null
	currenttutorial = 'tutorial1'
	viewed_tips.clear()
	location_unlock = {
		dragon_mountains = false,
		castle = false,
		town = false,
		cave = false,
		forest = false,
		village = false,
		temple = false
	}
	gallery_unlocks.clear()
	for i in variables.gallery_singles_list:
		gallery_unlocks.push_back(false)


func pos_set(value):
	combatparty = value
	for p in combatparty:
		if combatparty[p] == null: continue
		heroes[combatparty[p]].position = p

func _ready():
	reset_heroes()
#	for i in Items.Materials:
#		materials[i] = 0
	for i in variables.gallery_singles_list:
		gallery_unlocks.push_back(false)



func StoreEvent(nm):
	OldEvents[nm] = date


func FinishEvent():
	if CurEvent == "" or CurEvent == null:return
	StoreEvent(CurEvent)
	if input_handler.map_node!= null: input_handler.map_node.update_map()
	CurEvent = ""
	keyframes.clear()


func store_choice(choice, option):
	if CurEvent == "" or CurEvent == null:
		print("warning - no active event")
		return
	var line = "%s_%d" % [CurEvent, choice]
	if if_has_choice(line):
		print ("warning - choice already stored")
		return
	OldEvents[line] = option
	print("choice stored - %s %d" %[line, option])


func unlock_path(path, is_abg):
	print("unlocking path %s" % path)
	for i in range(variables.gallery_singles_list.size()):
		var item = variables.gallery_singles_list[i]
		if item.path != path: continue
		if item.type == 'abg' and !is_abg: continue
		if item.type == 'bg' and is_abg: continue
		gallery_unlocks[i] = true


func get_choice(choice):
	if CurEvent == "" or CurEvent == null:
		print("warning - no active event")
		return null
	var line = "%s_%d" % [CurEvent, choice]
	if if_has_choice(line): return OldEvents[line]
	else:
		print("warning - no stored choice %s " % line)
		return null


func if_has_choice(line):
	return OldEvents.has(line)


func if_has_money(value):
	return (money >= value)

func if_has_property(prop, value):
	var tmp = get(prop)
	if tmp == null:
		print ("ERROR: NO PROPERTY IN GAMESTATE %s\n", prop)
		return false
	return (tmp >= value)

func if_has_hero(name):
	if !heroes.has(name) or !characters.has(name):
		print("warning - error in data: wrong hero name %s" % name)
		return false
	return heroes[name].unlocked

func if_has_material(mat, operant, val):
	if !materials.has(mat): return false
	return input_handler.operate(operant, materials[mat], val)

func if_has_item(name):
	for i in items.values():
		if i.name == name: return true
	return false

func checkreqs(array):
	var check = true
	for i in array:
		if valuecheck(i) == false:
			check = false
	return check

func valuecheck(dict):
	if !dict.has('type'): return true
	match dict['type']:
		"no_check":
			return true
		"has_money":
			return if_has_money(dict['value'])
		"has_property":
			return if_has_property(dict['prop'], dict['value'])
		"has_hero":
			return if_has_hero(dict['name'])
		"event_finished":
			var tmp = OldEvents.has(dict['name'])
			if tmp and dict.has('delay'):
				tmp = OldEvents[dict['name']] + dict['delay'] <= date
			return tmp
		"has_material":
			return if_has_material(dict['material'], dict.operant, dict['value'])
		"date":
			return date >= dict['date']
		"item":
			return if_has_item(dict['name'])
		"building":
			return CurBuild == dict['value']
		"gamestart":
			return newgame
		"has_upgrade":
			return if_has_upgrade(dict.name, dict.value)
		"main_progress":
			return if_has_progress(dict.value, dict.operant)
		"area_progress":
			return if_has_area_progress(dict.value, dict.operant, dict.area)
		"decision":
			return decisions.has(dict.name)
		"quest_stage":
			return if_quest_stage(dict.name, dict.value, dict.operant)
		"quest_completed":
			return completedquests.has(dict.name)
		"party_level":
			return if_party_level(dict.operant, dict.value)
		"hero_level":
			if if_has_hero(dict.name) == false:
				return false
			else:
				return if_hero_level(dict.name, dict.operant, dict.value)

func if_quest_stage(name, value, operant):
	var questprogress
	questprogress = GetQuest(name)
	if questprogress == null:
		questprogress = 0

	return input_handler.operate(operant, questprogress, value)

func if_has_area_progress(value, operant, area):
	if !areaprogress.has(area):return false
	return input_handler.operate(operant, areaprogress[area], value)

func if_has_progress(value, operant):
	return input_handler.operate(operant, mainprogress, value)

func if_has_upgrade(upgrade, level):
	if !townupgrades.has(upgrade): return false
	else: return townupgrades[upgrade] >= level

func get_upgrade_level(upgrade):
	if !townupgrades.has(upgrade): return 0
	return townupgrades[upgrade]

func get_character_by_pos(pos):
	if combatparty[pos] == null: return null
	return heroes[combatparty[pos]]

func if_party_level(operant,value):
	var counter = 0
	for i in combatparty.values():
		if i != null:
			counter += heroes[i].level
	return input_handler.operate(operant, counter, value)

func if_hero_level(name, operant, value):
	var hero
	for h in heroes.values():
		if h.name == name: hero = h
	return input_handler.operate(operant, hero.level, value)


func serialize():
	var tmp = {}
	area_save = areaprogress
	town_save = townupgrades
	party_save = combatparty
	tmp['items_save'] = {}
	for i in items.keys():
		tmp['items_save'][i] = inst2dict(items[i])
	tmp['heroes_save'] = {}
	for i in characters:
		tmp['heroes_save'][i] = heroes[i].serialize()

	var arr = ['date', 'daytime', 'newgame', 'itemidcounter', 'heroidcounter', 'money', 'food', 'CurBuild', 'mainprogress', 'CurEvent', 'CurrentLine','currentutorial', 'newgame', 'votelinksseen']
	var arr2 = ['town_save', 'materials', 'unlocks', 'party_save', 'OldEvents', 'keyframes', 'decisions', 'activequests', 'completedquests', 'area_save', 'location_unlock', 'gallery_unlocks']
	for prop in arr:
		tmp[prop] = get(prop)
	for prop in arr2:
		tmp[prop] = get(prop).duplicate()
	tmp['effects'] = effects_pool.serialize()
	return tmp

func deserialize(tmp:Dictionary):
	effects_pool.deserialize(tmp['effects'])
	tmp.erase('effects')
	for prop in tmp.keys():
		set(prop, tmp[prop])
	cleanup()
	for key in heroes_save.keys():
		heroes[key].deserialize(heroes_save[key])
	items.clear()
	for key in items_save.keys():
		var key1 = key
		if (typeof(key1) != TYPE_STRING) or (key1[0] != 'i'):
			key1 = 'i' + str(key1)
		var t := dict2inst(items_save[key])
		t.id = key1
		items[key1] = t
	combatparty.clear()
	for k in party_save.keys() :
		combatparty[int(k)] = party_save[k]
	areaprogress.clear()
	for k in area_save.keys() :
		areaprogress[k] = int(area_save[k])
	townupgrades.clear()
	for k in town_save.keys() :
		townupgrades[k] = int(town_save[k])

func cleanup():
	for ch in heroes.keys().duplicate():
		if !(ch in characters): heroes.erase(ch)

func reset_heroes():
	cleanup()
	var tmp
	h_arron.new()
	h_ember.new()
	h_erika.new()
	h_iola.new()
	h_rilu.new()
	h_rose.new()


#simple action wrappers
func unlock_char(code, value = true):
	heroes[code].unlocked = value


func unlock_loc(loc_id, value = true):
	location_unlock[loc_id] = value


func make_upgrade(id, lvl):
	#stub
	#add checks, logging and signals
	townupgrades[id] = lvl

func logupdate(text):
	if globals.get_tree().get_root().has_node("LogPanel/RichTextLabel") == false:
		return
	lognode = globals.get_tree().get_root().get_node("LogPanel/RichTextLabel")
	text = lognode.bbcode_text + '\n' + text

	#lognode.bbcode_text += '\n' +
	lognode.bbcode_text = globals.TextEncoder(text)


func ProgressMainStage(stage = null):
	if stage == null:
		mainprogress += 1
	else:
		mainprogress = stage


func MakeQuest(code):
	activequests.append({code = code, stage = 1})
	globals.check_signal("QuestStarted", code)


func GetQuest(code):
	for i in activequests:
		if i.code == code:
			return i.stage
	return null


func AdvanceQuest(code):
	for i in activequests:
		if i.code == code:
			i.stage += 1


func FinishQuest(code):
	var tempquest
	for i in activequests:
		if i.code == code:
			tempquest = i
	activequests.erase(tempquest)
	completedquests.append(tempquest.code)
	globals.check_signal("QuestCompleted", code)


func add_materials(res, value):
	if !materials.has(res):
		materials[res] = 0
	var tmp = materials[res]
	materials[res] += value
	if materials[res] < 0: materials[res] = 0
	tmp = materials[res] - tmp
	if tmp > 0:
		var text = "Gained "
		text += str(tmp) + ' {color=yellow|' + Items.Materials[res].name + '}'
		logupdate(text)
	elif tmp < 0:
		var text = "Lost "
		text += str(-tmp) + ' {color=yellow|' + Items.Materials[res].name + '}'
		logupdate(text)


func add_money(value):
	var tmp = money
	money += value
	if money < 0: money = 0
	tmp = money - tmp
	if tmp > 0:
		var text = "Gained "
		text += str(tmp) + ' {color=yellow|' + 'Gold' + '}'
		logupdate(text)
	elif tmp < 0:
		var text = "Lost "
		text += str(-tmp) + ' {color=yellow|' + 'Gold' + '}'
		logupdate(text)


#obsolete setter
#func materials_set(value):
#	var text = ''
#	for i in value:
#		if oldmaterials.has(i) == false || oldmaterials[i] != value[i]:
#			if oldmaterials.has(i) == false:
#				oldmaterials[i] = 0
#			else:
#				if oldmaterials[i] - value[i] < 0:
#					text += 'Gained '
#					globals.check_signal("MaterialObtained", i)
#				else:
#					text += "Lost "
#				text += str(value[i] - oldmaterials[i]) + ' {color=yellow|' + Items.Materials[i].name + '}'
#				logupdate(text)
#	materials = value
#	oldmaterials = materials.duplicate()
