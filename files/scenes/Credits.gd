extends Control

onready var text_node = $Text
onready var close_btn = $close
var test_start_y :float
const text_speed = 50
const bg_speed = 10
const bg_switch_time = 1
const char_switch_time = 2
const char_time = 5
var credits_text = ""
onready var bgs = [
	$ColorRect/bg_1,
	$ColorRect/bg_2
]
onready var chars = [
	$chars/char_1,
	$chars/char_2
]
var bg_routes = [
	{
		start = Vector2(0,-72),
		finish = Vector2(-280,-72),
		normal = Vector2(-1,0)
	},{
		start = Vector2(-280,-72),
		finish = Vector2(0,-72),
		normal = Vector2(1,0)
	},{
		start = Vector2(-136,0),
		finish = Vector2(-136,-152),
		normal = Vector2(0,-1)
	},{
		start = Vector2(-136,-152),
		finish = Vector2(-136,0),
		normal = Vector2(0,1)
	}
]
var bg_texs_raw = ['castle', 'castleroom', 'cave', 'desert', 'forest', 'forge',
	'hall', 'market', 'villageday', 'villagenight', 'annet_quarters', 'cult',
	'cult1', 'dungeon_dwarf', 'forest_fairy', 'mountainsday', 'town_in',
	'town_night']
var bg_texs = []
var char_texs_raw = ['arron', 'dimitrius_hand', 'emberhappy', 'erika', 'flak',
	'goblin', 'rose', 'annet', 'caliban', 'faeryqueen', 'iola', 'kingdwarf1',
	'rilu', 'traveller', 'victor', 'zelroth']
var char_texs = []
var texs_ready = false
var cur_bg_texs = []
var cur_char_texs = []
var cur_bg_num = 0
var cur_char_num = 1
var old_char_num = 0
var cur_route_num = 0
var char_timer = 0

func _ready():
	close_btn.connect("pressed", self, "hide")
	test_start_y = text_node.rect_position.y
	set_process(false)

func show_credits() -> void:
	for bg in bgs:
		bg.modulate.a = 0.0
	cur_char_num = 0
	old_char_num = 1
	chars[cur_char_num].modulate.a = 1.0
	chars[cur_char_num].texture = null
	char_timer = 0
	chars[old_char_num].modulate.a = 0.0
	text_node.rect_position.y = test_start_y
	show()
	
	if credits_text.empty():
		read_credits_text()
	if !texs_ready:
		for tex in bg_texs_raw:
			resources.preload_res("bg/%s" % tex)
		for tex in char_texs_raw:
			resources.preload_res("sprite/%s" % tex)
		if resources.is_busy(): yield(resources, "done_work")
		for tex in bg_texs_raw:
			if resources.has_res("bg/%s" % tex):
				bg_texs.append(tex)
		for tex in char_texs_raw:
			if resources.has_res("sprite/%s" % tex):
				char_texs.append(tex)
		texs_ready = true
	
	cur_bg_texs.clear()
	cur_char_texs.clear()
	text_node.bbcode_text = credits_text
	next_bg()
	set_process(true)

func show_end_credits() -> void:
	close_btn.disconnect("pressed", self, "hide")
	close_btn.connect("pressed", self, "end_hide")
	show_credits()

func end_hide() -> void:
	globals.CurrentScene.queue_free()
	globals.ChangeScene('menu')
	queue_free()

func _process(delta):
	#text
	text_node.rect_position.y -= delta * text_speed
	if text_node.get_rect().end.y < 0:
		set_process(false)
		close_btn.emit_signal("pressed")
	
	#bg
	var cur_bg = bgs[cur_bg_num]
	var route = bg_routes[cur_route_num]
	if cur_bg.modulate.a < 1.0:
		cur_bg.modulate.a += delta/bg_switch_time
		if cur_bg.modulate.a > 1.0:
			cur_bg.modulate.a = 1.0
	var step_vec = route.normal * delta * bg_speed
	if (route.finish - cur_bg.rect_position).length_squared() > step_vec.length_squared():
		cur_bg.rect_position += step_vec
	else:
		cur_bg.rect_position = route.finish
		next_bg()
	
	#chars
	var cur_char = chars[cur_char_num]
	var old_char = chars[old_char_num]
	var modulate_step = delta/char_switch_time
	if old_char.modulate.a > 0.0:
		old_char.modulate.a -= modulate_step
		if old_char.modulate.a < 0.0:
			old_char.modulate.a = 0.0
	if cur_char.modulate.a < 1.0:
		cur_char.modulate.a += modulate_step
		if cur_char.modulate.a > 1.0:
			cur_char.modulate.a = 1.0
	else:
		char_timer += delta
		if char_timer > char_time:
			char_timer = 0
			next_char()

func read_credits_text():
	var file = File.new()
	var content = []
	file.open("res://localization/credits/%s.csv" % TranslationServer.get_locale(), File.READ)
	while file.get_position() < file.get_len():
		content.append(file.get_line().split(","))
	file.close()
	
	credits_text = "[center]"
	for line in content:
		credits_text += "%s\n%s\n\n\n\n" % [line[0], line[1]]
	credits_text += "[/center]"

func next_bg():
	if cur_bg_num == 0:
		cur_bg_num = 1
	else:
		cur_bg_num = 0
	var cur_bg = bgs[cur_bg_num]
	if cur_bg_texs.empty():
		cur_bg_texs = bg_texs.duplicate()
	var next_tex_num = randi() % cur_bg_texs.size()
	cur_bg.texture = resources.get_res("bg/%s" % cur_bg_texs[next_tex_num])
	cur_bg_texs.remove(next_tex_num)
	cur_route_num = randi() % bg_routes.size()
	var route = bg_routes[cur_route_num]
	cur_bg.rect_position = route.start
	cur_bg.modulate.a = 0.0
	cur_bg.raise()

func next_char():
	var temp = cur_char_num
	cur_char_num = old_char_num
	old_char_num = temp
	if cur_char_texs.empty():
		cur_char_texs = char_texs.duplicate()
	var cur_char = chars[cur_char_num]
	var next_tex_num = randi() % cur_char_texs.size()
	cur_char.texture = resources.get_res("sprite/%s" % cur_char_texs[next_tex_num])
	cur_char_texs.remove(next_tex_num)
