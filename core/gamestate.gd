extends Node


signal pending_scenes_updated
signal old_seqs_updated
signal old_events_updated#mind that choice is also stored in OldEvents, but not signaled by this
#doesn't work for now
#var date := 1
var daytime = 0.0
#var newgame = false
#var itemidcounter := 0
#var mainprogress = 0
#var activequests := []
#var completedquests := []

var difficulty = 'normal'

var votelinksseen = false

#resources
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
#var items := {}
#var items_save
var materials := {}
var materials_unlocks := {}
var lognode
var resist_unlocks := {}

#var combatparty := {1 : null, 2 : null, 3 : null} setget pos_set
var characters = ['arron', 'rose', 'erika', 'ember', 'iola', 'rilu']
#var party_save

var scene_restore_data = {}
var CurrentScreen

#var heroguild := {}
#var guild_save

var OldSeqs = []
var OldEvents := {}
#var gallery_unlocks = []
#var gallery_event_unlocks = []
var CurEvent := "" #event name
var CurBuild := ""

var pending_scenes = []
var discovered_pending_scenes = []
#Progress
var decisions := []
var areaprogress := {} #{level, stage, completed}
var activearea = null
var location_unlock = {
	dragon_mountains = false,
	castle = false,
	town = false,
	cave = true,
	forest = true,
	village = true,
	cult = false,
	modern_city = false
}
var area_save
#var stashedarea#in fact it works, but with new mission's 'stop' mechanic not really necessary
var viewed_tips := []

signal party_changed
signal money_changed
signal daytime_dawn
signal daytime_sunset
signal daytime_forced

func set_daytime(value):
	daytime = value
	emit_signal("daytime_forced")

func add_daytime(value):
	var old_daytime = daytime
	daytime += value
	if old_daytime < variables.TimeDawn and daytime >= variables.TimeDawn:
		emit_signal("daytime_dawn")
	if daytime > variables.TimePerDay:
		daytime -= variables.TimePerDay
		emit_signal("daytime_sunset")

func is_daytime_day() ->bool:
	return daytime >= variables.TimeDawn

func update_pending_scenes(scenes: Array):
	pending_scenes = scenes
	emit_signal("pending_scenes_updated")

func clear_pending_scenes():
	pending_scenes.clear()
	emit_signal("pending_scenes_updated")

func get_difficulty():
	return difficulty #or change this to settings record if diff to be session-relatad instead of party-related
#	return globals.globalsettings.difficulty

func revert():
#	date = 1
	set_daytime(0.0)
#	newgame = false
	votelinksseen = false
#	itemidcounter = 0
	heroidcounter = 0
	money = 0
#	food = 50
	townupgrades = {
		bridge = 1,
		townhall = 1,
		market = 1,
	}
	reset_heroes()
	reset_inventory()
#	items.clear()
#	materials.clear()#reset_inventory() made this
	lognode = null
#	combatparty = {1 : null, 2 : null, 3 : null}
	scene_restore_data = {}
	CurrentScreen = null
	OldSeqs.clear()
	OldEvents.clear()
	CurEvent = "" #event name
	CurBuild = ""
#	mainprogress = 0
	decisions.clear()
#	activequests.clear()
#	completedquests.clear()
#	areaprogress.clear()
	reset_areaprogress()
	activearea = null
#	stashedarea = null
	viewed_tips.clear()
	location_unlock = {
		dragon_mountains = false,
		castle = false,
		town = false,
		cave = false,
		forest = false,
		village = false,
		cult = false,
		modern_city = false
	}
#	gallery_unlocks.clear()
#	for i in variables.gallery_singles_list:
#		gallery_unlocks.push_back(false)
#	gallery_event_unlocks.clear()


func reset_areaprogress():
	areaprogress.clear()
	var tmp = {
		unlocked = false,
		level = 0,
		stage = 1,
		completed = false
	}
	for area in Explorationdata.areas:
		areaprogress[area] = tmp.duplicate()


func unlock_area(area_code):
	areaprogress[area_code].unlocked = true
#	input_handler.map_node.unlock_area(area_code)

func start_area(area_code, autolevel = false):
	activearea = area_code
#	if !areaprogress[area_code].unlocked:
#		print("force start locked mission %s" % area_code)
	areaprogress[area_code].unlocked = true
#	areaprogress[area_code].stage = 1
	if autolevel:
		areaprogress[area_code].level = heroes['arron'].level
	else:
		areaprogress[area_code].level = Explorationdata.areas[area_code].level


func abandon_area(area_code = activearea):
	areaprogress[area_code].stage = 1
	stop_area(area_code)

func stop_area(area_code = activearea):
	if area_code == activearea:
		activearea = null


func complete_area(area_code = activearea):
	areaprogress[area_code].completed = true
	areaprogress[area_code].stage = 1
	if area_code == activearea:
		activearea = null #stashedarea
#		if stashedarea != null:
#			stashedarea = null
	input_handler.map_node.update_map()


#func pos_set(value):
#	combatparty = value
#	for p in combatparty:
#		if combatparty[p] == null: continue
#		heroes[combatparty[p]].position = p

func _ready():
	reset_heroes()
	reset_inventory()
	reset_areaprogress()
#	for i in variables.gallery_singles_list:
#		gallery_unlocks.push_back(false)


#this func checks relevancy, so already seen sequence is irrelevant
func check_sequence(id):
	if OldSeqs.has(id):
		return false
	if !Explorationdata.scene_sequences.has(id):
		print("event seq %s not found" % id)
		return false
	var seqdata = Explorationdata.scene_sequences[id]
	return checkreqs(seqdata.initiate_reqs)


func store_sequence(id):
	if OldSeqs.has(id): return
	OldSeqs.push_back(id)
	emit_signal("old_seqs_updated")


func StoreEvent(nm):
	if OldEvents.has(nm): return
	OldEvents[nm] = 1#date#for now (2.03.24) "date" mechanics does not work, so it's bool in practice
	emit_signal("old_events_updated")


func ClearEvent():
	scene_restore_data.clear()
	CurEvent = ""

func FinishEvent(replay = false):
	if CurEvent == "" or CurEvent == null:return
	StoreEvent(CurEvent)
	var finished_event = CurEvent
	ClearEvent()
#	if input_handler.map_node!= null: input_handler.map_node.update_map()
#	input_handler.emit_signal("EventFinished")
	var next_is_scene = false
	if Explorationdata.event_triggers.has(finished_event):
		var nseqdata = Explorationdata.event_triggers[finished_event]
		var output = globals.run_actions_list(nseqdata, replay)
		next_is_scene = (output == variables.SEQ_SCENE_STARTED)

	if !next_is_scene:
		input_handler.curtains.hide_anim(variables.CURTAIN_SCENE)
		input_handler.scene_node.emit_signal("AllEventsFinished")


func store_choice(choice, option):
	if CurEvent == "" or CurEvent == null:
		print("warning - no active event")
		return
	var line = "%s_ch%d" % [CurEvent, choice]
	if if_has_choice(line):
		print ("warning - choice already stored")
		return
	OldEvents[line] = option
#	print("choice stored - %s %d" %[line, option])


func unlock_path(path, is_abg):
	#this is usless for now
	pass
#	print("unlocking path %s" % path)
#	for i in range(variables.gallery_singles_list.size()):
#		var item = variables.gallery_singles_list[i]
#		if item.path != path: continue
#		if item.type == 'abg' and !is_abg: continue
#		if item.type == 'bg' and is_abg: continue
#		gallery_unlocks[i] = true


func get_choice(choice):
	if CurEvent == "" or CurEvent == null:
		print("warning - no active event")
		return null
	var line = "%s_ch%d" % [CurEvent, choice]
	if if_has_choice(line): return OldEvents[line]
	else:
		print("warning - no stored choice %s " % line)
		return null


func checkreqs(array):
	for i in array:
		if !valuecheck(i):
			return false
	return true


func valuecheck(dict):
	if !dict.has('type'):
		 return true
	match dict['type']:
		"no_check":
			return true
		#new ones
		"mission_complete":
			return areaprogress[dict.value].completed
		"seq_seen":
			return OldSeqs.has(dict.value)
		"scene_seen":
			return OldEvents.has(dict.value)
		"forced_content":
			if dict.has("value"):
				return globals.globalsettings.forced_content == dict.value
			return globals.globalsettings.forced_content
		#old ones, possibly obsolete
		"has_money":
			return if_has_money(dict['value'])
		"has_property":
			return if_has_property(dict['prop'], dict['value'])
		"has_hero":
			return if_has_hero(dict['name'])
#		"event_finished":
#			var tmp = OldEvents.has(dict['name'])
#			if tmp and dict.has('delay'):
#				tmp = OldEvents[dict['name']] + dict['delay'] <= date
#			return tmp
		"has_material":
			return if_has_material(dict['material'], dict.operant, dict['value'])
#		"date":
#			return date >= dict['date']
#		"item":
#			return if_has_item(dict['name'])
		"building":
			return CurBuild == dict['value']
#		"gamestart":
#			return newgame
		"has_upgrade":
			return if_has_upgrade(dict.name, dict.value)
#		"main_progress":
#			return if_has_progress(dict.value, dict.operant)
#		"area_progress":
#			return if_has_area_progress(dict.value, dict.operant, dict.area)
		"decision":
			return decisions.has(dict.name)
#		"quest_stage":
#			return if_quest_stage(dict.name, dict.value, dict.operant)
#		"quest_completed":
#			return completedquests.has(dict.name)
		"party_level":
			return if_party_level(dict.operant, dict.value)
		"hero_level":
			if if_has_hero(dict.name) == false:
				return false
			else:
				return if_hero_level(dict.name, dict.operant, dict.value)

#func if_quest_stage(name, value, operant):
#	var questprogress
#	questprogress = GetQuest(name)
#	if questprogress == null:
#		questprogress = 0
#
#	return input_handler.operate(operant, questprogress, value)

#not in use
#func if_has_area_progress(value, operant, area):
#	if !areaprogress.has(area):return false
#	return input_handler.operate(operant, areaprogress[area].stage, value)

#func if_has_progress(value, operant):
#	return input_handler.operate(operant, mainprogress, value)

func if_has_upgrade(upgrade, level):
	if !townupgrades.has(upgrade): return false
	else: return townupgrades[upgrade] >= level

func get_upgrade_level(upgrade):
	if !townupgrades.has(upgrade): return 0
	return townupgrades[upgrade]

func get_character_by_pos(pos):
#	if combatparty[pos] == null: return null
#	return heroes[combatparty[pos]]
	for ch in characters:
		if heroes[ch].position == pos:
			return heroes[ch]
	return null

#in fact this func is not relevant, but it used only in randomgroups, which is not strictly in use
func if_party_level(operant,value):
	var counter = 0
#	for i in combatparty.values():
#		if i != null:
#			counter += heroes[i].level
	for ch in characters:
		if heroes[ch].position != null:
			counter += heroes[ch].level
	return input_handler.operate(operant, counter, value)

func if_hero_level(name, operant, value):
	var hero
	for h in heroes.values():
		if h.name == name: hero = h
	return input_handler.operate(operant, hero.level, value)

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

#func if_has_item(name):
#	for i in items.values():
#		if i.name == name: return true
#	return false


func serialize():
	var tmp = {}
	area_save = areaprogress
	town_save = townupgrades
#	party_save = combatparty
#	tmp['items_save'] = {}
#	for i in items.keys():
#		tmp['items_save'][i] = inst2dict(items[i])
	tmp['heroes_save'] = {}
	for i in characters:
		tmp['heroes_save'][i] = heroes[i].serialize()

	var arr = ['heroidcounter', 'money', 'CurEvent', 'votelinksseen', 'activearea', 'CurrentScreen', 'daytime']#'date', 'newgame', 'itemidcounter', 'mainprogress', 'stashedarea', 'currentutorial', 'screen'
	var arr2 = ['town_save', 'materials', 'materials_unlocks', 'resist_unlocks', 'OldSeqs', 'OldEvents', 'decisions', 'area_save', 'location_unlock', 'scene_restore_data', 'pending_scenes', 'discovered_pending_scenes']#'gallery_unlocks', 'party_save', 'activequests', 'completedquests'
	for prop in arr:
		tmp[prop] = get(prop)
	for prop in arr2:
		tmp[prop] = get(prop).duplicate()
#	tmp['effects'] = effects_pool.serialize()
	if !effects_pool.serialize().empty():
		print("!!!!!ALERT!!!!! There are effects for save!")
	return tmp

func deserialize(tmp:Dictionary):
#	effects_pool.deserialize(tmp['effects'])
	tmp.erase('effects')
	for prop in tmp.keys():
		set(prop, tmp[prop])
	set_daytime(daytime)
	emit_signal("money_changed")
	for id in materials:
		materials[id] = int(materials[id])
	refill_materials()
	if !tmp.has('materials_unlocks'):#only for old savegame compatibility
		print("old save! reset_materials_unlocks!")
		reset_materials_unlocks()
	if !tmp.has("pending_scenes"):#only for old savegame compatibility
		pending_scenes.clear()
	if !tmp.has("discovered_pending_scenes"):#only for old savegame compatibility
		discovered_pending_scenes.clear()
	cleanup()
#	combatparty.clear()
	for key in heroes_save.keys():
		if !heroes_save[key].has("ultimeter"):#only for old savegame compatibility
			heroes_save[key].ultimeter = 0
			if key == characters[0]: print("old save! ultimeter reset!")
		heroes[key].deserialize(heroes_save[key])
	if !tmp.has('resist_unlocks'):#only for old savegame compatibility
		print("old save! reset_resist_unlocks!")
		reset_resist_unlocks()
	effects_pool.cleanup()
#	items.clear()
#	for key in items_save.keys():
#		var key1 = key
#		if (typeof(key1) != TYPE_STRING) or (key1[0] != 'i'):
#			key1 = 'i' + str(key1)
#		var t := dict2inst(items_save[key])
#		t.id = key1
#		items[key1] = t
	
#	for k in party_save.keys() :
#		combatparty[int(k)] = party_save[k]
	reset_areaprogress()
	for k in area_save.keys() :
		if !areaprogress.has(k): continue
#		areaprogress[k] = area_save[k].duplicate()
		areaprogress[k].unlocked = area_save[k].unlocked
		areaprogress[k].level = int(area_save[k].level)
		areaprogress[k].stage = int(area_save[k].stage)
		if areaprogress[k].stage == 0:
			areaprogress[k].stage = 1
#		areaprogress[k].active = area_save[k].active
		areaprogress[k].completed = area_save[k].completed
	townupgrades = {
		bridge = 1,
		townhall = 1,
		market = 1,
	}
	for k in town_save.keys() :
		townupgrades[k] = int(town_save[k])
	for k in scene_restore_data:
		if k in ['show_sprite', 'show_bs']: continue
		scene_restore_data[k] = int(scene_restore_data[k])
	if CurEvent != null and CurEvent != "":
		globals.play_scene(CurEvent, true)
		input_handler.curtains.show_inst(variables.CURTAIN_SCENE)
	else:
		input_handler.curtains.hide_anim(variables.CURTAIN_SCENE)
#	input_handler.map_node.update_map()

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
	reset_resist_unlocks()


func reset_inventory():
	#temporal version
	materials.clear()
	refill_materials()
	materials_unlocks.clear()

func refill_materials():
	for id in Items.Items:
		if !materials.has(id): materials[id] = 0

func reset_materials_unlocks():
	materials_unlocks.clear()
	for id in materials:
		if materials[id] > 0:
			try_unlock_material(id)

func is_material_unlocked(id :String) ->bool:
	if materials_unlocks.has(id):
		return materials_unlocks[id]
	return false

func try_unlock_material(id :String) ->bool:#true if success
	assert(Items.Items.has(id), "try_unlock_material trying to unlock unexistant material!")
	if is_material_unlocked(id):
		return false
	materials_unlocks[id] = true
	return true

func reset_resist_unlocks():
	resist_unlocks.clear()
	try_unlock_resist('damage')
	for character in heroes.values():
		if character.unlocked:
			character.unlock_resists()
#	print("reset_resist_unlocks!!!!")
#	print(resist_unlocks)

func is_resist_unlocked(id :String) ->bool:
	if resist_unlocks.has(id):
		return resist_unlocks[id]
	return false

func try_unlock_resist(id :String) ->bool:#true if success
	assert(variables.resistlist.has(id) or variables.status_list.has(id),
			"try_unlock_resist trying to unlock unexistant resist!")
	if is_resist_unlocked(id):
		return false
	resist_unlocks[id] = true
	return true

func system_action(action):
	match action.value:
		'unlock_area':
			unlock_loc(action.arg)
		'unlock_mission':
			unlock_area(action.arg)
		'enable_character':
			var notify = true
			if action.arg.size() >= 3:
				notify = action.arg[2]
			unlock_char(action.arg[0], action.arg[1], notify)
#		'unlock_character':
#			unlock_char(action.arg)
#		'game_stage':
#			ProgressMainStage(action.arg)
		#not in use now
#		'unlock_building':
#			make_upgrade(action.arg, 1)
		'show_screen':
			pass
		'add_to_party':
			add_char_to_party(action.arg[0], action.arg[1])
		'credits':
			input_handler.get_spec_node(input_handler.NODE_CREDITS).show_end_credits()

#simple action wrappers
func unlock_char(code, value = true, notify = true):
	heroes[code].unlocked = value
	if !value:
		heroes[code].position = null
	if notify:
		input_handler.get_spec_node(input_handler.NODE_UNLOCKCHAR, [code, value])
	emit_signal("party_changed")


func unlock_loc(loc_id, value = true):
	location_unlock[loc_id] = value
	input_handler.map_node.update_map()


func add_char_to_party(id, pos):
	if !heroes[id].unlocked:
		return
	for i in heroes:
		if heroes[i].position == pos:
			heroes[i].position = null
	heroes[id].position = pos

#not realy in use, but could still be called by old code, consider refactor
func make_upgrade(id, lvl):
	#stub
	#add checks, logging and signals
	townupgrades[id] = lvl
	input_handler.emit_signal("UpgradeUnlocked")

func logupdate(text):
	if globals.get_tree().get_root().has_node("LogPanel/RichTextLabel") == false:
		return
	lognode = globals.get_tree().get_root().get_node("LogPanel/RichTextLabel")
	text = lognode.bbcode_text + '\n' + text

	#lognode.bbcode_text += '\n' +
	lognode.bbcode_text = globals.TextEncoder(text)


#func ProgressMainStage(stage = null):#2remake
#	if stage == null:
#		mainprogress += 1
#	else:
#		mainprogress = stage


#func MakeQuest(code):
#	activequests.append({code = code, stage = 1})
##	globals.check_signal("QuestStarted", code)


#func GetQuest(code):
#	for i in activequests:
#		if i.code == code:
#			return i.stage
#	return null


#func AdvanceQuest(code):
#	for i in activequests:
#		if i.code == code:
#			i.stage += 1


#func FinishQuest(code):
#	var tempquest
#	for i in activequests:
#		if i.code == code:
#			tempquest = i
#	activequests.erase(tempquest)
#	completedquests.append(tempquest.code)
##	globals.check_signal("QuestCompleted", code)


func add_test_resources():
	for i in materials:
		materials[i] = 100


func add_materials(res, value, log_f = true):
	if !materials.has(res):
		materials[res] = 0
	var tmp = materials[res]
	materials[res] += value
	if materials[res] < 0: materials[res] = 0
	#this probably should be done by hand somewhere, where we can popup UI with info on success
	if materials[res] > 0: try_unlock_material(res)
	if !log_f: return
	tmp = materials[res] - tmp
	if tmp > 0:
		var text = "Gained "
		text += str(tmp) + ' {color=yellow|' + tr(Items.Items[res].name) + '}'
		logupdate(text)
	elif tmp < 0:
		var text = "Lost "
		text += str(-tmp) + ' {color=yellow|' + tr(Items.Items[res].name) + '}'
		logupdate(text)


func add_money(value, log_f = true):
	var tmp = money
	money += value
	if money < 0: money = 0
	emit_signal("money_changed")
	if !log_f: return
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

