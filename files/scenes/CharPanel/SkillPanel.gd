extends "res://files/Close Panel Button/ClosingPanel.gd"

onready var skill_list = $skills
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
	stats_list.get_node("icon").texture = character.animations.idle_1
	var v1 = character.get_stat('baseexp')
	var v2 = character.get_stat('exp_cap')
	stats_list.get_node("exp").max_value = v2
	stats_list.get_node("exp").value = v1
	stats_list.get_node("exp/Label").text = "%d/%d" % [v1, v2]
	v1 = character.hp
	v2 = character.get_stat('hpmax')
	stats_list.get_node("hp").max_value = v2
	stats_list.get_node("hp").value = v1
	stats_list.get_node("hp/Label").text = "%d/%d" % [v1, v2]
#	input_handler.ClearContainer(stats_list.get_node('stats/statnames'), ['panel'])
#	input_handler.ClearContainer(stats_list.get_node('stats/values'), ['panel'])
#	input_handler.ClearContainer(stats_list.get_node('stats/icons'), ['panel'])
	stats_list.get_node("dmg/value").text = str(character.get_stat('damage'))
	stats_list.get_node("dmg/icon").texture = load("res://assets/images/iconsskills/source_%s.png" % character.get_stat('base_dmg_type'))
	build_skills()
	build_res()


func build_skills():
	var chardata = combatantdata.charlist[character.id]
	input_handler.ClearContainer(skill_list, ['Panel'])
	for skill_id in chardata.skilllist: 
		var skilldata = Skillsdata.patch_skill(skill_id, character)
		var panel = input_handler.DuplicateContainerTemplate(skill_list, 'Panel')
		build_skill_panel(panel, skilldata)


func build_skill_panel(panel, data):
	panel.get_node('TextureRect/icon').texture = data.icon
	panel.get_node('VBoxContainer/HBoxContainer/name').text = tr(data.name)
	panel.get_node('VBoxContainer/HBoxContainer/cd').text = str(data.cooldown)
#	panel.get_node('VBoxContainer/descript').text = tr(data.description)
	panel.get_node('VBoxContainer/descript').text = tr("SKILL" + data.code.to_upper() + "DESCRIPT")


func build_res():
	input_handler.ClearContainer(res_list, ['panel'])
	var resists = character.get_stat('resists')
	for src in variables.resistlist:
		if src == 'damage' : continue
		var panel = input_handler.DuplicateContainerTemplate(res_list, 'panel')
		panel.get_node('Label').text = ": %d" % resists[src] + "%"
		panel.get_node('icon/src').texture = load("res://assets/images/iconsskills/source_%s.png" % src)
		panel.get_node("icon").hint_tooltip = "Resist: " + src.capitalize() #TODO: change to actual tooltip later
