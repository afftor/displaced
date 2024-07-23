extends TextureButton

var animation_node
var sfx_anchor
var panel_node
var panel_node2


#signal signal_RMB
#signal signal_RMB_release

var position = 0
var fighter
#var RMBpressed = false
var mouse_in_me = false
var unreachable = false

var anim_up = true
#var hightlight = false
#var highlight_animated = false
var speed = 1.33
#var damageeffectsarray = []

var hp
var ult
#var mp
onready var hp_bar = $HP

#data format: node, time, type, slot, params

#those are normal vectors to check pixels "around" given one
#8 vectors - slower, but with higher precision
var scan_vecs = [
	Vector2(0.0, -1.0), #Vector2(1.0, -1.0).normalized(),
	Vector2(1.0, 0.0), #Vector2(1.0, 1.0).normalized(),
	Vector2(0.0, 1.0), #Vector2(-1.0, 1.0).normalized(),
	Vector2(-1.0, 0.0), #Vector2(-1.0, -1.0).normalized()
]

var sprite_bottom_margin = 0.0
var displayed_buffs = {}
var no_BG_id_max = variables.BG_NO_ID_START

#func _process(delta):
#	if !hightlight or !highlight_animated: return
#	var tmp = $sprite.material.get_shader_param('opacity')
#	if anim_up:
#		tmp += delta * speed
#		if tmp >= 1.0:
#			anim_up = false
#			tmp = 1.0
#	else:
#		tmp -= delta * speed
#		if tmp <= 0.0:
#			anim_up = true
#			tmp = 0.0
#	$sprite.material.set_shader_param('opacity', tmp)


func _ready():
	sprite_bottom_margin = $sprite.margin_bottom
	$sprite.material = load("res://files/scenes/portret_shader.tres").duplicate();
	$sprite.material.set_shader_param('outline_width', 1.0)
	var sfx_anchor_class = load("res://files/scenes/combat/combat_sfx_anchor.gd")
	sfx_anchor = sfx_anchor_class.new(self)
	var overgrow = 10.0#size of a buffer around sprite for click mask
	for i in range(0,scan_vecs.size()):
		scan_vecs[i] *= overgrow
	input_handler.ClearContainer($Buffs, ['Group'])


func mouse_in_me() ->int:
	var mouse_position = get_local_mouse_position()
	#need to change texture_click_mask in order to differ DN_NONE and DN_SPRITE
#	if !$sprite.get_rect().has_point(mouse_position):
#		return variables.DN_NONE
	var bounderis = texture_click_mask.get_size() - Vector2(1.0,1.0)#get_size() same as rect_size()
	if (mouse_position.x < 0 or mouse_position.x > bounderis.x
			or mouse_position.y < 0 or mouse_position.y > bounderis.y):
		return variables.DN_NONE
	
	var mouse_in_mask :bool = false
	mouse_in_mask = texture_click_mask.get_bit(mouse_position)
	#About click mask buffer: in all honesty I don't like this solution. Contrary to my best
	#anticipations it is still takes no more then 1 ms to execute, so it seems acceptable.
	#My first idea was to modify texture_click_mask accordingly, to simplify this validation,
	#but it happened to be far more resource-intensive (around 1200 ms for each regenerate_click_mask).
	#Be advised to optimize the whole solution somehow.
	if !mouse_in_mask:
		for scan_vec in scan_vecs:
			var scan_point = mouse_position + scan_vec
			scan_point.x = clamp(scan_point.x, 0.0, bounderis.x)
			scan_point.y = clamp(scan_point.y, 0.0, bounderis.y)
			if texture_click_mask.get_bit(scan_point):
				mouse_in_mask = true
				break
	
	if !mouse_in_mask:
		return variables.DN_NONE
	return variables.DN_IN_ME

func set_animation_node(node):
	animation_node = node
	sfx_anchor.set_animation_node(node)


func setup_character(ch):
#	print("%s - %s" % [str(modulate), str(ch.position)])
	modulate = Color(1,1,1,1)
	fighter = ch
	ch.displaynode = self
	position = fighter.position
	hp = fighter.hp
	var sprite1 = $sprite
	var sprite2 = $sprite2
	panel_node.get_node('ProgressBar').max_value = fighter.get_stat('hpmax')
	panel_node.get_node('ProgressBar').value = hp
	panel_node.get_node('Label').text = fighter.get_stat('name')
	panel_node.disabled = false
	for n in panel_node.get_children():
		n.visible = true
	if fighter is hero:
		var has_ult = fighter.has_ult()
		panel_node.get_node('ProgressUlt').visible = has_ult
		panel_node2.get_node('ProgressUlt').visible = has_ult
		if has_ult:
			ult = fighter.get_ultimeter()
			panel_node.get_node('ProgressUlt').value = ult
			panel_node2.get_node('ProgressUlt').value = ult
		panel_node.get_node('TextureRect').texture = fighter.portrait()
		panel_node2.get_node('ProgressBar').max_value = fighter.get_stat('hpmax')
		panel_node2.get_node('ProgressBar').value = hp
		panel_node2.get_node('Label').text = fighter.get_stat('name')
		panel_node2.disabled = false
	else:
		panel_node2 = panel_node
		sprite1.set_script(null)
	
	input_handler.force_end_tweens(sprite1)
	input_handler.force_end_tweens(sprite2)
#	sprite1.texture = null
	if fighter.defeated:
		set_sprite_1(fighter.animations.dead_1)
		panel_node.modulate = Color(1,1,1,0.4)
		panel_node2.modulate = Color(1,1,1,0.4)
	else:
		set_sprite_1(fighter.animations.idle)
		panel_node.modulate = Color(1,1,1,1)
		panel_node2.modulate = Color(1,1,1,1)
#		reset_shield()
	sprite1.modulate.a = 1
	sprite2.modulate.a = 0
	regenerate_click_mask() # some cheating with not doing this every frame
	stop_highlight()
	set_process_input(true)
	
	if fighter.acted: disable()
	
#		connect("signal_RMB", input_handler.combat_node.gui, "ShowFighterStats")
#		connect("signal_RMB_release", input_handler.combat_node, 'HideFighterStats')
	visible = (position != null)
	
#	if fighter is hero:
#		hp_bar.hide()
#	else:
	hp_bar.show()
	hp_bar.max_value = fighter.get_stat('hpmax')
	hp_bar.value = hp
#	center_node_on_sprite(hp_bar)
	update_hp_label(fighter.hp)
	
#	center_node_on_sprite($Buffs)
	put_above($Buffs, sprite1)
	if fighter is h_rose:
		#Rose got blank area on top of her sprite, so patch is in order.
		#It may be better to fix image file itself, but for now I'll leave it as it is
		var roses_height = 285
		$Buffs.rect_position.y = (get_sprite_bottom_center().y
				- roses_height - $Buffs.rect_size.y)
	
	#names are disabled for now
#	$Label.text = fighter.name
#	center_node_on_sprite($Label)
#	put_above($Label, $Buffs)

#for now sprite is no longer changes it's center
#func center_node_on_sprite(node :Control):
#	node.rect_position.x = $sprite.rect_position.x + $sprite.rect_size.x * 0.5
#	node.rect_position.x -= node.rect_size.x * 0.5

func put_above(node_above :Control, node_under :Control):
	node_above.rect_position.y = node_under.rect_position.y
	node_above.rect_position.y -= node_above.rect_size.y

#that stuff not working for now. All shield representation made through buff-icons, decomment it in other case
#func reset_shield():
#	$sprite/shield.rect_size = $sprite.rect_min_size * 1.5
#	$sprite/shield.rect_position = - $sprite/shield.rect_size / 6.0
#	$sprite/shield.visible = (fighter.shield > 0)


func update_hp_bar_max():
	var new_max_value = fighter.get_stat('hpmax')
	panel_node.get_node('ProgressBar').max_value = new_max_value
	if fighter is hero:
		panel_node2.get_node('ProgressBar').max_value = new_max_value
	else:
		hp_bar.max_value = new_max_value

func regenerate_click_mask(spr1 = true):
	var t
	if spr1:
		t = $sprite.texture.get_data()
	else:
		t = $sprite2.texture.get_data()
#	var t = texture_normal.get_data()
	var tt = t.duplicate()
	var true_rect_size = rect_size
	if fighter.anim_scale != null:
		true_rect_size *= fighter.anim_scale
		tt.resize(true_rect_size.x, true_rect_size.y)
	tt.lock()
	var tm = Image.new()
	tm.create(true_rect_size.x, true_rect_size.y, false, 5)
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
		var args = {damage = 0, newhp = fighter.hp}
		args.damage = fighter.hp - hp
#		if args.damage < 0:
#			args.color = Color(0.8,0.2,0.2)
#			if fighter.combatgroup == 'ally':
#				args.type = 'damageally'
#			else:
#				args.type = 'damageenemy' 
#		else:
#			args.type = 'heal'
#			args.color = Color(0.2,0.8,0.2)
		hp = fighter.hp
		if hp < 0:
			args.newhp = 0
			hp = 0
		#damageeffectsarray.append(data)
		var data = {node = self, time = input_handler.combat_node.turns,type = 'hp_update',slot = 'HP', params = args}
		animation_node.add_new_data(data)

func update_ultimeter():
	if ult == null:
		ult = fighter.get_ultimeter()
	if ult == fighter.get_ultimeter():
		return
	
	ult = fighter.get_ultimeter()
	animation_node.add_new_data({
		node = self, time = input_handler.combat_node.turns,
		type = 'update_ultimeter', slot = 'ult',
		params = {new_ult = ult}})

#that stuff not working. For now all shield representation made through buff-icons
func update_shield(): 
	var args = {}
	if fighter.shield <= 0: 
		args.value = false
		#args.color = Color(0.9, 0.9, 0.9, 0.0)
		#self.material.set_shader_param('modulate', Color(0.9, 0.9, 0.9, 0.0))
		#return
	else:
		args.value = true
		#args.color = Color(0.8, 0.8, 0.8, 1.0)
		#self.material.set_shader_param('modulate', Color(0.8, 0.8, 0.8, 1.0)); #example
	var data = {node = self, time = input_handler.combat_node.turns, type = 'shield_update',slot = 'SHIELD', params = args}
	animation_node.add_new_data(data)

func process_sfx(code):
	sfx_anchor.process_sfx(code)


func process_sfx_dict(dict):
	sfx_anchor.process_sfx_dict(dict)


func process_sound(sound, type_loud = false):
	var data = {node = self, time = input_handler.combat_node.turns, type = 'sound', slot = 'sound', params = {sound = sound, type_loud = type_loud}}
	animation_node.add_new_data(data)

func rebuildbuffs():
	var data = {node = self, time = input_handler.combat_node.turns, type = 'buffs', slot = 'buffs', params = fighter.get_all_buffs()}
	animation_node.add_new_data(data)

#func process_critical():
#	var data = {node = self, time = input_handler.combat_node.turns, type = 'critical', slot = 'crit', params = {}}
#	animation_node.add_new_data(data)

func process_enable():
	animation_node.add_new_data({node = self, time = input_handler.combat_node.turns, type = 'enable', slot = 'full', params = {}})
	animation_node.add_new_data({node = self, time = input_handler.combat_node.turns, type = 'gray_out', slot = 'full', params = {undo = true}})
	if fighter is hero:
		panel_node.gray_out_undo()#animation_node creates tween, which breaks disable_panel_node()

func process_disable():
	disabled = true
	animation_node.add_new_data({node = self, time = input_handler.combat_node.turns, type = 'disable', slot = 'full', params = {}})
	animation_node.add_new_data({node = self, time = input_handler.combat_node.turns, type = 'gray_out', slot = 'full', params = {undo = false}})
	if fighter is hero:
		panel_node.gray_out()#animation_node creates tween, which breaks disable_panel_node()

func appear():#stub
	var data = {node = self, time = input_handler.combat_node.turns, type = 'reappear', slot = 'full', params = {}}
	animation_node.add_new_data(data)

func disappear():#stub
	var data = {node = self, time = input_handler.combat_node.turns, type = 'disappear', slot = 'full', params = {}}
	animation_node.add_new_data(data)


func process_defeat():
	var params = {animation = 'dead', callback = 'defeat'}
	if fighter is hero:
		params['transition_back'] = 0.0#expects "dead" anim to be oneshot AnimatedTexAutofill
	animation_node.add_new_data({
		node = self, time = input_handler.combat_node.turns,
		type = 'default_animation', slot = 'sprite2', params = params})


func process_resurrect():
	var data
	data = {node = self, time = input_handler.combat_node.turns, type = 'default_animation', slot = 'sprite2', params = {animation = null, callback = 'resurrect'}} #null animation as a stub
	animation_node.add_new_data(data)


func appear_move():
	var data 
	data = {node = self, time = input_handler.combat_node.turns, type = 'move_sprite', slot = 'full', params = {duration = 0.5, start = input_handler.combat_node.positions[position] + Vector2(OS.get_window_size().x/3, 0), finish = input_handler.combat_node.positions[position]}} 
	animation_node.add_new_data(data)


func advance_move():
	var data 
	data = {node = self, time = input_handler.combat_node.turns, type = 'move_sprite', slot = 'full', params = {duration = 0.5, start = input_handler.combat_node.positions[position + 3], finish = input_handler.combat_node.positions[position]}} 
	animation_node.add_new_data(data)


#control visuals
func noq_rebuildbuffs(newbuffs):
	for b in newbuffs:
		if displayed_buffs.has(b.template_name):
			update_buff(b)
		else:
			add_buff(b)
	for b_name in displayed_buffs.keys():
		var buff_btn = displayed_buffs[b_name]
		if !buff_btn.visible: continue#template is invisible
		if buff_btn.has_meta("just_updated"):
			buff_btn.remove_meta("just_updated")
		else:
			#remove buff
			var group_id = buff_btn.get_meta('group_id')
			get_buff_group_node(group_id).remove_buff(buff_btn)
			displayed_buffs.erase(buff_btn.name)

func add_buff(buff):
	assert(!displayed_buffs.has(buff.template_name), "%s already has buff %s" % [fighter.name, buff.template_name])
	var group_id = buff.group
	if group_id == variables.BG_NO:
		no_BG_id_max += 1
		group_id = no_BG_id_max
	var newbuff = get_buff_group_node(group_id).make_buff()
	newbuff.name = buff.template_name
	newbuff.set_meta("group_id", group_id)
	displayed_buffs[buff.template_name] = newbuff
	update_buff(buff)

func get_buff_group_node(group_id):
	for group_node in $Buffs.get_children():
		if !group_node.visible: continue
		if group_node.get_meta('group_id') == group_id:
			return group_node
	
	var group_node = input_handler.DuplicateContainerTemplate($Buffs, 'Group')
	group_node.set_meta("group_id", group_id)
	return group_node

func update_buff(buff):
	var buff_btn = displayed_buffs[buff.template_name]
	buff_btn.set_meta("just_updated", true)
	buff_btn.hint_tooltip = buff.description
	buff_btn.texture = buff.icon
	if buff.template.has('bonuseffect'):
		var label_text = ""
		var label_color = ""
		match buff.template.bonuseffect:
#			'barrier':
#				label_text = str(fighter.shield)
#				label_color = variables.hexcolordict.gray
			'arg':
				assert(buff.template.has('bonusarg'), "buff with bonuseffect == arg has no bonusarg")
				label_text = str(buff.get_calc_arg(buff.template.bonusarg))
				label_color = variables.hexcolordict.pink
			'duration':
				if buff.get_duration() != null:
					label_text = str(buff.get_duration())
					label_color = variables.hexcolordict.k_green
			'amount':
				if buff.amount > 1:
					label_text = str(buff.amount)
					label_color = variables.hexcolordict.magenta
		var label = buff_btn.get_node("Label")
		if !label_text.empty():
			label.show()
			label.text = label_text
			label.set("custom_colors/font_color", label_color)
		else:
			label.hide()

func update_hp_label(newhp): 
	var new_text = str(floor(newhp)) + '/' + str(floor(fighter.get_stat('hpmax')))
	panel_node.get_node('hp').text = new_text
	panel_node2.get_node('hp').text = new_text
	if hp_bar.visible:
		hp_bar.get_node('Label').text = new_text
#	panel_node.get_node('ProgressBar').value = newhp

#highlight modes
func stop_highlight():
	$sprite.material.set_shader_param('opacity', 0.0)
	unmark_unreachable()
#	hightlight = false

func highlight_active():
#	hightlight = true
#	highlight_animated = true
	$sprite.material.set_shader_param('outline_width', 2.0)
	$sprite.material.set_shader_param('opacity', 0.9)
	$sprite.material.set_shader_param('outline_color', Color(1, 1, 0.35))

#seems not in use, while T_OVERATTACKALLY is not in use
#func highlight_hover():
##	hightlight = true
##	highlight_animated = false
#	$sprite.material.set_shader_param('opacity', 0.8)
#	$sprite.material.set_shader_param('outline_color', Color(0.9, 0.9, 0.25))

func highlight_target_ally():
#	hightlight = true
#	highlight_animated = true
	$sprite.material.set_shader_param('outline_width', 2.0)
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(0.0, 0.9, 0.0))

#got old
#func highlight_target_ally_final():
##	hightlight = true
##	highlight_animated = false
##	$sprite.material.set_shader_param('opacity', 0.8)
##	$sprite.material.set_shader_param('outline_color', Color(0.0, 0.9, 0.0))
#	#without animation they are same at the moment
#	highlight_target_ally()

func highlight_target_enemy():
#	hightlight = true
#	highlight_animated = true
	$sprite.material.set_shader_param('outline_width', 2.0)
	$sprite.material.set_shader_param('opacity', 0.8)
	$sprite.material.set_shader_param('outline_color', Color(1, 0.0, 0.0))

#got old
#func highlight_target_enemy_final():
##	hightlight = true
##	highlight_animated = false
##	$sprite.material.set_shader_param('opacity', 0.8)
##	$sprite.material.set_shader_param('outline_color', Color(1, 0.0, 0.0))
#	#without animation they are same at the moment
#	highlight_target_enemy()

#disable-enable temporaly switched off. As they seems only have been attuning sprites, it is no longer needed with new set_sprite() logic
#but, as I am not sure if this truly was there only function, I am leaving legecy code for a while
#Consider to bring it back, if something would crush
func disable():
	pass
#	if fighter.defeated: 
#		return
#	var tmp = $sprite.margin_bottom
##	var tmp2 = $sprite.rect_size.x
#	$sprite.texture = fighter.animations.idle
#	$sprite.rect_min_size = fighter.animations.idle_1.get_size()
#	yield(get_tree(), "idle_frame")
#
#	$sprite.rect_size = $sprite.rect_min_size
#	$sprite.rect_position.y -= $sprite.margin_bottom - tmp
##	if $sprite.rect_size.x < tmp2:
##		$sprite.rect_position.x -= ($sprite.rect_size.x - tmp2) / 2
#	regenerate_click_mask()


func enable():
	pass
#	if fighter.defeated: 
#		return
#	var tmp = $sprite.margin_bottom
##	var tmp2 = $sprite.rect_size.x
#	$sprite.texture = fighter.animations.idle
#	$sprite.rect_min_size = fighter.animations.idle.get_size()
#	$sprite2.rect_min_size = fighter.animations.idle.get_size()
#	yield(get_tree(), "idle_frame")
#	$sprite.rect_size = $sprite.rect_min_size
#	$sprite.rect_position.y -= $sprite.margin_bottom - tmp
#	$sprite2.rect_size = $sprite2.rect_min_size
#	$sprite2.rect_position.y -= $sprite2.margin_bottom - tmp
##	if $sprite.rect_size.x < tmp2:
##		$sprite.rect_position.x -= ($sprite.rect_size.x - tmp2) / 2
#	regenerate_click_mask()

func mark_unreachable():
	unreachable = true
	modulate = Color(0.4, 0.4, 0.4, 1)

func unmark_unreachable():
	if unreachable:
		unreachable = false
		modulate = Color(1, 1, 1, 1)

#obsolete or semi-obsolete
func defeat():
#	print("!")
	if fighter is hero:
		set_sprite_1(fighter.animations.dead_1)
		regenerate_click_mask()
		panel_node.modulate = Color(1,1,1,0.4)
		panel_node2.modulate = Color(1,1,1,0.4)
	else:
		set_process_input(false) #it is probably unnecessary since this script started to use _gui_input()
#		input_handler.FadeAnimation(self, 0.5, 0.3)
		input_handler.combat_node.disable_enemy_panel(fighter.position, fighter.id)
		input_handler.combat_node.remove_enemy(fighter.position, fighter.id)
		fighter.displaynode = null
		visible = false

func resurrect():
	set_sprite_1(fighter.animations.idle)
	regenerate_click_mask()
#	input_handler.FadeAnimation($sprite2, 0.3)
#	input_handler.UnfadeAnimation($sprite, 0.3)
	panel_node.modulate = Color(1,1,1,1)
	panel_node2.modulate = Color(1,1,1,1)

func get_sprite_bottom_center() ->Vector2:
	return Vector2(rect_size.x*0.5, rect_size.y + sprite_bottom_margin)

func get_global_sprite_top_center() ->Vector2:
	var sprite = $sprite
	return Vector2(sprite.rect_global_position.x - sprite.rect_size.x * 0.5,
		sprite.rect_global_position.y)


func ret_hp_bar() ->Node:
	return hp_bar

func set_sprite(new_tex :Texture, sprite :TextureRect):
	var bottom_center = get_sprite_bottom_center()
	sprite.texture = new_tex
	if new_tex != null :
		var new_size = new_tex.get_size()
		if fighter.anim_scale != null:
			new_size *= fighter.anim_scale
		sprite.rect_position.x = bottom_center.x - new_size.x * 0.5
		sprite.rect_position.y = bottom_center.y - new_size.y
		sprite.rect_min_size = new_size
		sprite.rect_size = new_size

func set_sprite_2(new_tex :Texture):
	set_sprite(new_tex, $sprite2)

func set_sprite_1(new_tex :Texture):
	set_sprite(new_tex, $sprite)

func get_HPbar_clone() ->Node:
	var hp_bar_clone = hp_bar.duplicate()
	hp_bar_clone.rect_position = hp_bar.rect_global_position
	return hp_bar_clone
