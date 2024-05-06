extends AnimatedSprite

export var spirit_number = 0
var positions = [[-40, -64], [40, 8], [-24, 64]]

func _enter_tree():
	if !get_parent().has_node("sprite"):
		return
	var sprite = get_parent().get_node("sprite")
	position = sprite.rect_position
	position += sprite.rect_size / 2
	position.x += positions[spirit_number][0]
	position.y += positions[spirit_number][1]
