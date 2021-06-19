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
		#2add icon node and set icon data to it!
#		panel.texture_normal = skilldata.icon
		#2make connect skill tooltip
		if character.skills.has(skill_id):
			panel.pressed = true
			panel.connect("pressed", self, "unlearn_skill", [skill_id])
			if !character.can_forget_skill(skill_id):
				panel.disabled = true
		else:
			panel.pressed = false
			panel.connect("pressed", self, "learn_skill", [skill_id])
			if !character.can_unlock_skill(skill_id):
				panel.disabled = true


func unlearn_skill(skill_id):
	character.forget_skill(skill_id)
	build_sp()
	build_skills()


func learn_skill(skill_id):
	character.unlock_skill(skill_id)
	build_sp()
	build_skills()
