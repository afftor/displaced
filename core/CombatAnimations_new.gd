extends Node

signal pass_next_animation
signal cast_finished
signal predamage_finished
signal postdamage_finished
signal alleffectsfinished

var cast_timer = 0
var aftereffecttimer = 0
var postdamagetimer = 0
var aftereffectdelay = 0.1


var cur_timer
var animations_queue = {}
#format: time - node - animations (data)
#data format: time, node, slot, type, params

#delays for playing animations in zones
var hp_update_delays = {}
var hp_float_delays = {}
var buffs_update_delays = {}
var log_update_delay = 0

#main timer
var animation_delays = {}

var is_busy = false

var miss_sound = "sound/dodge"

func _ready() -> void:
	resources.preload_res(miss_sound)


func _process(delta):
	for node in animation_delays:
		animation_delays[node] -= delta
		if animation_delays[node] <= 0:
			finish_animation(node)


func force_end():
	animation_delays.clear()
	animations_queue.clear()
	hp_update_delays.clear()
	buffs_update_delays.clear()
	log_update_delay = 0
	is_busy = false


func can_add_data(data):
	if animations_queue[data.time][data.node].empty(): return false
	var l_anim = animations_queue[data.time][data.node].back()
	for tdata in l_anim:
		if tdata.slot == data.slot: return false
	return true

func add_new_data(data):
	if !animations_queue.has(data.time): 
		animations_queue[data.time] = {}
	if !animations_queue[data.time].has(data.node): 
		animations_queue[data.time][data.node] = []
	if can_add_data(data): 
		animations_queue[data.time][data.node].back().push_back(data)
	else:
		animations_queue[data.time][data.node].push_back([])
		animations_queue[data.time][data.node].back().push_back(data)
#	print(animations_queue)

func check_start():
	if is_busy: 
		return
	if animations_queue.empty(): return
	is_busy = true
	advance_timer()

func advance_timer():
#	print(str(OS.get_ticks_msec()) + " timer adv")
	hp_update_delays.clear()
	if animations_queue.empty(): return
	cur_timer = animations_queue.keys().min()
	#print (cur_timer)
	for node in animations_queue[cur_timer]:
		start_animation(node)

func finish_animation(node):
#	print(str(OS.get_ticks_msec()) + " finish anim for " + str(node))
	animation_delays.erase(node)
	animations_queue[cur_timer][node].pop_front()
	if animations_queue[cur_timer][node].empty(): 
		animations_queue[cur_timer].erase(node)
		if animations_queue[cur_timer].empty():
			animations_queue.erase(cur_timer)
			if animations_queue.empty():
				is_busy = false
				emit_signal("alleffectsfinished")
			else: 
				advance_timer()
	else: 
		start_animation(node)

func start_animation(node):
#	print(str(OS.get_ticks_msec()) + " start anim for " + str(node))
	var f_anim = animations_queue[cur_timer][node].front()
	var delay = 0
	for data in f_anim:
		#print("%d - %d %s"%[OS.get_ticks_msec(),cur_timer, data.type])
		delay = max(delay, call(data.type, data.node, data.params))
#	print(delay)
#	print(str(OS.get_ticks_msec()) + " starting anim")
	animation_delays[node] = delay

#not used 
func nextanimation():
	#print("next_animation")
	emit_signal("pass_next_animation")

func cast_finished():
	#print("cast_finished")
	emit_signal("cast_finished")

func predamage_finished():
	#print("predamage_finished")
	emit_signal("predamage_finished")
	input_handler.tween_callback(self, 'allanimationsfinished', 1)

func postdamage_finished():
	#print("postdamage_finished")
	emit_signal("postdamage_finished")
	input_handler.tween_callback(self, 'allanimationsfinished', 1)

func allanimationsfinished():
	#print("allanims_finished")
	emit_signal("alleffectsfinished")

# ALL FUNCTIONS BELOW ARE SETUPPING ANIMATIONS AND THOUGH MUST RETURN THEIR ESTIMATING 'LOCK' TIME  
func sound(node, args):
	# need to preload somehow
	var type_loud = false
	if args.has("type_loud"):
		type_loud = args.type_loud
	input_handler.PlaySound(args.sound, 0, type_loud)
	return 0.1

func default_animation(node, args):
#	print("anim %s %s" % [node.name, args.animation])
	var id = args.animation
	var time_id = id
	if args.has('subtype'):
		time_id = "%s_%s" % [id, args.subtype]
	var playtime
	var trans_forth_time = variables.default_animations_transition[time_id]
	var trans_back_time = trans_forth_time
	if args.has('transition_forth'):#not in use for now, but should come handy
		trans_forth_time = args.transition_forth
	if args.has('transition_back'):
		trans_back_time = args.transition_back
	var delaytime = variables.default_animations_delay[time_id]
	var delayafter = variables.default_animations_after_delay[time_id]
	var tex = null
	if node.fighter.animations.has(id):
		tex = node.fighter.animations[id]
	var sp = node.get_node('sprite')
	var sp2 = node.get_node('sprite2')
	node.set_sprite_2(tex)
	sp2.visible = true
	#playtime - is time from start of transition to sp2, til end of transition
	#back to sp, that's why trans_back_time must be subtracted in back_delay
	#and that's why it should't for oneshot AnimatedTexAutofill (like "dead"),
	#in order to see full animation
	#UPDATE: not quite relevant since trans_back_time could be 0, but still right thing to do
	if tex is AnimatedTexAutofill:
		playtime = tex.frames / tex.fps
		if tex.oneshot:
			tex.current_frame = 0
			playtime += trans_back_time
	else:
		playtime = variables.default_animations_duration[time_id]
	var back_delay = max(playtime + delaytime - trans_back_time, 0)
	#------old variant (bug of Tween node is mostly severe here)
	#UPDATE: bug of Tween node is seems to be evaded
	input_handler.force_end_tweens(sp)
	input_handler.force_end_tweens(sp2)
	input_handler.FadeAnimation(sp, trans_forth_time, delaytime)
	input_handler.UnfadeAnimation(sp2, trans_forth_time, delaytime)
	input_handler.FadeAnimation(sp2, trans_back_time, back_delay, true)
	input_handler.UnfadeAnimation(sp, trans_back_time, back_delay, true)
	#------new variant
#	#force_end_tweens
#	if node.has_meta("tween") and node.get_meta("tween").is_valid():
#		node.get_meta("tween").kill()
#	#new tweens
#	var tween = node.create_tween()
#	tween.set_trans(Tween.TRANS_LINEAR)
#	tween.set_ease(Tween.EASE_IN_OUT)
#	node.set_meta("tween", tween)
#	#FadeAnimation/UnfadeAnimation
#	var tweener = tween.tween_property(sp, 'modulate', Color(1,1,1,0), trans_forth_time)
#	tweener.from(Color(1,1,1,1))
#	tweener.set_delay(delaytime)
#	tweener = tween.parallel().tween_property(sp2, 'modulate', Color(1,1,1,1), trans_forth_time)
#	tweener.from(Color(1,1,1,0))
#	tweener.set_delay(delaytime)
#	tweener = tween.tween_property(sp2, 'modulate', Color(1,1,1,0), trans_back_time)
#	tweener.from(Color(1,1,1,1))
#	tweener.set_delay(back_delay)
#	tweener = tween.parallel().tween_property(sp, 'modulate', Color(1,1,1,1), trans_back_time)
#	tweener.from(Color(1,1,1,0))
#	tweener.set_delay(back_delay)
	#---------
	if args.has('callback'):
		input_handler.tween_callback(node, args.callback, back_delay)
	return playtime + delaytime + delayafter


func default_sfx(node, args):
#	print("sfx %s %s" % [node.name, args.animation])
	var id = args.animation
	var playtime = 0.07 # 0.7
	hp_update_delays[node] = 0 # 0.3 both
	hp_float_delays[node] = 0
	log_update_delay = max(log_update_delay, 0.3)
	buffs_update_delays[node] = 0
	if args.has('flip_h'):
		if args.has('flip_v'):
			input_handler.call_deferred('gfx_sprite', node, id, 0.5, null, args.flip_h, args.flip_v)
		else:
			input_handler.call_deferred('gfx_sprite', node, id, 0.5, null, args.flip_h)
	elif args.has('flip_v'):
		input_handler.call_deferred('gfx_sprite', node, id, 0.5, null, false, args.flip_v)
	else:
		input_handler.call_deferred('gfx_sprite', node, id, 0.5, null)
	return playtime + aftereffectdelay


func shake(node, args):
	var playtime = 0.5
	var magnitude = 5
	if args.has('time'):
		playtime = args.time
	if args.has('magnitude'):
		magnitude = args.magnitude
	input_handler.ShakeAnimation(node, playtime, magnitude)
	return playtime + aftereffectdelay

func casterattack(node, args = null):#obsolete
	var playtime = 0
	var delaytime = 0
	var effectdelay = 0
	var nextanimationtime = 0
	
	input_handler.tween_property(node, 'rect_position', node.get_position(), node.get_position() + node.get_attack_vector(), playtime, delaytime)
	input_handler.tween_property(node, 'rect_position', node.get_position() + node.get_attack_vector(), node.get_position(), playtime, playtime)
	
	return effectdelay
	
	#tween.interpolate_callback(input_handler, 0,'PlaySound',"slash")
	
#	tween.interpolate_callback(self, nextanimationtime, 'nextanimation')
#
#	cast_timer = effectdelay

#seems to be fully replaced by default_sfx() with id 'hit'
#func targetattack(node, args = null):
#	var tween = input_handler.GetTweenNode(node)
#	var nextanimationtime = 0
#	hp_update_delays[node] = 0 #delay for hp updating during this animation
#	hp_float_delays[node] = 0 #delay for hp updating during this animation
#	log_update_delay = max(log_update_delay, 0)
#	buffs_update_delays[node] = 0
##	input_handler.gfx_sprite(node, 'slash', 0, 0.1) #strike
#	input_handler.gfx_sprite(node, 'hit', 0, 0.1)
#	tween.start()
#
#	return nextanimationtime + aftereffectdelay

#func firebolt(node, args = null):
#	var tween = input_handler.GetTweenNode(node)
#	var nextanimationtime = 0.2
#	hp_update_delays[node] = 0.3 #delay for hp updating during this animation
#	hp_float_delays[node] = 0.3 #delay for hp updating during this animation
#	log_update_delay = max(log_update_delay, 0.3)
#	buffs_update_delays[node] = 0.2
#	input_handler.gfx_sprite(node, 'firebolt', 0.3, 0.4)
#	tween.start()
#
#	return nextanimationtime + aftereffectdelay
#
#func flame(node, args = null):
#	var tween = input_handler.GetTweenNode(node)
#	var nextanimationtime = 0.4
#	hp_update_delays[node] = 0.3 #delay for hp updating during this animation
#	hp_float_delays[node] = 0.3 #delay for hp updating during this animation
#	log_update_delay = max(log_update_delay, 0.3)
#	buffs_update_delays[node] = 0.4
#	input_handler.gfx_sprite(node, 'flame', 0.3, 0.5)
#	tween.start()
#
#	return nextanimationtime + aftereffectdelay
#
#func earth_spike(node, args = null):
#	var tween = input_handler.GetTweenNode(node)
#	var nextanimationtime = 0.8
#	hp_update_delays[node] = 0.5 #delay for hp updating during this animation
#	hp_float_delays[node] = 0.5 #delay for hp updating during this animation
#	log_update_delay = max(log_update_delay, 0.5)
#	buffs_update_delays[node] = 0.5
#	input_handler.gfx_sprite(node, 'earth_spike', 0.7, 1)
#	#tween.interpolate_callback(self, nextanimationtime, 'nextanimation')
#	tween.start()
#
#	return nextanimationtime + aftereffectdelay
#	#aftereffecttimer = nextanimationtime + aftereffectdelay

#there is no 'gfx/fire'!
#func targetfire(node, args = null):
#	var nextanimationtime = 0
#	hp_update_delays[node] = 0 #delay for hp updating during this animation
#	hp_float_delays[node] = 0 #delay for hp updating during this animation
#	log_update_delay = max(log_update_delay, 0.1)
#	buffs_update_delays[node] = 0.2
#	input_handler.gfx(node, 'gfx/fire')
##	var tween = input_handler.GetTweenNode(node)
#	#tween.interpolate_callback(self, nextanimationtime, 'nextanimation')
##	tween.start()

	return nextanimationtime + aftereffectdelay
	#postdamagetimer = nextanimationtime + aftereffectdelay

#func heal(node, args = null):
#	var tween = input_handler.GetTweenNode(node)
#	var nextanimationtime = 0.5
#	hp_update_delays[node] = 0 #delay for hp updating during this animation
#	hp_float_delays[node] = 0 #delay for hp updating during this animation
#	log_update_delay = max(log_update_delay, 0)
#	buffs_update_delays[node] = 0.5
#	input_handler.gfx_particles(node, 'heal', 1, 1)
#	tween.start()
#
#	return nextanimationtime + aftereffectdelay

func miss(node, args = null):#conflicting usage of tween node!!
	var playtime = 0.1
	var nextanimationtime = 0.0
	var delaytime = 0.4
	var starting_modulate = node.modulate
	input_handler.PlaySound(miss_sound)
	input_handler.FloatText(node, tr("MISS"), 'miss', 75, Color(1,1,1), 1, 0.2)#, node.get_node('Icon').rect_size/2-Vector2(80,20))
	input_handler.tween_property(node, 'modulate', starting_modulate, Color(1,1,0), playtime)
	input_handler.tween_property(node, 'modulate', Color(1,1,0), starting_modulate, playtime, delaytime)
	
	return playtime * 2 + delaytime
	#aftereffecttimer = nextanimationtime + aftereffectdelay

func buffs(node, args):
	var delay = 0
	if buffs_update_delays.has(node): delay = buffs_update_delays[node]
	buffs_update_delays.erase(node)
	var delaytime = 0.01
	input_handler.tween_callback(node, 'noq_rebuildbuffs', delay, [args])
	return delaytime + delay

func c_log(node, args):
	var delay = log_update_delay
	log_update_delay = 0
	var delaytime = 0.01
	input_handler.tween_callback(node, 'combatlogadd_q', delay, [args.text])
	return delaytime + delay

#func critical(node, args = null):
#	var delay = 0.01
#	if !crit_display.has(node):
#		crit_display.push_back(node)
#	return delay

func hp_update(node, args):
#	print("hp")
	var delay = 0
	if hp_update_delays.has(node): delay = hp_update_delays[node]
	hp_update_delays.erase(node)
	
	var delaytime = 0.1
	var tween = input_handler.GetTweenNode(node)
	var hpnode = node.panel_node.get_node("ProgressBar")
	var hpnode2 = node.panel_node2.get_node("ProgressBar")
	var hpnode_field = node.ret_hp_bar()
	#float damage
#	if args.damage_float:
#		if crit_display.has(node):
#			args.color = Color(1,0.8,0)
#			crit_display.erase(node)
#			tween.interpolate_callback(input_handler, delay, 'FloatTextArgs', {node = node, text = str(ceil(args.damage)) + '!', type = args.type, size = 120, color = args.color, time = 1, fadetime = 0.5, offset = Vector2(0,0)})
#		else: 
#			tween.interpolate_callback(input_handler, delay, 'FloatTextArgs', {node = node, text = str(ceil(args.damage)), type = args.type, size = 80, color = args.color, time = 1, fadetime = 0.5, offset = Vector2(0,0)})
	#input_handler.FloatText(node, str(args.damage), args.type, 150, args.color, 2, 0.2, Vector2(node.get_node('Icon').rect_position.x+25, node.get_node("Icon").rect_position.y+100))
	#update hp bar
	if hpnode_field.visible:
		input_handler.tween_property(hpnode_field, 'value', hpnode_field.value, args.newhp, 0.3, delay)
	if !hpnode2.is_visible_in_tree():
		input_handler.tween_property_with(tween, hpnode, 'value', hpnode.value, args.newhp, 0.3, delay)
		hpnode2.value = args.newhp
	else:
		input_handler.tween_property_with(tween, hpnode2, 'value', hpnode2.value, args.newhp, 0.3, delay)
		if hpnode != hpnode2:
			hpnode.value = args.newhp
	#update hp label
	input_handler.tween_callback_with(tween, node, 'update_hp_label', delay, [args.newhp])
	return delaytime + delay

func update_ultimeter(node, args):
	var delay = 0#not sure, if it's needed
	
	var tween = input_handler.GetTweenNode(node)
	var ult_node = node.panel_node.get_node("ProgressUlt")
	var ult_node2 = node.panel_node2.get_node("ProgressUlt")
	#remake it when inbattle bar for heroes will be added
#	var hpnode_field = node.ret_hp_bar()
#	if hpnode_field.visible:
#		input_handler.tween_property(hpnode_field, 'value', hpnode_field.value, args.newhp, 0.3, delay)
	if !ult_node2.is_visible_in_tree():
		input_handler.tween_property_with(tween, ult_node, 'value', ult_node.value, args.new_ult, 0.3, delay)
		ult_node2.value = args.new_ult
	else:
		input_handler.tween_property_with(tween, ult_node2, 'value', ult_node2.value, args.new_ult, 0.3, delay)
		if ult_node != ult_node2:
			ult_node.value = args.new_ult
	#if label will be needed
#	input_handler.tween_callback_with(tween, node, 'update_ultimeter_label', delay, [args.new_ult])
	return 0.1 + delay


func damage_float(node, args):
#	print("dmg float")
	var delay = 0
	if hp_float_delays.has(node): delay = hp_float_delays[node]
	hp_float_delays.erase(node)
	
	var delaytime = 0.1
	var tween = input_handler.GetTweenNode(node)
	input_handler.tween_callback_with(tween, input_handler, 'FloatDmgArgs', delay, [{node = node, args = args, time = 1, fadetime = 0.7, offset = Vector2(0,0)}])
	return delaytime + delay


func heal_float(node, args):
	var delay = 0
	if hp_float_delays.has(node): delay = hp_float_delays[node]
	hp_float_delays.erase(node)
	
	var delaytime = 0.1
	var tween = input_handler.GetTweenNode(node)
	if args.heal != 0:
		input_handler.tween_callback_with(tween, input_handler, 'FloatHealArgs', delay, [{node = node, args = args, time = 1, fadetime = 0.5, offset = Vector2(0,0)}])
	return delaytime + delay


func test_combat_start(node, args):
	return 1.0

#that stuff not working. For now all shield representation made through buff-icons
func shield_update(node, args):
#	node.material.set_shader_param('modulate', args.color)
#	node.get_node('sprite/shield').visible = args.value # works and looks wierd so I disabled it for now
	return 0.1

func defeat(node, args = null):#stub, for this was not correct in FighterNode
#	node.get_node('Icon').material = load("res://assets/sfx/bw_shader.tres")
#	input_handler.FadeAnimation(node, 0.5, 0.3)
	node.defeat()
	return 0.1

func disable(node, args = null):
#	node.get_node('Icon').material = load("res://assets/sfx/bw_shader.tres")
	node.disable()
	return 0.1

func enable(node, args = null):
#	if node.get_node('Icon').material != null: node.get_node('Icon').material = null
#	node.disabled = false
	node.enable()
	return 0.1

func disappear(node, args = null):
	var delay = 0.5
	input_handler.FadeAnimation(node, delay)
	return delay

func reappear(node, args = null):
	var delay = 0.5
	input_handler.UnfadeAnimation(node, delay)
	return delay

func death_animation(node):
	var playtime = 0.1
	var nextanimationtime = 0.0
	var delaytime = 0.8
	
	input_handler.FadeAnimation(node, 1, 0.5)
	return delaytime


func move_sprite(node, args):
	var playtime = args.duration
	node.rect_global_position = args.start
	input_handler.tween_property(node, 'rect_global_position', args.start, args.finish, playtime, 0, Tween.TRANS_EXPO)
	node.visible = true
	return playtime

func gray_out(node, args = null):
	var delay = 0.5
	if args.undo:
		input_handler.tween_property(node, 'modulate', node.modulate, Color(1, 1, 1, 1), 0.12)
	else:
		input_handler.tween_property(node, 'modulate', node.modulate, Color(0.6, 0.6, 0.6, 1), 0.12)
	return delay
