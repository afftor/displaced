extends AnimatedSprite


export var adjust = true
#export (String, "center", "bottom") var pos

func _enter_tree():
	if adjust and get_parent().has_node("sprite"):
		# move sfx to a sprite
		self.position = get_parent().get_node("sprite").rect_position
		
		#adjust sfx pos according to sprite size
		self.position += get_parent().get_node("sprite").rect_size / 2
