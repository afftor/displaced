extends "res://files/Close Panel Button/ClosingPanel.gd"

var character
var skills_character_id

onready var charlist = $Panel/ScrollContainer/HBoxContainer
#onready var skill_list = $Panel/SkillContainer/GridContainer
onready var stats_list = $Panel/StatsPanel
onready var res_list = $Panel/ResPanel/res
onready var skill_list = $Panel/HBoxContainer

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
		ch.get_node('TextureRect').texture = hero.portrait()
		ch.connect('pressed', self, 'select_hero', [cid])
	
	$Panel/SkillsButton.connect("pressed", self, "open_skills")
	$SkillPanel/switch_left.connect("pressed", self, "switch_skills_left")
	$SkillPanel/switch_right.connect("pressed", self, "switch_skills_right")
#	$Panel/Weapon.connect("pressed", self, "open_weapon")
#	$SkillPanel/CloseButton.connect("pressed",self,"close_skills")
#	$WeaponPanel/CloseButton.connect("pressed",self,"close_weapon")
#	$Panel/PrevCharButton.connect("pressed", self, "select_next_hero", [-1])
#	$Panel/NextCharButton.connect("pressed", self, "select_next_hero", [1])
#	$Panel/close.connect("pressed", self, "hide")
	if test_mode:
		testmode()
		if resources.is_busy(): yield(resources, "done_work")
		open(state.heroes['arron'])
	
	for slot in ['weapon1', 'weapon2', 'armor']:
		var panel = $Panel.get_node(slot)
		var tooltip_pos
		if slot != 'armor':
			panel.connect('pressed', self, 'select_slot', [slot])
			var pos = panel.get_global_rect()
			tooltip_pos = Vector2(pos.end.x + 5, pos.position.y)
		else:
			var pos = panel.get_global_position()
			tooltip_pos = Vector2(pos.x - 405, pos.y)
		panel.connect("mouse_entered", self , 'show_slot_tooltip', [slot, tooltip_pos])
		panel.connect("mouse_exited", globals , 'hideslottooltip')
	connect("hide", globals , 'hideslottooltip')


func testmode():
	for cid in state.characters:
		state.unlock_char(cid)
		state.heroes[cid].upgrade_gear('weapon2')
		state.heroes[cid].upgrade_gear('weapon2')


func show_slot_tooltip(slot, pos):
	globals.showslottooltip(character.id, slot, pos)


func RepositionCloseButton():
	var rect = $Panel.get_global_rect()
	var pos = Vector2(rect.end.x + 6 - closebutton.rect_size.x - closebuttonoffset[0], rect.position.y + closebuttonoffset[1])
	closebutton.set_global_position(pos)
	$SkillPanel.raise()


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
		ch.get_node('Label2').text = tr("LEVEL") + " %d" % hero.level
		ch.visible = hero.unlocked
		ch.pressed = (ch.name == cid)
		ch.rebuild()
	if cid == character.id and !rebuild: return
	character = state.heroes[cid]
	skills_character_id = character.id
	for slot in ['weapon1', 'weapon2', 'armor']:
		build_slot(slot)
	build_stats()
	$SkillPanel.hide()
	select_slot(character.curweapon)
#	build_gear()


func build_slot(slot):
	var panel = $Panel.get_node(slot)
	var data = character.get_item_data(slot)
	if data.level > 0:
		panel.get_node("Label").text = tr("LEVEL") + " %d" % data.level
	else:
		panel.get_node("Label").text = "" #stub
	if slot == 'weapon2' and data.level < 1:
		panel.disabled = true
		panel.get_node("Label2").text = "???" #stub
	else:
		panel.disabled = false
		panel.get_node("Label2").text = data.name
	panel.get_node("Icon").texture = data.icon
	if slot != 'armor':
		panel.pressed = (character.curweapon == slot)


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
		skills_character_id = character.id
		$SkillPanel.open(character)


func close_skills():
	$SkillPanel.hide()
#	build_skills()
#	open(character)


#var statlist = {
##	'EXP': {
##		text = ['get_baseexp', '/', 'get_exp_cap'],
##		icon = null
##		},
##	'HP': {
##		text = ['get_hp', '/', 'get_hpmax'],
##		icon = "res://assets/images/iconsskills/rose_8.png"
##		},
#	'DMG': {
##		text = ['get_damage', ' (', 'get_base_dmg_type', ')'],
#		text = ['get_damage'],
#		icon = ["res://assets/images/iconsskills/source_%s.png", 'get_base_dmg_type']
#		}
#}
func build_stats():
	stats_list.get_node('name').text = character.name
	stats_list.get_node("portrait").texture = character.portrait()
	var v1 = character.get_stat('baseexp')
	var v2 = character.get_stat('exp_cap')
	stats_list.get_node("exp").max_value = v2
	stats_list.get_node("exp").value = v1
	stats_list.get_node("exp").hint_tooltip = tr("TOOLTIPEXP")
	
	stats_list.get_node("exp/Label").text = "%d/%d" % [v1, v2]
	v1 = character.hp
	v2 = character.get_stat('hpmax')
	stats_list.get_node("hp").max_value = v2
	stats_list.get_node("hp").value = v1
	stats_list.get_node("hp").hint_tooltip = tr("TOOLTIPHP")
	stats_list.get_node("hp/Label").text = "%d/%d" % [v1, v2]
	stats_list.get_node("dmg/value").text = str(character.get_stat('damage'))
	stats_list.get_node("dmg/value").hint_tooltip = tr("BASEDAMAGE")
	stats_list.get_node("dmg/icon").texture = load("res://assets/images/iconsskills/source_%s.png" % character.get_stat('base_dmg_type'))
	var resist_str_id = variables.get_resist_data(character.get_stat('base_dmg_type')).name
	stats_list.get_node("dmg/icon").hint_tooltip = "%s: %s" % [tr("BASEDAMAGETYPE"), tr(resist_str_id)]
	build_skills()


func build_res():
	input_handler.ClearContainer(res_list, ['panel'])
	var resists = character.get_stat('resists')
	for src in variables.resistlist:
		if src == 'damage' : continue
		var panel = input_handler.DuplicateContainerTemplate(res_list, 'panel')
		panel.get_node('Label').text = ": %d" % resists[src] + "%"
		panel.get_node('icon/src').texture = load("res://assets/images/iconsskills/source_%s.png" % src)
		panel.get_node("icon").hint_tooltip = "Resist: " + src.capitalize() #TODO: change to actual tooltip later
 
	
#
#
func build_skills():
	var chardata = combatantdata.charlist[character.id]
	input_handler.ClearContainer(skill_list)
	for skill_id in chardata.skilllist: #attack not showing due to being always learned
		var skilldata = Skillsdata.patch_skill(skill_id, character)
		var panel = input_handler.DuplicateContainerTemplate(skill_list)
#		panel.get_node("Label").text = skilldata.name
#		panel.get_node('icon').material = panel.get_node('icon').material.duplicate()
		panel.get_node('icon').texture = skilldata.icon
		globals.connectskilltooltip(panel, character.id, skill_id)
		panel.visible = character.skills.has(skill_id)


func switch_skills_left():
	var left_skills_character = get_new_skills_character(-1)
	$SkillPanel.open(left_skills_character)


func switch_skills_right():
	var right_skills_character = get_new_skills_character(+1)
	$SkillPanel.open(right_skills_character)


func get_new_skills_character(switch_val : int):
	var current_char_node = charlist.get_node(skills_character_id)
	var current_characters = []
	var current_character_ind : int
	for ch in charlist.get_children():
		if ch.visible:
			current_characters.append(ch)
	current_character_ind = current_characters.find(current_char_node)
	var new_character_ind = (current_character_ind + switch_val) % current_characters.size()
	var new_character_node = current_characters[new_character_ind]
	var new_character = state.heroes[new_character_node.name]
	skills_character_id = new_character_node.name
	return new_character
