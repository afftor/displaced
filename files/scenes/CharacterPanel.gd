extends "res://files/Close Panel Button/ClosingPanel.gd"

var character

onready var charlist = $Panel/ScrollContainer/HBoxContainer
#onready var skill_list = $Panel/SkillContainer/GridContainer
onready var stats_list = $Panel/StatsPanel
onready var res_list = $Panel/ResPanel/res

export var test_mode = false
var lock

func _ready():
	visible = false
	if resources.is_busy(): 
		yield(resources, "done_work")
	input_handler.ClearContainer(charlist, ['panel'])
	for cid in state.characters:
		var hero = state.heroes[cid]
		var ch = input_handler.DuplicateContainerTemplate(charlist, 'panel')
		ch.name = cid
		ch.get_node('Label').text = hero.name
		ch.get_node('Label2').text = "Level %d" % hero.level
		ch.get_node('TextureRect').texture = hero.portrait()
		ch.connect('pressed', self, 'select_hero', [cid])
	
	$Panel/SkillsButton.connect("pressed", self, "open_skills")
#	$Panel/Weapon.connect("pressed", self, "open_weapon")
	$SkillPanel/CloseButton.connect("pressed",self,"close_skills")
#	$WeaponPanel/CloseButton.connect("pressed",self,"close_weapon")
#	$Panel/PrevCharButton.connect("pressed", self, "select_next_hero", [-1])
#	$Panel/NextCharButton.connect("pressed", self, "select_next_hero", [1])
#	$Panel/close.connect("pressed", self, "hide")
	if test_mode:
		testmode()
		if resources.is_busy(): yield(resources, "done_work")
		open(state.heroes['arron'])


func testmode():
	for cid in state.characters:
		state.unlock_char(cid)
		state.heroes[cid].upgrade_gear('weapon2')
		state.heroes[cid].upgrade_gear('weapon2')


func RepositionCloseButton():
	var rect = $Panel.get_global_rect()
	var pos = Vector2(rect.end.x + 6 - closebutton.rect_size.x - closebuttonoffset[0], rect.position.y + closebuttonoffset[1])
	closebutton.set_global_position(pos)


func open(hero, locked = false): 
	character = hero
	lock = locked
#	$Panel/Portrait.texture = resources.get_res(character.icon)
#	$Panel/NameLabel.text = character.name
#	build_gear()
#	build_skills()
	select_hero(hero.id, true)
	show()


func select_hero(cid, rebuild = false):
	for ch in charlist.get_children():
		if ch.name == 'panel': continue
		var hero = state.heroes[ch.name]
		ch.visible = hero.unlocked
		ch.pressed = (ch.name == cid)
		ch.rebuild()
	if cid == character.id and !rebuild: return
	character = state.heroes[cid]
	for slot in ['weapon1', 'weapon2', 'armor']:
		build_slot(slot)
	build_stats()
	$SkillPanel.hide()
	select_slot(character.curweapon)
#	build_gear()


func build_slot(slot):
	var panel = $Panel.get_node(slot)
	var data = character.get_item_data(slot)
	if data.level < 1:
		panel.disabled = true
		panel.get_node("Label2").text = "???" #stub
		panel.get_node("Label").text = "" #stub
	else:
		panel.disabled = false
		panel.get_node("Label2").text = data.name
		panel.get_node("Label").text = "Level %d" % data.level
	panel.get_node("Icon").texture = data.icon
	if slot != 'armor':
		panel.pressed = (character.curweapon == slot)
		if panel.is_connected("pressed", self, 'select_slot'):
			panel.disconnect("pressed", self, 'select_slot')
		panel.connect('pressed', self, 'select_slot', [slot])
	globals.connectslottooltip(panel, character.id, slot, Vector2(300, 210) + get_global_position())


func select_slot(sel):
	character.set_weapon(sel)
	build_stats()
	for slot in ['weapon1', 'weapon2']:
		var panel = $Panel.get_node(slot)
		if sel == slot:
			panel.pressed = true
			panel.get_node('Label').set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
			panel.get_node('Label2').set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
		else:
			panel.pressed = false
			panel.get_node('Label').set("custom_colors/font_color", variables.hexcolordict.light_grey)
			panel.get_node('Label2').set("custom_colors/font_color", variables.hexcolordict.light_grey)

func open_skills():
	if lock: return
	if $SkillPanel.is_visible_in_tree() == true:
		$SkillPanel.hide()
	else:
		$SkillPanel.open(character)


func close_skills():
	$SkillPanel.hide()
#	build_skills()
#	open(character)



func build_gear():
	var data = character.get_item_data(character.curweapon)
	$Panel/Weapon.texture_normal = data.icon
	$Panel/Weapon/Label.text = "{name} level {level}".format(data)
#	$Panel/Weapon/Label.text = "%s level %d" % [data.name, data.level]
	$Panel/Weapon/Label2.text = data.description
	data = character.get_item_data('armor')
	$Panel/Armor.texture = data.icon
	$Panel/Armor/Label.text = "{name} level {level}".format(data)
	$Panel/Armor/Label2.text = data.description
	#2fix tooltip positions
	globals.connectslottooltip($Panel/Weapon, character.id, data.type, Vector2(1300, 210) + get_global_position())
	globals.connectslottooltip($Panel/Armor, character.id, data.type, Vector2(1300, 210) + get_global_position())


var statlist = {
#	'EXP': {
#		text = ['get_baseexp', '/', 'get_exp_cap'],
#		icon = null
#		},
	'HP': {
		text = ['get_hp', '/', 'get_hpmax'],
		icon = "res://assets/images/iconsskills/rose_8.png"
		},
	'DMG': {
#		text = ['get_damage', ' (', 'get_base_dmg_type', ')'],
		text = ['get_damage'],
		icon = ["res://assets/images/iconsskills/source_%s.png", 'get_base_dmg_type']
		}
}
func build_stats():
	stats_list.get_node('name').text = character.name
	var v1 = character.get_stat('baseexp')
	var v2 = character.get_stat('exp_cap')
	stats_list.get_node("exp").max_value = v2
	stats_list.get_node("exp").value = v1
	stats_list.get_node("exp/Label").text = "%d/%d" % [v1, v2]
#	input_handler.ClearContainer(stats_list.get_node('stats/statnames'), ['panel'])
#	input_handler.ClearContainer(stats_list.get_node('stats/values'), ['panel'])
#	input_handler.ClearContainer(stats_list.get_node('stats/icons'), ['panel'])
	input_handler.ClearContainer(stats_list.get_node('stats'), ['panel'])
	for st in statlist:
#		var p1 = input_handler.DuplicateContainerTemplate(stats_list.get_node('stats/statnames'), 'panel')
#		var p2 = input_handler.DuplicateContainerTemplate(stats_list.get_node('stats/values'), 'panel')
#		var p3 = input_handler.DuplicateContainerTemplate(stats_list.get_node('stats/icons'), 'panel')
		var panel = input_handler.DuplicateContainerTemplate(stats_list.get_node('stats'), 'panel')
		panel.get_node('stat').text = st
		var tval = ""
		for line in statlist[st].text:
			if line.begins_with("get_"):
				tval += str(character.get_stat(line.trim_prefix("get_")))
			else:
				tval += line
		panel.get_node('value').text = tval
		if typeof(statlist[st].icon) == TYPE_STRING:
			panel.get_node('icon').texture = load(statlist[st].icon)
		elif typeof(statlist[st].icon) == TYPE_ARRAY:
			var tname = statlist[st].icon[0]
			var tstat = statlist[st].icon[1]
			if tstat.begins_with("get_"):
				tstat = character.get_stat(tstat.trim_prefix("get_"))
			panel.get_node('icon').texture = load(tname % tstat)
		else:
			panel.get_node('icon').texture = statlist[st].icon
	build_res()


func build_res():
	input_handler.ClearContainer(res_list, ['panel'])
	var resists = character.get_stat('resists')
	for src in variables.resistlist:
		if src == 'damage' : continue
		var panel = input_handler.DuplicateContainerTemplate(res_list, 'panel')
		panel.get_node('Label').text = ": %d" % resists[src] + "%"
		panel.get_node('icon/src').texture = load("res://assets/images/iconsskills/source_%s.png" % src)
		panel.get_node("icon").hint_tooltip = "Resist: " + src.capitalize() #TODO: change to actual tooltip later
 
