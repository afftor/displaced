extends CheckBox

export(Texture) var disable_normal
export(Texture) var disable_pressed

func smart_disable(value :bool):
	if value:
		var new_tex
		if pressed:
			new_tex = disable_pressed
		else:
			new_tex = disable_normal
		get_stylebox('disabled').texture = new_tex
	disabled = value
