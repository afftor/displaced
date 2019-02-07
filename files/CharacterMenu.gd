extends "res://files/Close Panel Button/ClosingPanel.gd"

var character

var emptygearicons = {}

func _ready():
	for i in globals.gearlist:
		var node = get_node('Main/Panel/charandgear/' + i)
		node.connect("pressed",self,'unequip', [i])

func open(hero):
	character = hero
	globals.CurrentScene.openinventory(character)
	show()
	for i in globals.gearlist:
		var node = get_node('Main/Panel/charandgear/' + i)
		if character.gear[i] != null:
			var gear = state.items[character.gear[i]]
			input_handler.itemshadeimage(node, gear)
			globals.connectitemtooltip(node, gear)
		else:
			node.texture_normal = null
	$Main/Panel/charandgear/image.texture = images.sprites[character.image]
	$Main/Panel/charandgear/hp.value = globals.calculatepercent(character.hp, character.hpmax())
	$Main/Panel/charandgear/hp/Label.text = str(character.hp) + '/' + str(character.hpmax())
	$Main/Panel/charandgear/mp.value = globals.calculatepercent(character.mana, character.manamax())
	$Main/Panel/charandgear/mp/Label.text = str(character.mana) + '/' + str(character.manamax())
	
	$Name.text = character.name + ' Level: ' + str(character.level)
	
	for i in ['damage','armorpenetration','hitrate','speed','armor','evasion', 'resistfire','resistearth','resistwater','resistair']:
		var node = get_node("Main/stats&skills/" + i)
		var text = Items.stats[i] + ": " + str(character[i])
		node.text = text
	
	globals.ClearContainer($"Main/stats&skills/VBoxContainer")
	for i in character.skills:
		var skill = globals.skills[i]
		var newbutton = globals.DuplicateContainerTemplate($"Main/stats&skills/VBoxContainer")
		#newbutton.get_node("Label").text = skill.name
		newbutton.get_node("Icon").texture = skill.icon

func unequip(slot):
	if character.gear[slot] != null:
		var gear = globals.state.items[character.gear[slot]]
		character.unequip(gear)
		globals.disconnecttooltip(get_node('Main/Panel/charandgear/' + slot))
		open(character)