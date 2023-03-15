extends TextureRect

var max_x = 20.0
var max_y = 5.0
var speed = globals.rng.randf_range(0.3, 0.7)

func _ready():
	material = load("res://assets/sfx/cloud_shader.tres").duplicate()
	material.set_shader_param('speed', speed)
	material.set_shader_param('vax_offset', Vector2(max_x, max_y))
