extends Control

var character

func _ready():
	$Panel/SkillsButton.connect("pressed", self, "open_skills")
	$SkillPanel/CloseButton.connect("pressed",self,"close_skills")


func open(char_data):
	character = char_data
	$Panel/Portrait.texture = character.icon
	$Panel/NameLabel.text = character.name




func open_skills():
	$SkillPanel.show()

func close_skills():
	$SkillPanel.hide()
