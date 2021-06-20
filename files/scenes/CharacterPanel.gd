extends Control

var character

onready var skill_list = $Panel/SkillContainer/GridContainer
onready var stats_list = $Panel/StatsLabel

export var test_mode = false

func _ready():
	$Panel/SkillsButton.connect("pressed", self, "open_skills")
	$Panel/Weapon.connect("pressed", self, "open_weapon")
	$SkillPanel/CloseButton.connect("pressed",self,"close_skills")
	$WeaponPanel/CloseButton.connect("pressed",self,"close_weapon")
	$Panel/PrevCharButton.connect("pressed", self, "select_next_hero", [-1])
	$Panel/NextCharButton.connect("pressed", self, "select_next_hero", [1])
	hide()
	if test_mode: 
		testmode()
		if resources.is_busy(): yield(resources, "done_work")
		open(state.heroes['arron'])

func testmode():
	for cid in state.characters:
		state.unlock_char(cid)


func open(hero): #renamed arg due to being a hero class object and not dir from chardata
	character = hero
	$Panel/Portrait.texture = resources.get_res(character.icon) 
	$Panel/NameLabel.text = character.name
	build_gear()
	build_skills()
	build_stats()
	
	show()


func open_skills():
	$SkillPanel.open(character)

func open_weapon():
	$WeaponPanel.open(character)

func close_skills():
	$SkillPanel.hide()
	build_skills()
#	open(character)

func close_weapon():
	$WeaponPanel.hide()
	build_gear()
	build_skills()
	build_stats()
#	open(character)

func select_next_hero(offset):
	#stub, 2move to gamestate
	var pos = state.characters.find(character.id)
	pos += offset
	pos += state.characters.size()
	pos = pos % state.characters.size()
	var nhero = state.heroes[state.characters[pos]]
	if !nhero.unlocked:
		select_next_hero(offset)
		return
	
	open(nhero)


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

func build_skills():
	var chardata = combatantdata.charlist[character.id]
	input_handler.ClearContainer(skill_list)
	for skill_id in ['attack'] + chardata.skilllist: 
		if !character.skills.has(skill_id): continue
		var skilldata = Skillsdata.patch_skill(skill_id, character)
		var panel = input_handler.DuplicateContainerTemplate(skill_list)
		panel.get_node("Label").text = skilldata.name
		#2add icon node and set icon data to it!
#		panel.texture = skilldata.icon
		globals.connectskilltooltip(panel, character.id, skill_id)


func build_stats():
	$Panel/ExpBar/Label.text = "Level %d" % character.level
	$Panel/ExpBar.value = character.baseexp
	var text = "Stats:\n"
	#2add transition to statnames from stats codes
	#translation not adapted to current stats
	for stat in ["hp"]:
		text += "%s: %d/%d\n" % [stat, character.get_stat(stat), character.get_stat(stat + 'max')]
	for stat in ["damage", "base_dmg_type"]:
		text += "%s: %s\n" % [stat, str(character.get_stat(stat))]
	
	stats_list.text = text
