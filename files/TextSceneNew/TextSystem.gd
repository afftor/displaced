extends Control

signal scene_end

const REF_PATH = [
	"res://assets/data/txt_ref/scn/chardef.txt",
	"res://assets/data/txt_ref/scn/intro.txt",
	"res://assets/data/txt_ref/scn/forest.txt",
	"res://assets/data/txt_ref/scn/ember_1.txt",
	"res://assets/data/txt_ref/scn/rose.txt",
	"res://assets/data/txt_ref/scn/dimitrius_1.txt",
	"res://assets/data/txt_ref/scn/iola_1.txt",
	"res://assets/data/txt_ref/scn/erika.txt",
	"res://assets/data/txt_ref/scn/erika_rose.txt",
	"res://assets/data/txt_ref/scn/aeros.txt",
	"res://assets/data/txt_ref/scn/rilu_1.txt",
	"res://assets/data/txt_ref/scn/faery_queen.txt",
	"res://assets/data/txt_ref/scn/victor_1.txt",
	"res://assets/data/txt_ref/scn/erika_annet.txt",
	"res://assets/data/txt_ref/scn/rilu_2.txt",
	"res://assets/data/txt_ref/scn/iola_2.txt",
	"res://assets/data/txt_ref/scn/ember_2.txt",
	"res://assets/data/txt_ref/scn/victor_2.txt",
	"res://assets/data/txt_ref/scn/iola_3.txt",
	"res://assets/data/txt_ref/scn/city_raid.txt",
	"res://assets/data/txt_ref/scn/annet.txt",
	"res://assets/data/txt_ref/scn/dimitrius_2.txt",
	"res://assets/data/txt_ref/scn/zelroth.txt",
	"res://assets/data/txt_ref/scn/future_city.txt",
	"res://assets/data/txt_ref/scn/dimitrius_ending.txt",
	]

const AVAIL_EFFECTS = [
	"WHITE", "SPRITE_HIDE",
	"MUSIC_STOP", "GUI_NORMAL",
	"GUI_HIDE", "GUI_FULL",
	"BLACKON", "BLACKOFF",
	"BLACKFADE", "BLACKUNFADE",
	"BLACKTRANS", "BG", "DELAY",
	"SPRITE", "SPRITE_FADE",
	"SPRITE_UNFADE", "SHAKE_SPRITE",
	"SHAKE_SCREEN", "SOUND", "MUSIC",
	"ABG", "STOP", "CHOICE", "SKIP",
	"DECISION", "STATE", "LOOSE"
	]

const animated_sprites = ['arron', 'rose', 'annet', 'erika', 'erika_n', 'iola', 'emberhappy', 'embershock', 'caliban', 'dragon', 'kingdwarf', 'victor', 'zelroth', 'rilu', 'demitrius', 'demitrius_alter']
#demitrius sprites are from 'unused folder' - so don't remove them accidentally
#others sprites are not used (or i did not textfind them in scenes for some reasons - write me if they are there)


onready var TextField = $Panel/DisplayText
onready var ImageSprite = $CharImage
var ShownCharacters = 0.0

var ref_src = PoolStringArray()

var current_scene = ""
var scene_map = {}
var line_nr = 0
var line_dr = ""

var scenes_map = {}
var char_map = {}

var char_max = 0

var skip = false
var delay = 0
var receive_input = false

var is_video_bg = false
var decisions = PoolStringArray()
var last_choice = -1

var replay_mode = false

func _ready() -> void:
	set_process(false)
	set_process_input(false)
	var f = File.new()
	for i in REF_PATH:
		f.open(i, File.READ)
		ref_src.append_array(f.get_as_text().split("\n"))
		f.close()
	
	ref_src.append_array(process_gallery_singles())
	scenes_map = build_scenes_map(ref_src)


func process_gallery_singles() -> PoolStringArray:
	var res = PoolStringArray()
	for i in range(variables.gallery_singles_list.size()):
		res.append_array(process_gallery_item(i, variables.gallery_singles_list[i]))
	return res

func process_gallery_item(index: int, item: Dictionary) -> PoolStringArray:
	var res = PoolStringArray()
	res.append("** gallery_%d **" % index)
	res.append("=GUI_HIDE=")
	match item.type:
		'bg':
			res.append("=BG %s=" % item.path)
		'abg':
			res.append("=ABG %s=" % item.path)
	res.append("...")
	res.append("=STOP=")
	
	return res


func _process(delta: float) -> void:
	if TextField.get_total_character_count() > TextField.visible_characters:
		if globals.globalsettings.textspeed >= 200:
			ShownCharacters = TextField.get_total_character_count()
		else:
			ShownCharacters += delta*globals.globalsettings.textspeed
		TextField.visible_characters = ShownCharacters
		
	if delay > 0:
		delay -= delta
		if delay < 0:
			delay = 0
		
	if (!receive_input && delay == 0) || (receive_input && skip):
		advance_scene()



func _input(event: InputEvent) -> void:
	
	if $ChoicePanel.visible: return
	
	if event.is_action("ctrl"):
		if event.is_pressed():
			skip = true
		else:
			skip = false
	if event.is_echo() == true || event.is_pressed() == false:
		return
	
	
	if event.is_action("LMB") || event.is_action("MouseDown"):
		if TextField.get_visible_characters() < TextField.get_total_character_count():
			TextField.set_visible_characters(TextField.get_total_character_count())
		else:
			advance_scene()

func tag_white() -> void:
	var tween = input_handler.GetTweenNode($WhiteScreenGFX)
	var node = $WhiteScreenGFX
	tween.start()
	tween.interpolate_property(node, 'modulate', Color(1,1,1,0), Color(1,1,1,0.9), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.interpolate_property(node, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	yield(get_tree().create_timer(0.3), 'timeout')
	tween.interpolate_property(node, 'modulate', Color(1,1,1,0), Color(1,1,1,0.9), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.interpolate_property(node, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	yield(get_tree().create_timer(0.3), 'timeout')
	tween.interpolate_property(node, 'modulate', Color(1,1,1,0), Color(1,1,1,0.9), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.interpolate_property(node, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.7)

func tag_music_stop() -> void:
	input_handler.StopMusic()

func tag_gui_normal() -> void:
	$Panel.self_modulate.a = 1
	$Panel/Panel.modulate.a = 0
	$Panel.modulate.a = 1
	$Panel/DisplayName.self_modulate.a = 1
	$Panel/DisplayName/Label.set("custom_colors/font_color", Color('ffd204'))
	$Panel/CharPortrait.visible = true
	$Panel/CharPortrait.modulate.a = 0
	$Panel.visible = true
	$Panel/Options.visible = true
	$CharImage.visible = true

func tag_gui_hide() -> void:
	$Panel.hide()

func tag_gui_full() -> void:
	$Panel.self_modulate.a = 0
	$Panel/Panel.modulate.a = 0.7
	$Panel/DisplayName.self_modulate.a = 0
	$Panel/CharPortrait.visible = false
	$Panel/DisplayName/Label.set("custom_colors/font_color", Color('ffffff'))
	$Panel.visible = true
	$Panel/Options.visible = true
	$CharImage.visible = false

func tag_blackon() -> void:
	$BlackScreen.modulate.a = 1

func tag_blackoff() -> void:
	$BlackScreen.modulate.a = 0

func tag_blackfade(secs: String = "0.5") -> void:
	input_handler.emit_signal("ScreenChanged")
	input_handler.FadeAnimation($BlackScreen, float(secs))

func tag_blackunfade(secs: String = "0.5") -> void:
	input_handler.emit_signal("ScreenChanged")
	input_handler.UnfadeAnimation($BlackScreen, float(secs))

func tag_blacktrans(secs: String = "0.5") -> void:
	var duration = float(secs)
	TextField.bbcode_text = ''
	$Panel/CharPortrait.modulate.a = 0
	$Panel/DisplayName.modulate.a = 0
	input_handler.UnfadeAnimation($BlackScreen, duration)
	input_handler.emit_signal("ScreenChanged")
	input_handler.FadeAnimation($BlackScreen, duration, duration)

func tag_bg(res_name: String, secs: String = "") -> void:
	if is_video_bg:
		$Tween.interpolate_property($Background, "modulate:a",
			0.0, 1.0, 0.3, Tween.TRANS_LINEAR)
		$Tween.interpolate_property($VideoBunch, "modulate:a",
			1.0, 0.0, 0.3, Tween.TRANS_LINEAR)
		$Tween.start()
		is_video_bg = false
		yield(get_tree().create_timer(0.3), "timeout")
		for i in $VideoBunch.get_children():
			i.stop()
			i.stream = null
	if !replay_mode:
		state.unlock_path(res_name, false)
	var res = resources.get_res("bg/%s" % res_name)
	if secs != "":
		input_handler.SmoothTextureChange($Background, res, float(secs))
	else:
		$Background.texture = res
	$Background.update()
	

func tag_delay(secs: String) -> void:
	if skip: delay = 0.1
	else: delay = float(secs)

func get_choice(i: int):
	last_choice = i
	if !replay_mode:
		state.store_choice(choice_line, i)
	$ChoicePanel.visible = false
	advance_scene()


var choice_line = 0
func tag_choice(chstring: String) -> void:
	var chsplit = chstring.split("|")
	skip = false
	
	for i in $ChoicePanel/VBoxContainer.get_children():
		if i.name != 'Button':
			i.queue_free()
	
	$ChoicePanel.visible = true
	
	var c = 0
	choice_line = line_nr
	for ch in chsplit:
		var newbutton = $ChoicePanel/VBoxContainer.get_node("Button").duplicate()
		$ChoicePanel/VBoxContainer.add_child(newbutton)
		newbutton.show()
		newbutton.get_node("Label").text = tr(ch.replace('_', ' '))
		newbutton.index = c
		newbutton.connect('i_pressed', self, 'get_choice')
		if replay_mode:
			var stored_choice = state.get_choice(line_nr)
			if stored_choice == null:
				print("warning - no stored choice")
			else:
				if c != stored_choice:
					newbutton.disabled = true
		c += 1

func tag_decision(dec_name: String) -> void:
	decisions.append(dec_name)
	if !replay_mode:
		state.decisions.append(dec_name)


func tag_state(method:String, arg):
	if replay_mode: return
	match method:
		'char_unlock':
			state.unlock_char(arg)
		'location_unlock':
			state.unlock_loc(arg)
		'upgrade':
			state.make_upgrade(arg[0], int(arg[1]))
		'add_money':
			state.add_money(int(arg))
		'add_material':
			state.add_materials(arg[0], int(arg[1]))
		'make_quest':
			state.MakeQuest(arg)
		'advance_quest':
			state.AdvanceQuest(arg)
		'finish_quest':
			state.FinishQuest(arg)
		
		_: print("Unknown state command: %s" % method)

func tag_sprite_hide() -> void:
	ImageSprite.texture = null

func tag_sprite(res_name: String) -> void:
	var tspr = ImageSprite.get_node_or_null('sprite')
	if tspr != null:
		tspr.free()#to testing
	if !res_name in animated_sprites:
		ImageSprite.texture = resources.get_res("sprite/%s" % res_name)
	else:
		ImageSprite.texture = null
		var spr = resources.get_res("animated_sprite/%s" % res_name)
		var tmp = spr.instance()
		tmp.set_anchors_preset(PRESET_CENTER)
		ImageSprite.add_child(tmp)

func tag_sprite_fade(secs: String = "0.5") -> void:
	input_handler.FadeAnimation(ImageSprite, float(secs), delay)

func tag_sprite_unfade(secs: String = "0.5") -> void:
	input_handler.UnfadeAnimation(ImageSprite, float(secs), delay)

func tag_shake_sprite(secs: String = "0.2") -> void:
	input_handler.emit_signal("ScreenChanged")
	input_handler.ShakeAnimation(ImageSprite, float(secs))

func tag_shake_screen(secs: String = "0.2") -> void:
	input_handler.emit_signal("ScreenChanged")
	input_handler.ShakeAnimation(self, float(secs))

func tag_skip(ifindex_s: String, lcount_s: String) -> void:
	var ifindex = int(ifindex_s)
	var lcount = int(lcount_s)
	
	if ifindex == last_choice or ifindex == -1:
		line_nr += lcount

func tag_sound(res_name: String) -> void:
	input_handler.PlaySound(resources.get_res("sound/%s" % res_name))

func tag_music(res_name: String) -> void:
	input_handler.SetMusic(resources.get_res("music/%s" % res_name))

func tag_abg(res_name: String, sec_res_name: String = "") -> void:
	if !is_video_bg:
		$Tween.interpolate_property($Background, "modulate:a",
			1.0, 0.0, 0.3, Tween.TRANS_LINEAR)
		$Tween.interpolate_property($VideoBunch, "modulate:a",
			0.0, 1.0, 0.3, Tween.TRANS_LINEAR)
		$Tween.start()
		is_video_bg = true
	
	if !replay_mode:
		state.unlock_path(res_name, true)
	
	var vsplit = res_name.split("_")
	vsplit.remove(vsplit.size() - 1)
	var vfin = ""
	for w in vsplit:
		vfin += w + "_"
	vfin = vfin.left(vfin.length() - 1)
	res_name = vfin + "/" + res_name
	
	vsplit = sec_res_name.split("_")
	vsplit.remove(vsplit.size() - 1)
	if vsplit.size() > 0:
		vfin = ""
		for w in vsplit:
			vfin += w + "_"
		vfin = vfin.left(vfin.length() - 1)
		sec_res_name = vfin + "/" + sec_res_name
	
	var res = resources.get_res("abg/%s" % res_name)
	var sec_res = resources.get_res("abg/%s" % sec_res_name)

	$VideoBunch.Change(res, sec_res)

func tag_stop() -> void:
	input_handler.StopMusic()
	set_process(false)
	set_process_input(false)
	#globals.check_signal("EventFinished")
	hide()
	if !replay_mode:
		state.FinishEvent()
	replay_mode = false
	emit_signal("scene_end")


func tag_loose() -> void:
	tag_stop()
	if !replay_mode and input_handler.menu_node != null:
		input_handler.menu_node.GameOverShow()


func advance_scene() -> void:
	line_dr = ref_src[line_nr]
	receive_input = false
	
	if line_dr.begins_with("#"):
		line_nr += 1
		return
	
	if line_dr.begins_with("=") && line_dr.ends_with("="):
		line_dr = line_dr.replace("=", "")
		line_dr = line_dr.split(" ")
		if line_dr.size() == 0:
			print("Empty tag!")
			line_nr += 1
			advance_scene()
			return
		if !(line_dr[0] in AVAIL_EFFECTS):
			print("Unknown tag: ", line_dr)
			line_nr += 1
			return
		
		var method_name = "tag_%s" % line_dr[0].to_lower()
		if !has_method(method_name):
			print("Tag method %s not implemented yet!" % method_name)
			line_nr += 1
			return
		
		line_dr.remove(0)
		callv(method_name, line_dr)
		
	else:
		var splitted = line_dr.split(" - ")
		
		var is_narrator = true
		var character = char_map[char_map.keys()[0]]
		var replica = line_dr
		
		if splitted[0].length() <= char_max && splitted[0] in char_map.keys():
			character = char_map[splitted[0]]
			replica = splitted[1]
			is_narrator = false
		
		ShownCharacters = 0
		replica = tr(replica)
		TextField.visible_characters = ShownCharacters
		TextField.bbcode_text = "[color=#%s]%s[/color]" % [character.color.to_html(), replica]
		
		var portrait_res = resources.get_res("portrait/%s" % character.portrait)
		
		$Panel/DisplayName.modulate.a = 1 if !is_narrator else 0
		$Panel/CharPortrait.modulate.a = 1 if !is_narrator && portrait_res != null else 0
		$Panel/DisplayName/Label.text = tr(character.source)
		if ($Panel/CharPortrait.visible || $Panel/CharPortrait.modulate.a == 1) \
													&& portrait_res != null:
			$Panel/CharPortrait.texture = portrait_res
		
		receive_input = true
	
	line_nr += 1

func preload_scene(scene: String) -> void:
	scene_map = scenes_map[scene]
	for i in scene_map["res"].keys():
		for j in scene_map["res"][i]:
			resources.preload_res("%s/%s" % [i, j])

func play_scene(scene: String) -> void:
	set_process(false)
	set_process_input(false)
	
	scene_map = scenes_map[scene]
	
	line_nr = scene_map["start"]
	skip = false
	delay = 0
	receive_input = false
	decisions = PoolStringArray()
	last_choice = -1
	state.CurEvent = scene
	
	$Background.texture = null
	$Background.visible = true
	$CharImage.texture = null
	$Panel/CharPortrait.texture = null
	$Panel/DisplayText.bbcode_text = ''
	$Panel/DisplayName/Label.text = ''
	$Panel/DisplayName.visible = true
	$Panel/CharPortrait.visible = false
	$Panel.visible = false
	$CharImage.modulate.a = 0
	$BlackScreen.modulate.a = 0
	for i in $VideoBunch.get_children():
		i.stop()
		i.stream = null
	$VideoBunch.current_queue.clear()
	$VideoBunch.current_plrs = [$"VideoBunch/0", $"VideoBunch/1"]
	
	var has_res = true
	for i in scene_map["res"].keys():
		for j in scene_map["res"][i]:
			has_res =  i + "/" + j in resources.queue
			if !has_res:
				break
		if !has_res:
			break
	if !has_res:
		print("force loading %s..." % scene)
		preload_scene(scene)
		if resources.is_busy(): yield(resources, "done_work")
	
	yield(get_tree(), "idle_frame")
	set_process(true)
	set_process_input(true)

func build_scenes_map(lines: PoolStringArray) -> Dictionary:
	var out = {}
	var c = 0
	
	var chardef = false
	var chardef_color = Color.black
	
	for i in lines:
		if i.begins_with("#"):
			c+=1
			continue
		
		if i.begins_with("**") && i.ends_with("**"):
			current_scene = i.replace("**", "").replace(" ", "")
			out[current_scene] = {
				"start" : c + 1,
				"res" : {}
			}
		
		if i.begins_with("=") && i.ends_with("="):
			line_dr = i.replace("=", "")
			match line_dr:
				"STOP":
					out[current_scene]["stop"] = c
				
				"CHARDEF_BEGIN":
					chardef = true
				
				"CHARDEF_END":
					chardef = false
				
				_:
					if chardef:
						if line_dr.begins_with("COLOR #"):
							chardef_color = Color(line_dr.replace("COLOR #", ""))
					
					if line_dr.begins_with("ABG "):
						var vids = line_dr.replace("ABG ", "")
						vids = vids.split(" ")
						for v in vids:
							if !out[current_scene]["res"].has("abg"):
								out[current_scene]["res"]["abg"] = []
							var vsplit = v.split("_")
							vsplit.remove(vsplit.size() - 1)
							var vfin = ""
							for w in vsplit:
								vfin += w + "_"
							vfin = vfin.left(vfin.length() - 1)
							v = vfin + "/" + v
							if !out[current_scene]["res"]["abg"].has(v):
								out[current_scene]["res"]["abg"].append(v)
					else:
						for res_type in [
							"SPRITE",
							"SOUND",
							"MUSIC",
							"BG",
						]:
							if line_dr.begins_with("%s " % res_type):
								var res_name = line_dr.replace("%s " % res_type, "").split(" ")[0]
								if res_name == "null": break
								if res_type == 'SPRITE' and animated_sprites.has(res_name):
									res_type = 'animated_sprite'
								if !out[current_scene]["res"].has(res_type.to_lower()):
									out[current_scene]["res"][res_type.to_lower()] = []
								if !out[current_scene]["res"][res_type.to_lower()].has(res_name):
									out[current_scene]["res"][res_type.to_lower()].append(res_name)
								
								break
		
		else:
			if chardef:
				if i.split(" - ").size() == 2:
					var parsed = i.split(" - ")
					var raw = parsed[0]
					var raw_vars = []
					var left = []
					if raw.find("[") != -1:
						raw_vars = raw.right(raw.find("["))
						var raw_root = raw.left(raw.find("["))
						raw_vars = raw_vars.replace("[", "").replace("]", "")
						raw_vars = raw_vars.split(", ")
						var skipfirst = false
						for j in raw_vars:
							if !skipfirst:
								skipfirst = true
								left.append(raw_root)
								continue
							left.append(raw_root + "(" + j.to_lower() + ")")
					else:
						left.append(raw)
					
					var cooked = parsed[1].split(" ")
					var source = cooked[0]
					var portrait = [cooked[0]]
					var color = chardef_color
					
					if cooked.size() > 1:
						for j in cooked:
							if j.begins_with("#"):
								color = Color(j.replace("#", ""))
							else:
								portrait = [j]
					
					if raw_vars.size() > 0:
						var portrait_root = portrait[0]
						portrait = []
						for j in raw_vars:
							portrait.append(portrait_root + j)
					
					for j in range(left.size()):
						char_map[left[j]] = {
							"source" : source.replace("_", " "),
							"portrait" : portrait[j],
							"color" : color
						}
						if left[j].length() > char_max:
							char_max = left[j].length()
			else:
				var splitted = i.split(" - ")
				
				if splitted[0].length() <= char_max && splitted[0] in char_map.keys():
					var character = char_map[splitted[0]]
					
					var res_name = character.portrait
					if !out[current_scene]["res"].has("portrait"):
						out[current_scene]["res"]["portrait"] = []
					if !out[current_scene]["res"]["portrait"].has(res_name):
						out[current_scene]["res"]["portrait"].append(res_name)
		
		c += 1
	
	current_scene = ""
	line_dr = ""
	return out.duplicate(true)
