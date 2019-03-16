extends TextureRect

var character

func _ready():
	$GoldButton.connect("pressed",self,'goldbuttonpress')
#	character = globals.combatant.new()
#	character.createfromname('Arron')
#	levelup(character)

func levelup(character):
	globals.ClearContainer($HBoxContainer)
	var array = character.get_lvup_traits()
	for i in array:
		var newtrait = Traitdata.traitlist[i]
		var newbutton = globals.DuplicateContainerTemplate($HBoxContainer)
		newbutton.get_node("Icon").texture = newtrait.icon
		newbutton.get_node("RichTextLabel").bbcode_text = newtrait.description
		newbutton.get_node("Button").connect("pressed", self, "selecttrait", [i])

func selecttrait(trait):
	character.add_trait(trait)
	hide()

func goldbuttonpress():
	state.money += 100
	hide()