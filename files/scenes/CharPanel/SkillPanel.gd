extends "res://files/Close Panel Button/ClosingPanel.gd"

onready var skill_list = $skills/list
onready var stats_list = $StatsPanel
onready var res_list = $ResPanel/res

var character 

func _ready():
	$close.connect("pressed", self, 'hide')


func open(hero):
	character = hero
	build_stats()
	show()


func RepositionCloseButton():
	var rect = get_global_rect()
	var pos = Vector2(rect.end.x - 154 - closebutton.rect_size.x - closebuttonoffset[0], rect.position.y + 30 + closebuttonoffset[1])
	closebutton.set_global_position(pos)



func build_stats():
	stats_list.get_node('name').text = character.name
	stats_list.get_node('desc').bbcode_text = tr(character.flavor)
	stats_list.get_node("icon_bounds/icon").texture = character.animations.idle_1
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
#	input_handler.ClearContainer(stats_list.get_node('stats/statnames'), ['panel'])
#	input_handler.ClearContainer(stats_list.get_node('stats/values'), ['panel'])
#	input_handler.ClearContainer(stats_list.get_node('stats/icons'), ['panel'])
	stats_list.get_node("dmg/value").text = str(character.get_stat('damage'))
	stats_list.get_node("dmg/value").hint_tooltip = tr("BASEDAMAGE")
	stats_list.get_node("dmg/icon").texture = load("res://assets/images/iconsskills/source_%s.png" % character.get_stat('base_dmg_type'))
	var resist_str_id = variables.get_resist_data(character.get_stat('base_dmg_type')).name
	stats_list.get_node("dmg/icon").hint_tooltip = "%s: %s" % [tr("BASEDAMAGETYPE"), tr(resist_str_id)]
	if character.id == 'arron':
		stats_list.get_node("friend").hide()
	else:
		stats_list.get_node("friend").show()
		stats_list.get_node("friend/Label").text = String(int(character.friend_points))
	build_skills()
	build_res()


func build_skills():
	var chardata = combatantdata.charlist[character.id]
	input_handler.ClearContainer(skill_list, ['Panel'])
	for skill_id in chardata.skilllist: 
		if !character.skills.has(skill_id): continue #maybe not hide but build disabled
		var skilldata = Skillsdata.patch_skill(skill_id, character)
		var panel = input_handler.DuplicateContainerTemplate(skill_list, 'Panel')
		build_skill_panel(panel, skilldata)


func build_skill_panel(panel, data):
	panel.get_node('icon_container/TextureRect/icon').texture = data.icon
	panel.get_node('VBoxContainer/HBoxContainer/name').text = tr(data.name)
	var resist_icon = panel.get_node('VBoxContainer/HBoxContainer/ResistIcon')
	var damage_type :String = Skillsdata.get_true_damagetype(data.damagetype, character.id)
	if damage_type.empty():
		resist_icon.hide()
	else:
		resist_icon.set_resist_type(damage_type)
	if data.cooldown == 0:
		panel.get_node('VBoxContainer/HBoxContainer/cd').hide()
		panel.get_node('VBoxContainer/HBoxContainer/timer_icon').hide()
		panel.get_node('VBoxContainer/HBoxContainer/Label').hide()
	else:
		panel.get_node('VBoxContainer/HBoxContainer/cd').text = str(data.cooldown)
	panel.get_node('VBoxContainer/descript').bbcode_text = Skillsdata.get_description(data)


func build_res():
	input_handler.ClearContainer(res_list, ['panel'])
	var resists = character.get_resists()
	for src in variables.resistlist:
		if src == 'damage' or !state.is_resist_unlocked(src):
			continue
		var panel = input_handler.DuplicateContainerTemplate(res_list, 'panel')
		var resist_data = variables.get_resist_data(src)
		panel.get_node('Label').text = ": %d%%" % resists[src]
		panel.get_node('icon/src').texture = resist_data.icon
		panel.get_node("icon").hint_tooltip = "%s: %s" % [tr("RESIST"), tr(resist_data.name)]#TODO: change to actual tooltip later
