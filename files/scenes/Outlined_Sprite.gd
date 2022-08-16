extends TextureButton

var timer = 0.0
var k = 1.0

func _process(delta):
	timer += k * delta
	if timer > 0.8:
		timer = 0.8
		k = -1.0
	if timer < 0.0:
		timer = 0.0
		k = 1.0
	if material == null: return
	material.set_shader_param('opacity', timer)

func _ready():
	material = load("res://files/scenes/portret_shader.tres").duplicate();
	material.set_shader_param('opacity', 0.0);
	material.set_shader_param('outline_width', 3.0)
