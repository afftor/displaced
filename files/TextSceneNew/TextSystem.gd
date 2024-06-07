extends Control
# warning-ignore-all:warning-id
signal scene_end
#all those signals should be here, so that yield-stuff could work correctly on freed instance (on load, for example)
signal EventOnScreen
signal AllEventsFinished
signal EventFinished
#=======

var text_log = ""

const REF_PATH = "res://assets/data/txt_ref/scn"

const AVAIL_EFFECTS = [
	"WHITE", "SPRITE_HIDE",
	"MUSIC_STOP", "GUI_NORMAL",
	"GUI_HIDE", "GUI_FULL",
	"BLACKON", "BLACKOFF",
	"BLACKFADE", "BLACKUNFADE",
	"BLACKTRANS", "BG", "DELAY",
	"SPRITE", "SPRITE_FADE", "SPRITE_HIDE",
	"SPRITE_UNFADE", "SHAKE_SPRITE",
	"SHAKE_SCREEN", "SOUND", "MUSIC",
	"ABG", "STOP", "CHOICE",
	"DECISION", "STATE", "LOOSE",
	"IF", "MOVETO", "POSITION", "BG_EMPTY"
	]

const animated_sprites = ['arron', 'rose', 'annet', 'erika', 'erika_n', 'iola', 'emberhappy', 'embershock', 'caliban', 'dragon', 'kingdwarf', 'victor', 'zelroth','zelrothcaliban', 'rilu', 'demitrius', 'demitrius_demon', 'goblin', 'goblin2'] #idk if they are named this way in scenes
#demitrius sprites are from 'unused folder' - so don't remove them accidentally
#others sprites are not used (or i did not textfind them in scenes for some reasons - write me if they are there)
var char_map = {
	Narrator = {
		source = 'NARRATOR',
#		portrait = null,
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones, useless now
#		sprite = null, #useless for now due to SPRITE format currntly used
#		animated = false,
		color = Color('ffffff'),
	},
	Z = {
		source = 'ZELROTH',
		portrait = 'Zelroth',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'zelroth',
#		animated = true,
		color = Color('ffffff'),
	},
	Woman = {
		source = 'WOMAN',
#		portrait = 'Woman', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	V = {
		source = 'VIKTOR',
		portrait = 'Viktor',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'victor',
#		animated = true,
		color = Color('ffffff'),
	},
	T = {
		source = 'TRAVELER',
		portrait = 'traveller',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Traveler = {
		source = 'TRAVELER',
#		portrait = 'traveller_2', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Surv = {
		source = 'SURVIVOR',
#		portrait = 'Survivor', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Str2 = {
		source = 'STRANGER2',
#		portrait = 'Stranger_2', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Str = {
		source = 'STRANGER',
#		portrait = 'Stranger', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Entr = {
		source = 'ENTERTAINER',
#		portrait = 'Entertainer', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	SlaveTrader2 = {
		source = 'SLAVE_TRADER_A',
#		portrait = 'Slave_Trader', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	SlaveTrader = {
		source = 'SLAVE_TRADER_B',
#		portrait = 'Slave_Trader_2', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	S = {
		source = 'SOLDIER',
		portrait = 'Guard',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Ro = {
		source = 'ROSE',
		portrait = 'Rose',
		base_variants = ['Normal', 'Talk', 'Shock', 'Sad', 'Sarcastic'], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'rose',
#		animated = true,
		color = Color('ff8c00'),
	},
	Ri = {
		source = 'RILU',
		portrait = 'Rilu',
		base_variants = ['Normal', 'Blush', 'Spell', 'Talk'], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'rilu',
#		animated = true,
		color = Color('C53BFF'),#?
	},
	RN = {
		source = 'RICH_NOBLE',
#		portrait = 'Rich_Noble', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Nt = {
		source = 'NORBERT',
		portrait = 'Norbert',
		base_variants = ['Normal', 'Anger'], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	N = {
		source = 'NICOLAS',
#		portrait = 'Nicolas', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	M = {
		source = 'MERCHANT',
#		portrait = 'Merchant', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Lr = {
		source = 'LYRA',
		portrait = 'Lyra',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	KD = {
		source = 'KING_DWARF',
		portrait = 'King_Dwarf',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'kingdwarf',
#		animated = true,
		color = Color('ffffff'),
	},
	I = {
		source = 'IOLA',
		portrait = 'Iola',
		base_variants = ['Sad', 'Shock'], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'iola',
#		animated = true,
		color = Color('2A97CB'),#?
	},
	Guard = {
		source = 'GUARD1',
		portrait = 'Guard',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Guard_2 = {
		source = 'GUARD2',
		portrait = 'Guard',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Guard_3 = {
		source = 'GUARD3',
		portrait = 'Guard',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	G = {
		source = 'GOBLIN',
		portrait = 'Goblin',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'goblin',
#		animated = true,
		color = Color('ffffff'),
	},
	FQ = {
		source = 'FAERY_QUEEN',
		portrait = 'FairyQueen',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'faeryqueen',
#		animated = false,
		color = Color('ffffff'),
	},
	FA = {
		source = 'FAERY_A',
#		portrait = 'Fairy_A', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	FB = {
		source = 'Faery B',
#		portrait = 'Fairy_B', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	F = {
		source = 'FLAK',
		portrait = 'Flak',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'goblin2',
#		animated = true,
		color = Color('ffffff'),
	},
	Et = {
		source = 'ENT',
#		portrait = 'Ent', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'ent',
#		animated = false,
		color = Color('ffffff'),
	},
	Er = {
		source = 'ERIKA',
		portrait = 'Erika',
		base_variants = ['Normal', 'Happy', 'Anger', 'Sad'], #for normal filenamaes with suffixes
#		custom_variants = [
#			'_n':{sprite = 'erika_n},
#		], #for specific ones
#		sprite = 'erika',
#		animated = true,
		color = Color('228b22'),
	},
	Em = {
		source = 'EMBER',
		portrait = 'Ember',
		base_variants = ['Normal', 'Happy', 'Sad'], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'ember',
#		animated = true,
		color = Color('b22156'),
	},
	EC = {
		source = 'ELF_CHILD',
#		portrait = 'Elf_Child', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
#	DrJr = {
#		source = 'Dragon Whelp',
#		portrait = 'DragonJr',
#		base_variants = [], #for normal filenamaes with suffixes
##		custom_variants = [], #for specific ones
##		sprite = null,
##		animated = false,
#		color = Color('ffffff'),
#	},
	Ezet = {
		source = 'EZET',
		portrait = 'Ezet',
		base_variants = [],
		color = Color('ffffff'),
	},
	Dr = {
		source = 'DRAGON',
		portrait = 'Dragon',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'dragon',
#		animated = true,
		color = Color('ffffff'),
	},
	Demon = {
		source = 'DEMON',
#		portrait = 'Demon', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'demon',
#		animated = false,
		color = Color('ffffff'),
	},
	D = {
		source = 'DEMITRIUS',
		portrait = 'Demitrius',
		base_variants = ['Normal', 'Talk'],#'Anger' #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'demitrius',
#		animated = true,
		color = Color('ffffff'),#?
	},
	De = {
		source = 'DEMITRIUS_DEMON',
		portrait = 'Demitrius_Demon',
		base_variants = ['Normal'],#'Anger' #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'demitrius_demon',
#		animated = true,
		color = Color('ffffff'), #?
	},
	CM = {
		source = 'COMMITTEE_MEMBER',
#		portrait = 'Committee_Member', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	C = {
		source = 'CALIBAN',
		portrait = 'Caliban',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'caliban',
#		animated = true,
		color = Color('ffffff'),
	},
	Cy = {
		source = 'CYREX',
		portrait = 'Caliban',
		base_variants = [], #for normal filenamaes with suffixes
		color = Color('ffffff'),
	},
	Boy = {
		source = 'BOY',
#		portrait = 'Boy', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	Ar = {
		source = 'ARRON',
		portrait = 'Arron',
		base_variants = ['Normal', 'Neutral', 'Shock', 'Anger'], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'arron',
#		animated = true,
		color = Color('c0c0c0'),
	},
	An = {
		source = 'ANNET',
		portrait = 'Annet',
		base_variants = ['Normal', 'Anger'], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = 'annet',
#		animated = true,
		color = Color('ffffff'),#?
	},
	'?':{
		source = '??',
#		portrait = '??', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	'??': {
		source = '???',
#		portrait = '???', #not exist
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	'?(Z)': {
		source = '???',
		portrait = 'Zelroth',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	'?(C)': {
		source = '???',
		portrait = 'Caliban',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	'?(An)': {
		source = '???',
		portrait = 'AnnetNormal',
		base_variants = [], #for normal filenamaes with suffixes
#		custom_variants = [], #for specific ones
#		sprite = null,
#		animated = false,
		color = Color('ffffff'),
	},
	slavetrader = {
		source = 'SLAVE_TRADER_A',
#		portrait = 'Boy',
		base_variants = [],
		color = Color('ffffff'),
	},
	slavetrader2 = {
		source = 'SLAVE_TRADER_B',
#		portrait = 'Boy',
		base_variants = [],
		color = Color('ffffff'),
	},
	Dwarf = {
		source = 'DWARF_SOLDIER',
		portrait = 'DwarfSoldier',
		base_variants = [],
		color = Color('ffffff'),
	},
}





onready var TextField = $Panel/DisplayText
onready var ImageSprite = $CharImage
var ShownCharacters = 0.0

var ref_src = PoolStringArray()

var current_scene = ""
var scene_map = {}
var step = 0
var line_start = 0
var line_dr = ""

var scenes_map = {}


var char_max = 0

var skip = false
var delay = 0
var receive_input = false
var force_stop

var is_video_bg = false
var decisions = PoolStringArray()
var last_choice = -1
var choice_number = -1

var replay_mode = false
var rewind_mode = false

var panel_vis = true
var panel_user_hidden = false

func _ready() -> void:
	input_handler.set_handler_node('scene_node', self)
	extend_char_map()
	preload_portraits()
	set_process(false)
	set_process_input(false)
	var f = File.new()
	for i in process_path_dir(REF_PATH):
		f.open(i, File.READ)
		ref_src.append_array(f.get_as_text().split("\n"))
		f.close()
	
#	ref_src.append_array(process_gallery_singles())
	scenes_map = build_scenes_map(ref_src)

	globals.AddPanelOpenCloseAnimation($LogPanel)
	$Panel/Log.connect("pressed",self,'OpenLog')
	$Panel/Options.connect('pressed', self, 'OpenOptions')
	
	$ClosePanel/Cancel.connect("pressed", $ClosePanel, "hide")
	$ClosePanel/Confirm.connect("pressed", self, "on_closepanel_confirm")


func toggle_panel():
	if $MenuPanel.visible: 
		return
	if !panel_vis: 
		return
	$Panel.visible = !$Panel.visible
	panel_user_hidden = !$Panel.visible



func process_path_dir(path):
	var res = []
	for i in globals.dir_contents(path):
		if i.ends_with('.txt') == false:
			continue
		res.push_back(i)
	return res


func extend_char_map():
	for key in char_map.keys().duplicate():
		if key.length() > char_max:
			char_max = key.length()
		var mapdata = char_map[key]
		if mapdata.has('custom_variants'):#currently not used
			for variant in mapdata.custom_variants:
				var newkey = key + variant
				var newdata = mapdata.duplicate(true)
				var patchdata = mapdata.custom_variants[variant]
				if newkey.length() > char_max:
					char_max = newkey.length()
				for arg in patchdata:
					newdata[arg] = patchdata[arg]
				char_map[newkey] = newdata
		if mapdata.has('base_variants'):
			for variant in mapdata.base_variants:
				var newkey = "%s(%s)" % [key, variant.to_lower()]
				var newdata = mapdata.duplicate(true)
				if newkey.length() > char_max:
					char_max = newkey.length()
				if newdata.has("portrait"):#in fact chars with base_variants always should have portrait
					newdata.portrait = newdata.portrait + variant
				char_map[newkey] = newdata
			if mapdata.base_variants.has('Normal') and char_map[key].has("portrait"):
				char_map[key].portrait = char_map[key].portrait + 'Normal'


func preload_portraits():
	for chardata in char_map.values():
		if chardata.has('portrait'):
			resources.preload_res("portrait/%s" % chardata.portrait)

func OpenLog():
	var log_panel = $LogPanel
	var log_label = $LogPanel/RichTextLabel
	if log_panel.visible:
		log_panel.hide()
		return
	log_label.bbcode_text = text_log
	log_panel.show()
	yield(get_tree().create_timer(0.2), 'timeout')
	log_label.scroll_to_line(log_label.get_line_count()-1)

func OpenOptions():
	$MenuPanel.show()


#variables.gallery_singles_list seems to be empty and unused
#func process_gallery_singles() -> PoolStringArray:
#	var res = PoolStringArray()
#	for i in range(variables.gallery_singles_list.size()):
#		res.append_array(process_gallery_item(i, variables.gallery_singles_list[i]))
#	return res

#func process_gallery_item(index: int, item: Dictionary) -> PoolStringArray:
#	var res = PoolStringArray()
#	res.append("** gallery_%d **" % index)
#	res.append("=GUI_HIDE=")
#	match item.type:
#		'bg':
#			res.append("=BG %s=" % item.path)
#		'abg':
#			res.append("=ABG %s=" % item.path)
#	res.append("...")
#	res.append("=STOP=")
#
#	return res


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
	
	if force_stop: skip = false
	if (!receive_input && delay == 0) || (receive_input && skip):
		advance_scene()


func is_input_blocked() ->bool:
	return delay > 0 or is_panel_visible()

func is_panel_visible() ->bool:
	return ($ChoicePanel.visible
			or $ClosePanel.visible
			or $MenuPanel.visible)

func _input(event: InputEvent):
	#here we process only keyboard events, for mouse events see _gui_input()
	if !(event is InputEventKey): return
	if event.is_action("ctrl"):
		if event.is_pressed():
			if !is_panel_visible() and !panel_user_hidden:
				skip = true
		else:
			skip = false
		get_tree().set_input_as_handled()
		return

func _unhandled_key_input(event):
	if is_input_blocked(): return
	#only avail in replay mode due to ability to miss critical choices and unlocks otherwise
	if replay_mode and event.is_action_pressed("ESC"):
		prompt_close()
		get_tree().set_input_as_handled()

func _gui_input(event: InputEvent):
	#here we process only mouse events, to avoid collisions with buttons
	#for keyboard events see _input()
	if $MenuPanel.visible: return
	if $LogPanel.visible == true:
		if event.is_action_pressed("MouseDown"):
			var v_scroll = $LogPanel/RichTextLabel.get_v_scroll()
			if (v_scroll.value + v_scroll.page == v_scroll.max_value
					|| !v_scroll.visible):
				$LogPanel.hide()
		return
	elif event.is_action_pressed("MouseUp"):
		OpenLog()
		return
	
	if is_input_blocked(): return
	
	if event.is_action_pressed("RMB"):
		toggle_panel()
		return

	if ((event.is_action_pressed("LMB")
			or event.is_action_pressed("MouseDown"))
			and !panel_user_hidden):
		if TextField.get_visible_characters() < TextField.get_total_character_count():
			TextField.set_visible_characters(TextField.get_total_character_count())
		else:
#			print("+")
			advance_scene()
		return

#--------------tags------------
func tag_white() -> void:
	var node = $WhiteScreenGFX
	input_handler.tween_property(node, 'modulate', Color(1,1,1,0), Color(1,1,1,0.9), 0.3)
	input_handler.tween_property(node, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3, 0.3)
	yield(get_tree().create_timer(0.3), 'timeout')
	input_handler.tween_property(node, 'modulate', Color(1,1,1,0), Color(1,1,1,0.9), 0.3)
	input_handler.tween_property(node, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3, 0.3)
	yield(get_tree().create_timer(0.3), 'timeout')
	input_handler.tween_property(node, 'modulate', Color(1,1,1,0), Color(1,1,1,0.9), 0.7)
	input_handler.tween_property(node, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.4, 0.7)

func tag_music_stop() -> void:
	input_handler.StopMusic()

func tag_gui_normal() -> void:
	$Panel.self_modulate.a = 1
	$Panel/Panel.modulate.a = 0
	$Panel.modulate.a = 1
	$Panel/DisplayName.self_modulate.a = 1
	$Panel/DisplayName/Label.set("custom_colors/font_color", Color('ffd204'))
	$Panel/DisplayName.modulate.a = 0
	$Panel/CharPortrait.visible = true
	$Panel/CharPortrait.modulate.a = 0
	$Panel.visible = true
	$Panel/Options.visible = true
	$CharImage.visible = true
	panel_vis = true

func tag_gui_hide() -> void:
	$Panel.hide()
	TextField.bbcode_text = ''
	panel_vis = false

func tag_gui_full() -> void:
	$Panel.self_modulate.a = 0
	$Panel/Panel.modulate.a = 0.7
	$Panel/DisplayName.self_modulate.a = 0
	$Panel/CharPortrait.visible = false
	$Panel/DisplayName/Label.set("custom_colors/font_color", Color('ffffff'))
	$Panel.visible = true
	$Panel/Options.visible = true
	$CharImage.visible = false
	panel_vis = true

func tag_blackon() -> void:
	$BlackScreen.modulate.a = 1

func tag_blackoff() -> void:
	$BlackScreen.modulate.a = 0

func tag_blackfade(secs: String = "0.5") -> void:
	input_handler.emit_signal("ScreenChanged")
	if rewind_mode:
		tag_blackoff()
	else:
		input_handler.FadeAnimation($BlackScreen, float(secs))

func tag_blackunfade(secs: String = "0.5") -> void:
	input_handler.emit_signal("ScreenChanged")
	if rewind_mode:
		tag_blackon()
	else:
		input_handler.UnfadeAnimation($BlackScreen, float(secs))

#using yield() is not good idea, but the best practice would be to get rid =BLACKTRANS= tag at all
func tag_blacktrans(secs: String = "0.5") -> void:
	input_handler.emit_signal("ScreenChanged")
	TextField.bbcode_text = ''
	$Panel/CharPortrait.modulate.a = 0
	$Panel/DisplayName.modulate.a = 0
	if rewind_mode:
		tag_blackoff()
		return
	var duration = float(secs)
	input_handler.UnfadeAnimation($BlackScreen, duration)
	yield(get_tree().create_timer(duration), 'timeout')
	input_handler.FadeAnimation($BlackScreen, duration)

func tag_bg(res_name: String, secs: String = "") -> void:
#	if !replay_mode:
	var res = null
	if !res_name.empty():
		state.unlock_path(res_name, false)
		res = resources.get_res("bg/%s" % res_name)
	if !secs.empty() and !is_video_bg and !rewind_mode:
		input_handler.SmoothTextureChange($Background, res, float(secs))
	else:
		$Background.texture = res
	$Background.update()
	
	if is_video_bg:
		is_video_bg = false
		if rewind_mode or secs.empty():
			$Background.modulate.a = 1.0
			$VideoBunch.modulate.a = 0.0
		else:
			var time = float(secs)
			$Tween.interpolate_property($Background, "modulate:a",
				0.0, 1.0, time, Tween.TRANS_LINEAR)
			$Tween.interpolate_property($VideoBunch, "modulate:a",
				1.0, 0.0, time, Tween.TRANS_LINEAR)
			$Tween.start()
			yield(get_tree().create_timer(time), "timeout")
		for i in $VideoBunch.get_children():
			i.stop()
			i.stream = null

func tag_bg_empty() -> void:
	tag_bg('')

func tag_delay(secs: String) -> void:
	if rewind_mode:
		return
	if skip: delay = 0.1
	else: delay = float(secs)

func tag_choice(chstring: String) -> void:
	choice_number += 1
	if rewind_mode:
		var stored_choice = state.get_choice(choice_number)
		if stored_choice != null:
			last_choice = stored_choice
			return
		else:
			print("warning - no stored choice")
			rewind_mode = false
			#So we stop rewinding if there is no choice stored,
			#which should occur only if save-file is incompatible with game version
			#or there was an error. Mind that "decision" in this case
			#probably has been stored correctly.
	var chsplit = chstring.split("|")
	skip = false
	force_stop = true
	
	for i in $ChoicePanel/VBoxContainer.get_children():
		if i.name != 'Button':
			i.queue_free()
	
	$ChoicePanel.visible = true
	
	var c = 0
	for ch in chsplit:
		var newbutton = $ChoicePanel/VBoxContainer.get_node("Button").duplicate()
		$ChoicePanel/VBoxContainer.add_child(newbutton)
		newbutton.show()
#		print("%d %s" % [c, tr(ch)])
		newbutton.get_node("Label").text = tr(ch)
		newbutton.index = c
		newbutton.connect('i_pressed', self, 'get_choice')
		if replay_mode:
			var stored_choice = state.get_choice(choice_number)
			if stored_choice == null:
				print("warning - no stored choice")
			else:
				if c != stored_choice:
					newbutton.disabled = true
		c += 1

func get_choice(i: int):
	last_choice = i
	if !replay_mode:
		state.store_choice(choice_number, i)
	for ch_button in $ChoicePanel/VBoxContainer.get_children():
		if ch_button.index == i:
#			print("%d %s" % [i, ch_button.get_node("Label").text])
			text_log += "\n\n" + ch_button.get_node("Label").text
			break
	$ChoicePanel.visible = false
	force_stop = false
	advance_scene()


func tag_decision(dec_name: String) -> void:
	decisions.append(dec_name)
	if replay_mode or rewind_mode: return
	state.decisions.append(dec_name)

func tag_state(method:String, arg):
	if replay_mode or rewind_mode: return
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
#		'make_quest':
#			state.MakeQuest(arg)
#		'advance_quest':
#			state.AdvanceQuest(arg)
#		'finish_quest':
#			state.FinishQuest(arg)

		_: print("Unknown state command: %s" % method)

func tag_sprite_hide() -> void:
	ImageSprite.modulate = Color(1,1,1,0)

func tag_sprite(res_name: String) -> void:
	var tspr = ImageSprite.get_node_or_null('sprite')
	if tspr != null:
		tspr.free()#to testing
#	yield(get_tree(), "idle_frame")
	if !res_name in animated_sprites:
		ImageSprite.texture = resources.get_res("sprite/%s" % res_name)
	else:
		ImageSprite.texture = null
		var spr = resources.get_res("animated_sprite/%s" % res_name)
		var tmp = spr.instance()
		tmp.set_anchors_preset(PRESET_CENTER)
		ImageSprite.add_child(tmp)
	#autounfade
	tag_sprite_unfade("0.3")

func tag_sprite_fade(secs: String = "0.5") -> void:
	if rewind_mode:
		ImageSprite.modulate.a = 0.0
	else:
		input_handler.FadeAnimation(ImageSprite, float(secs), delay)

func tag_sprite_unfade(secs: String = "0.5") -> void:
	if rewind_mode:
		ImageSprite.modulate.a = 1.0
	else:
		input_handler.UnfadeAnimation(ImageSprite, float(secs), delay)

func tag_shake_sprite(secs: String = "0.2") -> void:
	if rewind_mode: return
	input_handler.emit_signal("ScreenChanged")
	input_handler.ShakeAnimation(ImageSprite, float(secs))

func tag_shake_screen(secs: String = "0.2") -> void:
	if rewind_mode: return
	input_handler.emit_signal("ScreenChanged")
	input_handler.ShakeAnimation(self, float(secs))

#fully migrated from =SKIP= methods to =IF= and =MOVETO=, as it is far more flexible and mistakeproof
#func tag_skip(ifindex_s: String, lcount_s: String) -> void:
#	var ifindex = int(ifindex_s)
#	var lcount = int(lcount_s)
#
#	if ifindex == last_choice or ifindex == -1:
#		step += lcount

func tag_sound(res_name: String) -> void:
	if rewind_mode: return
	input_handler.PlaySound(resources.get_res("sound/%s" % res_name))

func tag_music(res_name: String) -> void:
	input_handler.SetMusic(res_name)

func tag_abg(res_name: String, sec_res_name: String = "") -> void:
	if !is_video_bg:
		is_video_bg = true
		if rewind_mode:
			$Background.modulate.a = 0.0
			$VideoBunch.modulate.a = 1.0
		else:
			$Tween.interpolate_property($Background, "modulate:a",
				1.0, 0.0, 0.3, Tween.TRANS_LINEAR)
			$Tween.interpolate_property($VideoBunch, "modulate:a",
				0.0, 1.0, 0.3, Tween.TRANS_LINEAR)
			$Tween.start()
		
		

#	if !replay_mode:
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

	if rewind_mode:
		$VideoBunch.force_show(res, sec_res)
	else:
		$VideoBunch.Change(res, sec_res)
	delay = max(delay, 0.3) #not sure, but should be enough to fix asynchonisation of abg changing 

func tag_moveto(pos :String) ->void:
	var cur_line = get_line_nr()
	for line_num in range(cur_line, scene_map["stop"]):
		var line = ref_src[line_num]
		if line.begins_with("=") and line.ends_with("="):
			var tag_string = line.replace("=", "")
			var tag_array = tag_string.split(" ")
			if tag_array.size() == 0:
				continue
			if (tag_array[0] == "POSITION"
					and tag_array[1] == pos):
				step = line_num - line_start
				return
	assert(false, "POSITION not found in tag_moveto!!!")

func tag_position(pos :String) ->void:
	#ignored, as this is not a tag, but a marker for =MOVETO= tag
	pass

func tag_if(type :String, value :String, true_pos :String, false_pos :String) ->void:
	var success :bool
	if type == "SCENESEEN":
		success = state.valuecheck({type = "scene_seen", value = value})
	elif type == "LASTCHOICE":
		success = (int(value) == last_choice)
	elif type == "FORCEDCONTENT":
		#value in this case irrelevant
		success = globals.globalsettings.forced_content
	else:
		assert(false, "Unknow condition in tag_if!!!")
		return
	
	if success:
		tag_moveto(true_pos)
	else:
		tag_moveto(false_pos)

func tag_loose() -> void:
	stop_scene_on_lose()#mind that here replay_mode made false in any case (is it right?)
	if !replay_mode and input_handler.menu_node != null:
		input_handler.menu_node.GameOverShow()

#-------------------------------

func prompt_close():
	$ClosePanel.show()
#	print_tree_pretty()

func on_closepanel_confirm():
	$ClosePanel.hide()
	stop_scene()


func stop_scene() -> void:
	input_handler.SetMusic("towntheme")
	set_process(false)
	set_process_input(false)
	input_handler.curtains.show_inst(variables.CURTAIN_SCENE)
	hide()
	state.FinishEvent(replay_mode)
	replay_mode = false
	emit_signal("EventFinished")

#it should be almost the same to stop_scene() but with no afteractions
func stop_scene_on_lose() ->void:
	set_process(false)
	set_process_input(false)
	hide()
	state.ClearEvent()
	replay_mode = false
	emit_signal("EventFinished")

func advance_scene() -> void:
	step += 1
	if !rewind_mode:#'and !replay_mode' also was here. Mind if something would break
		state.scene_restore_data.step = step
	line_dr = ref_src[get_line_nr()]
	receive_input = false

	if line_dr.begins_with("#"):
		return

	if line_dr.begins_with("=") && line_dr.ends_with("="):
		line_dr = line_dr.replace("=", "")
		var line_array = line_dr.split(" ")
		if line_array.size() == 0:
			print("Empty tag!")
			advance_scene()
			return
		if !(line_array[0] in AVAIL_EFFECTS):
			print("Unknown tag: ", line_array)
			return
		if line_array[0] == "STOP":
			stop_scene()
			return
		
		var method_name = "tag_%s" % line_array[0].to_lower()
		if !has_method(method_name):
			print("Tag method %s not implemented yet!" % method_name)
			return
		
		line_array.remove(0)
		callv(method_name, line_array)
		
	elif !rewind_mode:
		var is_narrator = true
		var character = char_map['Narrator']
		var replica = line_dr
		
		if " - " in line_dr:
			var splitted = line_dr.split(" - ", true, 1)
			if is_char_name(splitted[0]):
				character = char_map[splitted[0]]
				replica = splitted[1]
				is_narrator = false
		
		replica = tr(replica)
		
		ShownCharacters = 0
		if is_narrator:
			text_log += '\n\n' + replica
		else:
			text_log += '\n\n' + '[' + tr(character.source) + ']\n' + replica
		
		TextField.visible_characters = ShownCharacters
		TextField.bbcode_text = "[color=#%s]%s[/color]" % [character.color.to_html(), replica]
		
		var portrait_res
		if character.has("portrait"):
			portrait_res = resources.get_res("portrait/%s" % character.portrait)
		
		$Panel/DisplayName.modulate.a = 1 if !is_narrator else 0
		$Panel/CharPortrait.modulate.a = 1 if !is_narrator && portrait_res != null else 0
		$Panel/DisplayName/Label.text = tr(character.source)
		if ($Panel/CharPortrait.visible || $Panel/CharPortrait.modulate.a == 1) \
													&& portrait_res != null:
			$Panel/CharPortrait.texture = portrait_res
		
		receive_input = true


func preload_scene(scene: String) -> void:
	scene_map = scenes_map[scene]
	for i in scene_map["res"].keys():
		for j in scene_map["res"][i]:
			resources.preload_res("%s/%s" % [i, j])

func play_scene(scene: String, restore = false, force_replay = false) -> void:
	set_process(false)
	set_process_input(false)
	replay_mode = (force_replay or state.OldEvents.has(scene))

	scene_map = scenes_map[scene]

	line_start = scene_map["start"]
	step = -1
	skip = false
	delay = 0
	receive_input = false
	decisions = PoolStringArray()
	last_choice = -1
	choice_number = -1
	state.CurEvent = scene
	text_log = ""

	$Background.texture = null
	$Background.visible = true
	$CharImage.texture = null
	$Panel/CharPortrait.texture = null
	$Panel/DisplayText.bbcode_text = ''
	$Panel/DisplayName/Label.text = ''
	$Panel/DisplayName.visible = true
	$Panel/CharPortrait.visible = false
	$Panel/DisplayName.modulate.a = 0
	$Panel/CharPortrait.modulate.a = 0
	$Panel.visible = false
	panel_vis = false
	panel_user_hidden = false
	$CharImage.modulate.a = 0
	var BlackScreen_node = $BlackScreen
	input_handler.force_end_tweens(BlackScreen_node)
	BlackScreen_node.modulate.a = 0
	for i in $VideoBunch.get_children():
		i.stop()
		i.stream = null
	$VideoBunch.current_queue.clear()
	$VideoBunch.current_plrs = [$"VideoBunch/0", $"VideoBunch/1"]

	var has_res = true
	for i in scene_map["res"].keys():
		for j in scene_map["res"][i]:
			has_res = resources.has_res(i + "/" + j)
			if !has_res:
				break
		if !has_res:
			break
	if !has_res:
#		print("force loading %s..." % scene)
		preload_scene(scene)
		if resources.is_busy(): yield(resources, "done_work")

	var my_tween = input_handler.GetTweenNode(self)
	if input_handler.is_tween_active(my_tween):
		yield(my_tween, input_handler.get_tween_finish_signal())
	yield(get_tree(), "idle_frame")
	emit_signal("EventOnScreen")
	set_process(true)
	set_process_input(true)
	if restore:
		var rewind_to_step = 0
		if state.scene_restore_data.has("step"):
			rewind_to_step = state.scene_restore_data.step
		rewind_to_step -= 1
		rewind_mode = true
		while step < rewind_to_step:
			advance_scene()
			if !rewind_mode : break
		rewind_mode = false

func build_scenes_map(lines: PoolStringArray) -> Dictionary:
	var out = {}
	var c = 0
	var strings_to_check = []#only for changes in events

#	var chardef = false
#	var chardef_color = Color.black

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
			c+=1
			continue

		if i.begins_with("=") && i.ends_with("="):
			line_dr = i.replace("=", "")
			match line_dr:
				"STOP":
					#mind, that event can have few STOP tags, so only the last one will be recorded as scene end
					out[current_scene]["stop"] = c
#				"CHARDEF_BEGIN":
#					chardef = true
#				"CHARDEF_END":
#					chardef = false
				_:
#					if chardef:
#						if line_dr.begins_with("COLOR #"):
#							chardef_color = Color(line_dr.replace("COLOR #", ""))
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
								var res_type_lower = res_type.to_lower()
								if !out[current_scene]["res"].has(res_type_lower):
									out[current_scene]["res"][res_type_lower] = []
								if !out[current_scene]["res"][res_type_lower].has(res_name):
									out[current_scene]["res"][res_type_lower].append(res_name)
								break

		else:
			#to del
#			if chardef: #obsolete, but hard to clean out fast
#				if i.split(" - ").size() == 2:
#					var parsed = i.split(" - ")
#					var raw = parsed[0]
#					var raw_vars = []
#					var left = []
#					if raw.find("[") != -1:
#						raw_vars = raw.right(raw.find("["))
#						var raw_root = raw.left(raw.find("["))
#						raw_vars = raw_vars.replace("[", "").replace("]", "")
#						raw_vars = raw_vars.split(", ")
#						var skipfirst = false
#						for j in raw_vars:
#							if !skipfirst:
#								skipfirst = true
#								left.append(raw_root)
#								continue
#							left.append(raw_root + "(" + j.to_lower() + ")")
#					else:
#						left.append(raw)
#
#					var cooked = parsed[1].split(" ")
#					var source = cooked[0]
#					var portrait = [cooked[0]]
#					var color = chardef_color
#
#					if cooked.size() > 1:
#						for j in cooked:
#							if j.begins_with("#"):
#								color = Color(j.replace("#", ""))
#							else:
#								portrait = [j]
#
#					if raw_vars.size() > 0:
#						var portrait_root = portrait[0]
#						portrait = []
#						for j in raw_vars:
#							portrait.append(portrait_root + j)
#
#					for j in range(left.size()):
#						char_map[left[j]] = {
#							"source" : source.replace("_", " "),
#							"portrait" : portrait[j],
#							"color" : color
#						}
#						if left[j].length() > char_max:
#							char_max = left[j].length()
#			else:
			if " - " in i:
				var char_code = i.get_slice(" - ", 0)
				if is_char_name(char_code):
					var character = char_map[char_code]
					if character.has("portrait"):
						var res_name = character.portrait
						if !out[current_scene]["res"].has("portrait"):
							out[current_scene]["res"]["portrait"] = []
						if !out[current_scene]["res"]["portrait"].has(res_name):
							out[current_scene]["res"]["portrait"].append(res_name)
			
			#-------should probably be commented befor release------
			if !i.empty():
				var line_id = i
				if " - " in i:
					line_id = i.get_slice(" - ", 1)
					if line_id.empty():
						print("No line id at %s: %s" % [current_scene, i])
				if strings_to_check.has(line_id):
					print("Translation double at %s: %s" % [current_scene, line_id])
				else:
					strings_to_check.append(line_id)
				if line_id == tr(line_id):#should find better way to check strings in TranslationServer
					print("No translation at %s: %s" % [current_scene, line_id])
			#-----------

		c += 1

	for original in Explorationdata.cloned_scenes:
		var clone = Explorationdata.cloned_scenes[original]
		out[clone] = out[original].duplicate(true)
	current_scene = ""
	line_dr = ""
	return out.duplicate(true)#duplicate needed?

func get_line_nr() -> int:
	return line_start + step

func is_char_name(char_name :String) ->bool:
	return (char_name.length() <= char_max && char_name in char_map.keys())

#for CloseableWindowsArray processing------
func show():
	if !input_handler.reg_open(self):
		print("possible error! Scene_node already opened!")
	.show()

func hide():
	input_handler.reg_close(self)
	.hide()

func can_hide():
	return false
#--------------------


func dump_referals():
	print("Dump started!")
	var scene_name :String = ""
	var file_text :String = ""
	var out_path = "user://referals/"
	var file_handler = File.new()
	
	var dir_handler = Directory.new()
	if dir_handler.open("user://") != OK:
		print("can't open user folder")
		return
	if !dir_handler.dir_exists("referals"):
		dir_handler.make_dir("referals")
	
	for i in ref_src:
		if i.begins_with("**") && i.ends_with("**"):
			if !file_text.empty():
				file_handler.open(out_path + scene_name + ".txt", File.WRITE)
				file_handler.store_string(file_text)
				file_handler.close()
			file_text = i
			scene_name = i.replace("**", "").replace(" ", "")
			continue
		file_text += "\n"

		if i.begins_with("#"):
			file_text += i
			continue

		if i.begins_with("=") && i.ends_with("="):
			file_text += i
			continue

		if i.empty():
			continue

		var line_id = i
		if " - " in i:
			var splitted = i.split(" - ", true, 1)
			if is_char_name(splitted[0]):
				line_id = splitted[1]
		file_text += "%s - %s" % [i, tr(line_id)]
	#last file
	file_handler.open(out_path + scene_name + ".txt", File.WRITE)
	file_handler.store_string(file_text)
	file_handler.close()
	print('Dump finished! Look at user://referals')


#----------legacy code------------
#This func was intended to be used only once at _ready() with ref_src argument
#in order to add translation ids to all event files.
#It was used and now has no purpose. I'm leaving it here only for legacy reason,
#so to know how it was made at the time.
#func make_lines_translatable(lines: PoolStringArray):
#	var scene_name :String = ""
#	var string_name :String = ""
#	var string_count :int = 0
#	var file_text :String = ""
#	var dict_text :String = ""
#	var out_path = "user://out/"
#	var file_handler = File.new()
#	for i in lines:
#		if i.begins_with("**") && i.ends_with("**"):
#			if !file_text.empty():
#				file_handler.open(out_path + scene_name + ".txt", File.WRITE)
#				file_handler.store_string(file_text)
#				file_handler.close()
#			file_text = i
#			scene_name = i.replace("**", "").replace(" ", "")
#			string_name = "EV_%s_" % scene_name.to_upper()
#			string_count = 0
#			continue
#		file_text += "\n"
#
#		if i.begins_with("#"):
#			file_text += i
#			continue
#
#		if i.begins_with("=") && i.ends_with("="):
#			file_text += i
#			continue
#
#		if i.empty():
#			continue
#
#		var replica = i
#		if " - " in i:
#			var splitted = i.split(" - ", true, 1)
#			if is_char_name(splitted[0]):
#				replica = splitted[1]
#		var string_name_full = string_name + str(string_count)
#		dict_text += "%s = \"(говорит по-русски) %s\",\n" % [string_name_full, replica]
#
#		file_text += "%s & %s" % [i, string_name_full]
#		string_count += 1
#	#last file
#	file_handler.open(out_path + scene_name + ".txt", File.WRITE)
#	file_handler.store_string(file_text)
#	file_handler.close()
#	#dictionary
#	file_handler.open(out_path + "main.txt", File.WRITE)
#	file_handler.store_string(dict_text)
#	file_handler.close()

#This was used at _ready() to remove actual lines from events' files,
#to leave there only translation ids (actual lines are all in main.gd)
#func remove_lines():
#	var scene_name :String = ""
#	var file_text :String = ""
#	var out_path = "user://out/"
#	var file_handler = File.new()
#	for i in ref_src:
#		if i.begins_with("**") && i.ends_with("**"):
#			if !file_text.empty():
#				file_handler.open(out_path + scene_name + ".txt", File.WRITE)
#				file_handler.store_string(file_text)
#				file_handler.close()
#			file_text = i
#			scene_name = i.replace("**", "").replace(" ", "")
#			continue
#		file_text += "\n"
#
#		if i.begins_with("#"):
#			file_text += i
#			continue
#
#		if i.begins_with("=") && i.ends_with("="):
#			file_text += i
#			continue
#
#		if i.empty():
#			continue
#
#		var replica = i
#		var char_name = ""
#		if " - " in i:
#			var splitted = i.split(" - ", true, 1)
#			if is_char_name(splitted[0]):
#				char_name = splitted[0]
#				replica = splitted[1]
#		assert((" & " in replica), "inappropriate use of & in %s" % replica)
#		var splitted = replica.split(" & ")
#		assert(splitted.size() == 2, "inappropriate use of & in %s" % replica)
#		if !char_name.empty():
#			file_text += "%s - " % char_name
#		file_text += splitted[1]
#	#last file
#	file_handler.open(out_path + scene_name + ".txt", File.WRITE)
#	file_handler.store_string(file_text)
#	file_handler.close()

#This was used befor removal actual lines from events' files to make artificial main.gd for translation
#func dump_lines_for_translation():
#	print("Dump started!")
#	print('Mind that only \\" and \\n escape codes are supported by now')
#	var dict_text :String = ""
#	for i in ref_src:
#		if i.begins_with("**") && i.ends_with("**"):
#			continue
#
#		if i.begins_with("#"):
#			continue
#
#		if i.begins_with("=") && i.ends_with("="):
#			continue
#
#		if i.empty():
#			continue
#
#		var replica = i
#		if " - " in i:
#			var splitted = i.split(" - ", true, 1)
#			if is_char_name(splitted[0]):
#				replica = splitted[1]
#		assert((" & " in replica), "inappropriate use of & in %s" % replica)
#		var splitted = replica.split(" & ")
#		assert(splitted.size() == 2, "inappropriate use of & in %s" % replica)
#		dict_text += "\t%s = \"%s\",\n" % [splitted[1], escape_for_translation(splitted[0])]
#	#main
#	var main_trans = load(globals.TranslationData[globals.base_locale]).new().TranslationDict
#	var file_text :String = "extends Node\n\nvar TranslationDict = {\n"
#	for id in main_trans:
#		file_text += "\t%s = \"%s\",\n" % [id, escape_for_translation(main_trans[id])]#c_escape()
#	file_text += dict_text + "}"
#	#dump
#	var dir_handler = Directory.new()
#	if dir_handler.open("user://") != OK:
#		print("can't open user folder")
#		return
#	if !dir_handler.dir_exists("translation"):
#		dir_handler.make_dir("translation")
#	var file_handler = File.new()
#	file_handler.open("user://translation/main.gd", File.WRITE)
#	file_handler.store_string(file_text)
#	file_handler.close()
#	print('Dump finished! Look at user://translation')
#
#func escape_for_translation(input_line :String) ->String:
#	var line = input_line.replace("\n", "\\n")
#	line = line.replace('\"', '\\"')
#	return line
