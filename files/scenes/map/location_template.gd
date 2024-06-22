extends TextureButton

#var is_active = false

var anim_up = true
var speed = 0.66

func _process(delta):
	var tmp = material.get_shader_param('opacity')
	if anim_up: 
		tmp += delta * speed
		if tmp >= 1.0:
			anim_up = false
			tmp = 1.0
	else:
		tmp -= delta * speed
		if tmp <= 0.0:
			anim_up = true
			tmp = 0.0
	material.set_shader_param('opacity', tmp)


func _ready():
	set_process(false)
	material = load("res://files/scenes/portret_shader.tres").duplicate();
	material.set_shader_param('opacity', 0.0);
	connect('pressed', self, '_onclick')
	connect('mouse_entered', self, 'set_highlight', [true])
	connect('mouse_exited', self, 'set_highlight', [false])
	regenerate_click_mask()


func regenerate_click_mask():
	var t = texture_normal.get_data()
	texture_click_mask = BitMap.new()
	texture_click_mask.create_from_image_alpha(t)


func _onclick():
	input_handler.map_node.location_pressed(name)


func m_hide():
#	visible = true
	$clouds.visible = true


func m_show():
#	visible = true
	$clouds.visible = false


func set_active():
#	is_active = true
	set_process(true)
#	visible = true
#	set_process_input(true)
	material.set_shader_param('opacity', 0.8);


func set_inactive():
#	is_active = false
	set_process(false)
#	visible = false
#	set_process_input(false)
	material.set_shader_param('opacity', 0.0);


func set_highlight(val):
	if val: 
#		modulate.a = 0.2
		material.set_shader_param('highlight', 0.2)
	else: 
		material.set_shader_param('highlight', 0.0)
#		modulate.a = 1.0

func set_border_type(val):
	match val:
		'event':
			material.set_shader_param('outline_color', Color(0.9, 0.9, 0.25))
		'combat':
			material.set_shader_param('outline_color', Color(1.0, 0.0, 0.0))
		'combat_replays':
			material.set_shader_param('outline_color', Color(0.9, 0.6, 0.3))
		'safe':
			material.set_shader_param('outline_color', Color(0.0, 0.9, 0.0))


func set_current(val):
	$active.visible = val

func is_current() ->bool:
	return $active.visible
