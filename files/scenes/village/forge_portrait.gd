extends TextureButton

var over

func _ready():
#	connect("pressed", self, 'rebuild')
	connect("mouse_entered", self, 'moin')
	connect("mouse_exited", self, 'mover')

func rebuild():
	if pressed:
		$Label.set("custom_colors/font_color", variables.hexcolordict.highlight_blue)
	elif over:
		$Label.set("custom_colors/font_color", variables.hexcolordict.light_grey)
	else:
		$Label.set("custom_colors/font_color", variables.hexcolordict.dark_grey)


func mover():
	over = false
	rebuild()

func moin():
	over = true
	rebuild()
