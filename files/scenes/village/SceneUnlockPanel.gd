extends Control

onready var charlist = $Panel/ScrollContainer/HBoxContainer
onready var scenelist = $Panel/Panel/ScrollContainer/GridContainer

var selected_char


export var test_mode = false

func _ready():
	#hide()
	if input_handler.scene_node == null and test_mode:
		input_handler.initiate_scennode(self)
	$Panel/Panel/close.connect("pressed", self, 'hide')
	for ch in charlist.get_children():
		var cid = ch.name.to_lower()
		ch.set_meta('hero', cid)
		ch.connect('pressed', self, 'select_hero', [cid])
		if cid != 'all': resources.preload_res("sprite/%s" % cid)
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
	TutorialCore.check_event("scene_unlock_open")
	var def_char = null
	var f_group = false
	for ch_id in ['rose', 'ember', 'erika', 'iola', 'rilu']:
		var ch = charlist.get_node(ch_id)
		if state.heroes[ch_id].unlocked:
			ch.visible = true
			if def_char == null:
				def_char = ch_id
			else:
				f_group = true
		else:
			ch.visible = false
	for ch_id in ['all', 'group']:
		var ch = charlist.get_node(ch_id)
		ch.visible = f_group
#	for ch in charlist.get_children():
#		var cid = ch.name.to_lower()
#		if cid != "all" and cid != 'group':
#			ch.visible = (state.heroes[cid].unlocked)
	select_hero(def_char)
	input_handler.UnfadeAnimation(self)
	show()


func select_hero(cid):
	if !TutorialCore.check_action("scenes_select_hero", [cid]): return
	if cid == selected_char: return
	selected_char = cid
	for ch in charlist.get_children():
		ch.pressed = (ch.get_meta('hero') == cid)
	rebuild_scene_list()
	if selected_char != 'all' and selected_char != 'group': #simple sprite setup. tell me if animated sprite is needed
		var tmp = resources.get_res("sprite/%s" % selected_char) 
		$TextureRect.texture = tmp
	else:
		$TextureRect.texture = null
	TutorialCore.check_event("scenes_select_hero", cid)


func rebuild_scene_list():
	input_handler.ClearContainer(scenelist, ['Button', 'Button2', 'Button3'])
#	for event in events.events:
	for event in Explorationdata.scene_sequences:
#		var eventdata = events.events[event]
		var eventdata = Explorationdata.scene_sequences[event]
		if !eventdata.has('category'): continue
#		if eventdata.cost.empty(): continue
		if selected_char != 'all' and eventdata.category != selected_char: continue
#		if state.gallery_event_unlocks.has(event):
#			var panel = input_handler.DuplicateContainerTemplate(scenelist, 'Button')
#			panel.get_node('Image').texture = resources.get_res(eventdata.icon)
#			panel.get_node('Label').text = "{name}\n{description}".format(eventdata)
#			panel.connect('pressed', self, 'show_event', [event])
#			continue
		if state.OldSeqs.has(event):
			var panel = input_handler.DuplicateContainerTemplate(scenelist, 'Button')
			if eventdata.has('icon'):
				panel.get_node('Image').texture = resources.get_res(eventdata.icon)
			panel.get_node('Label').text = "{name}\n{descript}".format(eventdata)
			panel.connect('pressed', self, 'show_event', [event])
			continue
#		if state.OldEvents.has(event): #shown and not unlocked == not unknown
#			var panel = input_handler.DuplicateContainerTemplate(scenelist, 'Button2')
#			var can_unlock = true
#			panel.get_node('Image').texture = resources.get_res(eventdata.icon)
#			panel.get_node('Label').text = "{name}\n{description}".format(eventdata)
#			var cost_con = panel.get_node('HBoxContainer')
#			input_handler.ClearContainer(cost_con, ['Label'])
#			for ch in eventdata.cost:
#				var hero = state.heroes[ch]
#				var panel1 = input_handler.DuplicateContainerTemplate(cost_con, 'Label')
#				panel1.get_node('TextureRect').texture = ch.portrait()
#				panel1.text = "%d/%d" % [eventdata.cost[ch], hero.friend_points]
#				if eventdata.cost[ch] > hero.friend_points:
#					panel1.set("custom_colors/font_color", variables.hexcolordict.red)
#					can_unlock = false
#			if can_unlock:
#				panel.get_node('Button').disabled = false
#				panel.get_node('Button').connect('pressed', self, 'unlock_show_event', [event])
#			else:
#				panel.get_node('Button').disabled = true
#			continue
		if eventdata.has("initiate_reqs") and state.checkreqs(eventdata.initiate_reqs): #not shown but unlockable
			var panel = input_handler.DuplicateContainerTemplate(scenelist, 'Button2')
			var can_unlock = true
#			panel.get_node('Image').texture = resources.get_res(eventdata.icon)
			panel.get_node('Label').text = "{name}\n{descript}".format(eventdata)
			var cost_con = panel.get_node('HBoxContainer')
			input_handler.ClearContainer(cost_con, ['Label'])
			for ch in eventdata.unlock_price:
				var hero = state.heroes[ch]
				var panel1 = input_handler.DuplicateContainerTemplate(cost_con, 'Label')
				panel1.get_node('TextureRect').texture = hero.portrait()
				panel1.text = "%d/%d" % [eventdata.unlock_price[ch], hero.friend_points]
				if eventdata.unlock_price[ch] > hero.friend_points:
					panel1.set("custom_colors/font_color", variables.hexcolordict.red)
					can_unlock = false
			if can_unlock:
				panel.get_node('Button').disabled = false
				panel.get_node('Button').connect('pressed', self, 'unlock_show_event', [event])
			else:
				panel.get_node('Button').disabled = true
			continue
		#unknown and locked - default
		var panel = input_handler.DuplicateContainerTemplate(scenelist, 'Button3')


func show_event(ev):
	globals.run_seq(ev, true)
#	input_handler.OpenClose(input_handler.scene_node)
#	input_handler.scene_node.replay_mode = true
#	input_handler.scene_node.play_scene(ev)


func unlock_show_event(ev):
	if !TutorialCore.check_action("scenes_unlock_scene", [ev]): return
	var eventdata = Explorationdata.scene_sequences[ev]
	for ch in eventdata.unlock_price:
		var hero = state.heroes[ch]
		hero.friend_points -= eventdata.unlock_price[ch]
	show_event(ev)
	rebuild_scene_list()
	TutorialCore.check_event("scenes_unlock_scene", ev)
