extends TextureButton


func _ready():
	connect("mouse_entererd", self, 'hightlight', [true])
	connect("mouse_exited", self, 'hightlight', [false])
	material = load("res://files/scenes/portret_shader.tres").duplicate();
	material.set_shader_param('outline_width', 3.0)
	hightlight(false)
	build_icon()


func regenerate_click_mask():
	var t = texture_normal.get_data()
	texture_click_mask = BitMap.new()
	texture_click_mask.create_from_image_alpha(t)


func build_icon():
	if !state.townupgrades.has(name): 
		visible = false
		return
	var data = globals.upgradelist[name]
	var lvl_data = data[state.townupgrades[name]]
	texture_normal = lvl_data.icon
	regenerate_click_mask()
	visible = true


func set_active():
#	is_active = true
	visible = true
#	set_process(true)
#	material.set_shader_param('opacity', 0.8);


func set_inactive():
#	is_active = false
#	set_process(false)
	visible = false

func hightlight(flag):
	if flag:
		material.set_shader_param('opacity', 0.9)
		material.set_shader_param('highlight', 0.2)
	else:
		material.set_shader_param('opacity', 0.0);
		material.set_shader_param('highlight', 0.0)
