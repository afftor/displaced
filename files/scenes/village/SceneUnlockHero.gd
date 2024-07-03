extends TextureButton


func _ready():
	var chara = state.heroes[name]
	$TextureRect.texture = chara.portrait()
	$Label.text = tr(chara.name)
