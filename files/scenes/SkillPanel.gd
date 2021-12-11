extends Panel

onready var skill_list = $ScrollContainer/GridContainer

var character 

func _ready():
	pass


func open(hero):
	character = hero
	build_sp()
	build_skills()
	show()


func build_sp():
	$Label.text = "Attack SP %d | Support SP %d | Ultimate SP %d" % [character.skillpoints.main, character.skillpoints.support, character.skillpoints.ultimate]


func build_skills():
	var chardata = combatantdata.charlist[character.id]
	input_handler.ClearContainer(skill_list)
	for skill_id in chardata.skilllist: #attack not showing due to being always learned
		var skilldata = Skillsdata.patch_skill(skill_id, character)
		var panel = input_handler.DuplicateContainerTemplate(skill_list)
		panel.get_node("Label").text = skilldata.name
		panel.get_node('icon').material = panel.get_node('icon').material.duplicate()
		panel.get_node('icon').texture = skilldata.icon
		#2add icon node and set icon data to it!
#		panel.texture_normal = skilldata.icon
		globals.connectskilltooltip(panel, character.id, skill_id)
		if character.skills.has(skill_id):
			panel.pressed = true
			panel.connect("pressed", self, "unlearn_skill", [skill_id])
			if !character.can_forget_skill(skill_id):
				panel.disabled = true
				panel.get_node('icon').material.set_shader_param('percent', 1.0)
			else:
				panel.get_node('icon').material.set_shader_param('percent', 0.0)
		else:
			panel.pressed = false
			panel.connect("pressed", self, "learn_skill", [skill_id])
			if !character.can_unlock_skill(skill_id):
				panel.disabled = true
				panel.get_node('icon').material.set_shader_param('percent', 1.0)
			else:
				panel.get_node('icon').material.set_shader_param('percent', 0.5)


func unlearn_skill(skill_id):
	character.forget_skill(skill_id)
	build_sp()
	build_skills()


func learn_skill(skill_id):
	character.unlock_skill(skill_id)
	build_sp()
	build_skills()
