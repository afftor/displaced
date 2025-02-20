extends "res://files/Close Panel Button/ClosingPanel.gd"

signal scene_pannel_drawn(scene_id)
signal was_open


onready var charlist = $Panel/heroes/HBoxContainer
onready var scenelist = $Panel/scenes/GridContainer

var selected_char
const char_sprites = {
	rose = 'rose',
	ember = 'emberhappy',
	erika = 'erika',
	iola = 'iola',
	rilu = 'rilu'
}
var btn_list = ['rose', 'ember', 'erika', 'iola']#'rilu' added in _ready()


export var test_mode = false

func RepositionCloseButton():
	pass#no reposition

func _ready():
	if input_handler.scene_node == null and test_mode:
		input_handler.initiate_scennode(self)
	$close.connect("pressed", self, 'hide')
	for ch in charlist.get_children():
		var cid = ch.name.to_lower()
		ch.set_meta('hero', cid)
		ch.connect('pressed', self, 'select_hero', [cid])
		if char_sprites.has(cid): resources.preload_res("animated_sprite/%s" % char_sprites[cid])
	#move it to open(), if button would appear where shouldn't
	if globals.is_riluless_type():
		charlist.get_node('rilu').hide()
	else:
		btn_list.append('rilu')
	
	if test_mode:
		testmode()
		if resources.is_busy(): yield(resources, "done_work")
		open()

func testmode():
	for cid in state.characters:
		state.unlock_char(cid)
	
#	var tscene = load("res://files/TextSceneNew/TextSystem.tscn")
#	var tnode = tscene.instance()
#	input_handler.scene_node = tnode #will be set on add_child anyway
#	tnode.hide()
#	add_child(tnode)


func open():
	#MIND that such simplified conditions works only while gallery is all nude!
	if globals.is_boring_type(): return
	
	var def_char = null
	for ch_id in btn_list:
		var ch = charlist.get_node(ch_id)
		if state.heroes[ch_id].unlocked:
			ch.visible = true
			if selected_char == ch_id or def_char == null:
				def_char = ch_id
		else:
			ch.visible = false
	select_hero(def_char)
	show()
	emit_signal("was_open")


func select_hero(cid):
	for ch in charlist.get_children():
		ch.pressed = (ch.get_meta('hero') == cid)
	if cid == selected_char:
		rebuild_scene_list()
		return
	
	selected_char = cid
	rebuild_scene_list()
	var sprite_bound = $panel_hero/hero/boundaries
	if sprite_bound.get_child_count() > 0:
		sprite_bound.get_child(0).queue_free()
	if selected_char != 'all': #simple sprite setup. tell me if animated sprite is needed
		var tmp = resources.get_res("animated_sprite/%s" % char_sprites[selected_char]).instance()
		sprite_bound.add_child(tmp)
		tmp.set_anchors_and_margins_preset(PRESET_WIDE)


func rebuild_scene_list():
	var available_scenes = _get_scenes_to_show()
	input_handler.ClearContainer(scenelist, ['Button'])
	for scene_id in available_scenes:
		var scene_data = available_scenes[scene_id]

		var is_unlocked = state.OldSeqs.has(scene_id) or globals.opened_gallery
		var is_unlockable = scene_data.has("initiate_reqs") and state.checkreqs(scene_data.initiate_reqs)


		var panel = input_handler.DuplicateContainerTemplate(scenelist, 'Button')
		if is_unlocked:
			panel.set_unlocked(scene_data)
			panel.connect('show_pressed', self, 'show_event', [scene_id])
		elif is_unlockable:#If not unlocked yet but unlockable
			panel.set_unlockable(scene_data)
			panel.connect('unlocked_pressed', self, 'unlock_show_event', [scene_id])
			panel.set_highlighted(scene_id in state.pending_scenes)
		else: 
			panel.set_unknown()
		
		emit_signal("scene_pannel_drawn", scene_id)
	
func _get_scenes_to_show() -> Dictionary:
	var id_and_scene_data = {}

	for scene_id in Explorationdata.scene_sequences:
		var scene_data = Explorationdata.scene_sequences[scene_id]
		if !scene_data.has('gallery'): continue
		if scene_data.has('permit_reqs') and !state.checkreqs(scene_data.permit_reqs): continue

		var scene_characters = scene_data.unlock_price.keys()
		if selected_char != 'all' and !(selected_char in scene_characters): continue

		if !globals.opened_gallery:
			var character_locked = false
			for chartater in scene_characters:
				if !state.heroes[chartater].unlocked:
					character_locked = true
					break
			if character_locked: continue
		
		
		id_and_scene_data[scene_id] = scene_data

	return id_and_scene_data

func show_event(ev):
	#Just keep in mind, that opened_gallery as param here, being "true", can break logic for
	#sequences, as they would be treated as "already seen", wich they don't,
	#and still will be added to OldSeqs. It will work here just fine only because
	#in gallery sequences there is no crucial logic to break at this point.
	globals.run_seq(ev, globals.opened_gallery)
#	input_handler.OpenClose(input_handler.scene_node)
#	input_handler.scene_node.play_scene(ev)


func unlock_show_event(ev):
	var eventdata = Explorationdata.scene_sequences[ev]
	for ch in eventdata.unlock_price:
		var hero = state.heroes[ch]
		hero.friend_points -= eventdata.unlock_price[ch]
	show_event(ev)
	yield(input_handler.scene_node, "AllEventsFinished")
	rebuild_scene_list()
