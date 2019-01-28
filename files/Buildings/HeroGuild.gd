extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedhero

func _ready():
	globals.AddPanelOpenCloseAnimation($HeroHire)
	$HeroHire/Button.connect('pressed', self, 'hirehero')

func open():
	show()
	globals.ClearContainer($Panel/ScrollContainer/VBoxContainer)
	selectedhero = null
	for i in globals.state.heroguild:
		var newhero = globals.DuplicateContainerTemplate($Panel/ScrollContainer/VBoxContainer)
		newhero.get_node('Icon').texture = i.icon
		newhero.get_node('Label').text = i.name
		newhero.get_node('Price').text = str(i.price)
		newhero.connect('pressed',self,'selecthero',[i])

func selecthero(hero):
	var text = ''
	$HeroHire.show()
	selectedhero = hero
	globals.ClearContainer($HeroHire/traits)
	
	$HeroHire/hp.text = str(hero.hp) + '/' + str(hero.hpmax)
	$HeroHire/mana.text = str(hero.mana) + '/' + str(hero.manamax)
	
	text += 'Name: ' + hero.name + '\nClass: ' + globals.classes[hero.base].name + '\nPrice: ' + str(hero.price)
	$HeroHire/RichTextLabel.bbcode_text = text
	
	for i in hero.traits:
		var trait = globals.traits[i]
		var newlabel = globals.DuplicateContainerTemplate($HeroHire/traits)
		newlabel.text = trait.name
		globals.connecttooltip(newlabel,trait.description)
	
	$HeroHire/Button.disabled = globals.state.money < hero.price

func hirehero():
	globals.state.money -= selectedhero.price
	globals.state.heroes[selectedhero.id] = selectedhero
	globals.state.heroguild.erase(selectedhero)
	$HeroHire.hide()
	open()