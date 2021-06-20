extends Panel

onready var weaponcontainer = $ScrollContainer/GridContainer

var character

func open(hero):
	character = hero
	for slot in ['weapon1', 'weapon2']:
		var panel = weaponcontainer.get_node(slot)
		var data = character.get_item_data(slot)
		panel.pressed = (character.curweapon == slot)
		if data.level < 1:
			panel.visible = false
			continue
		panel.get_node("Label").text = data.name
		panel.get_node("TextureRect").texture = data.icon
		panel.connect('pressed', self, 'set_weapon', [slot])
		#2fix tooltip positions
		globals.connectslottooltip(panel.get_node("TextureRect"), character.id, slot, Vector2(300, 210) + get_global_position())
	show()

func set_weapon(slot):
	character.set_weapon(slot)
	open(character)
