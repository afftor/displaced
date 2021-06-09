extends TextureButton

var animation_node


signal signal_RMB
signal signal_RMB_release
signal signal_LMB

var position = 0
var fighter
var RMBpressed = false

var anim_up = true
var hightlight = false
var highlight_animated = false
var speed = 1.33
#var damageeffectsarray = []

var hp
var mp
var buffs = []

#data format: node, time, type, slot, params


func _process(delta):
	if !hightlight or !highlight_animated: return
	var tmp = $sprite.material.get_shader_param('opacity')
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
	$sprite.material.set_shader_param('opacity', tmp)


func _ready():
	$sprite.material = load("res://files/scenes/portret_shader.tres").duplicate();
	$sprite.material.set_shader_param('outline_width', 1.0)


func _input(event):
	if input_handler.if_mouse_inside($sprite) or input_handler.if_mouse_inside($sprite2):
		if event.is_pressed():
			if event.is_action("RMB"):
				emit_signal("signal_RMB", fighter)
				RMBpressed = true
			elif event.is_action('LMB'):
				emit_signal("signal_LMB", position)
	if event.is_action_released("RMB") && RMBpressed == true:
		emit_signal("signal_RMB_release")
		RMBpressed = false


func setup_character(ch):
#	print(ch.name)
	fighter = ch
	ch.displaynode = self
	position = fighter.position
	$sprite.texture = null
#	print($sprite.margin_bottom)
	$sprite.rect_min_size = fighter.animations.idle.get_size()
#	print($sprite.margin_bottom)
	$sprite.texture = fighter.animations.idle
#	print($sprite.margin_bottom)
	texture_normal = fighter.animations.hit
	$Label.text = fighter.name
	$HP.value = globals.calculatepercent(fighter.hp, fighter.get_stat('hpmax'))
	hp = fighter.hp
	update_hp_label(fighter.hp, 100.0)
	regenerate_click_mask() # some cheating with not doing this every frame
	reset_shield()
	stop_highlight()
	set_process_input(true)
	connect("signal_RMB", globals.combat_node, "ShowFighterStats")
	connect("signal_RMB_release", globals.combat_node, 'HideFighterStats')
	connect("signal_LMB", globals.combat_node, 'FighterPress')
	connect("mouse_entered", globals.combat_node, 'FighterMouseOver', [position])
	connect("mouse_exited", globals.combat_node, 'FighterMouseOverFinish', [position])


func reset_shield():
	$shield.rect_size = $sprite.rect_size * 1.5
	$shield.rect_position = - $shield.rect_size / 6.0
	$shield.visible = false


func regenerate_click_mask():
	var t = $sprite.texture.get_data()
#	var t = texture_normal.get_data()
	var tt = t.duplicate()
	tt.lock()
	var tm = Image.new()
	tm.create(rect_size.x, rect_size.y, false, 5)
	tm.fill(Color8(0, 0, 0, 0))
	tm.blend_rect(tt, Rect2(Vector2(0, 0), tt.get_size()), $sprite.rect_position)
	
#	var temp = ImageTexture.new()
#	temp.create_from_image(tm)
#	texture_normal = temp
#	$sprite.visible = false
	
	texture_click_mask = BitMap.new()
#	texture_click_mask.create_from_image_alpha(tt, 0.9)
	texture_click_mask.create_from_image_alpha(tm, 0.9)
	

#func get_attack_vector():
#	if fighter.combatgroup == 'ally': return Vector2(100, 0)
#	elif fighter.combatgroup == 'enemy': return Vector2(-100, 0)


func update_hp():
	if hp == null:
		hp = fighter.hp
	if hp != null && hp != fighter.hp:
		var args = {damage = 0, type = '', color = Color(), newhp = fighter.hp, newhpp = globals.calculatepercent(fighter.hp, fighter.get_stat('hpmax')), damage_float = true}
		args.damage = fighter.hp - hp
		if args.damage < 0:
			args.color = Color(0.8,0.2,0.2)
			if fighter.combatgroup == 'ally':
				args.type = 'damageally'
			else:
				args.type = 'damageenemy' 
		else:
			args.type = 'heal'
			args.color = Color(0.2,0.8,0.2)
		if hp <= 0: args.damage_float = false
		hp = fighter.hp
		if hp < 0:
			args.newhp = 0
			args.newhpp = 0
			hp = 0
		#damageeffectsarray.append(data)
		var data = {node = self, time = globals.combat_node.turns,type = 'hp_update',slot = 'HP', params = args}
		animation_node.add_new_data(data)


func update_shield(): 
	var args = {}
	if fighter.shield <= 0: 
		args.value = false
		#args.color = Color(0.9, 0.9, 0.9, 0.0)
		#self.material.set_shader_param('modulate', Color(0.9, 0.9, 0.9, 0.0))
		#return
	else:
		args.value = false
		#args.color = Color(0.8, 0.8, 0.8, 1.0)
		#self.material.set_shader_param('modulate', Color(0.8, 0.8, 0.8, 1.0)); #example
	var data = {node = self, time = globals.combat_node.turns, type = 'shield_update',slot = 'SHIELD', params = args}
	animation_node.add_new_data(data)

func process_sfx(code):
	var data 
	if code.begins_with('anim_'):
		data = {node = self, time = globals.combat_node.turns,type = 'default_animation', slot = 'sprite2', params = {animation = code.trim_prefix('anim_')}}
	else:
		data = {node = self, time = globals.combat_node.turns,type = code, slot = 'SFX', params = {}}
	animation_node.add_new_data(data)

func process_sound(sound):
	var data = {node = self, time = globals.combat_node.turns, type = 'sound', slot = 'sound', params = {sound = sound}}
	animation_node.add_new_data(data)

func rebuildbuffs():
	var data = {node = self, time = globals.combat_node.turns, type = 'buffs', slot = 'buffs', params = fighter.get_all_buffs()}
	animation_node.add_new_data(data)

func process_critical():
	var data = {node = self, time = globals.combat_node.turns, type = 'critical', slot = 'crit', params = {}}
	animation_node.add_new_data(data)

func process_enable():
	var data = {node = self, time = globals.combat_node.turns, type = 'enable', slot = 'full', params = {}}
	animation_node.add_new_data(data)

func process_disable():
	disabled = true
	var data = {node = self, time = globals.combat_node.turns, type = 'disable', slot = 'full', params = {}}
	animation_node.add_new_data(data)

func appear():#stub
	var data = {node = self, time = globals.combat_node.turns, type = 'reappear', slot = 'full', params = {}}
	animation_node.add_new_data(data)

func disappear():#stub
	var data = {node = self, time = globals.combat_node.turns, type = 'disappear', slot = 'full', params = {}}
	animation_node.add_new_data(data)

#control visuals
func noq_rebuildbuffs(newbuffs):
	var oldbuff = 0
	for b in newbuffs:
		if buffs.has(b.template_name): oldbuff += 1
	if oldbuff == buffs.size():
		for i in newbuffs:
			if buffs.has(i.template_name): update_buff(i)
			else: add_buff(i)
	else:
		globals.ClearContainer($Buffs)
		buffs.clear()
		for i in newbuffs:
			add_buff(i)

func add_buff(i):
	var newbuff = globals.DuplicateContainerTemplate($Buffs)
	var text = i.description
	newbuff.texture = i.icon
	buffs.push_back(i.template_name)
	if i.template.has('bonuseffect'):
		match i.template.bonuseffect:
			'barrier':
				newbuff.get_node("Label").show()
				newbuff.get_node("Label").text = str(fighter.shield)
	newbuff.hint_tooltip = text

func update_buff(i):
	var pos = buffs.find(i.template_name)
	var newbuff = $Buffs.get_child(pos)
	var text = i.description
	newbuff.texture = i.icon
	buffs.push_back(i.template_name)
	if i.template.has('bonuseffect'):
		match i.template.bonuseffect:
			'barrier':
				newbuff.get_node("Label").show()
				newbuff.get_node("Label").text = str(fighter.shield)
	newbuff.hint_tooltip = text

func update_hp_label(newhp, newhpp):
	if fighter.combatgroup == 'ally' || variables.show_enemy_hp:
		$HP/hplabel.text = str(floor(newhp)) + '/' + str(floor(fighter.get_stat('hpmax')))
	else:
		$HP/hplabel.text = str(round(newhpp)) + '%%'

#highlight modes
func stop_highlight():
	$sprite.material.set_shader_param('opacity', 0.0)
	hightlight = false

func highlight_active():
	hightlight = true
	highlight_animated = true
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(0.9, 0.9, 0.25))

func highlight_hover():
	hightlight = true
	highlight_animated = false
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(0.9, 0.9, 0.25))

func highlight_target_ally():
	hightlight = true
	highlight_animated = true
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(0.0, 0.9, 0.0))

func highlight_target_ally_final():
	hightlight = true
	highlight_animated = false
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(0.0, 0.9, 0.0))

func highlight_target_enemy():
	hightlight = true
	highlight_animated = true
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(1, 0.0, 0.0))

func highlight_target_enemy_final():
	hightlight = true
	highlight_animated = false
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(1, 0.0, 0.0))

#disable-enable
func disable():
	$sprite.texture = fighter.animations.idle_1
	$sprite.rect_size = fighter.animations.idle_1.get_size()
	regenerate_click_mask()

func enable():
	$sprite.texture = fighter.animations.idle
	$sprite.rect_size = fighter.animations.idle.get_size()
	regenerate_click_mask()

func defeat():
	if fighter is hero:
		$sprite.texture = fighter.animations.dead
		$sprite.rect_size = fighter.animations.dead.get_size()
		$sprite.visible = false
		$sprite2.texture = fighter.animations.dead
		$sprite2.rect_size = fighter.animations.dead.get_size()
		$sprite2.visible = true
		regenerate_click_mask()
	else:
		set_process_input(false)
		input_handler.FadeAnimation(self, 0.5, 0.3)

func resurrect():
	$sprite.texture = fighter.animations.idle
	$sprite.rect_size = fighter.animations.idle.get_size()
	regenerate_click_mask()
	input_handler.FadeAnimation($sprite2, 0.3)
	input_handler.UnfadeAnimation($sprite, 0.3)
	
