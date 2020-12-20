extends TextureRect

var main_pos :Vector2
var tpos :Vector2

var max_x = 20.0
var max_y = 5.0
var speed = globals.rng.randf_range(0.3, 0.7)

func _ready():
	main_pos = rect_position
	rect_position.x += int(max_x)
	tpos = rect_position

func _process(delta):
	var off = tpos - main_pos
	var norm = Vector2(off.y * max_x / max_y, -off.x * max_y / max_x)
	tpos += norm * delta * speed
	rect_position.x = int(tpos.x)
	rect_position.y = int(tpos.y)
