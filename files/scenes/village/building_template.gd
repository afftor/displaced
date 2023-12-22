extends TextureButton
export var outline_hover = false

func _ready():
	connect("mouse_entered", self, 'on_mouse_hightlight', [true])
	connect("mouse_exited", self, 'on_mouse_hightlight', [false])
	connect('pressed', self, 'onclick')
	material = load("res://files/scenes/portret_shader.tres").duplicate();
	material.set_shader_param('outline_width', 2.0)
	hightlight(false)
	$QuestActive.visible = false
	build_icon()


func regenerate_click_mask():
	var t = texture_normal.get_data()
	texture_click_mask = BitMap.new()
	texture_click_mask.create_from_image_alpha(t)


func build_icon():
	if !state.townupgrades.has(name): 
		visible = false
#		regenerate_click_mask()
		return
	var data = Upgradedata.upgradelist[name]
	var lvl_data = data.levels[state.townupgrades[name]]
	texture_normal = lvl_data.node
	regenerate_click_mask()
	visible = true
	#todo filling hint


#func play_upgrade_animation():
#	if !visible:
#		if !state.townupgrades.has(name):
#			print('error in upgrade data')
#	else:
#		input_handler.FadeAnimation(self, 1.0, 0)
#	var data = Upgradedata.upgradelist[name]
#	var lvl_data = data.levels[state.townupgrades[name]]
#	texture_normal = lvl_data.node
#	input_handler.UnfadeAnimation(self, 1.5, 1.0)
#	yield(get_tree().create_timer(2.5), 'timeout')
#	regenerate_click_mask()

func set_active():
#	is_active = true
	visible = true
	$QuestActive.visible = true
#	set_process(true)
#	material.set_shader_param('opacity', 0.8);


func set_inactive():
#	is_active = false
#	set_process(false)
	$QuestActive.visible = false

func on_mouse_hightlight(flag):
	if !outline_hover: return
	hightlight(flag)

func hightlight(flag):
	if flag:
		material.set_shader_param('opacity', 0.9)
		material.set_shader_param('highlight', 0.1)
	else:
		material.set_shader_param('opacity', 0.0);
		material.set_shader_param('highlight', 0.0)

func onclick():
	get_parent().building_entered(name)
