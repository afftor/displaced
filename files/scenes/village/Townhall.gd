extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedworker
var selectedupgrade

var binded_events = {}
onready var charpanel = $UpcomingEvents/ScrollContainer/HBoxContainer
onready var upgrade_list = $UpgradeList/ScrollContainer/VBoxContainer
onready var upgrade_desc = $UpgradeList/UpgradeDescript

var building_sound = "sound/building"

func _ready():
	input_handler.queue_connection("scene_node", "EventFinished", self, "build_events")
	#$ButtonPanel/VBoxContainer/Tasks.connect("pressed",self,'tasklist')
#warning-ignore:return_value_discarded
	$ButtonPanel/VBoxContainer/Upgrades.connect('pressed', self, 'upgradelist')
#warning-ignore:return_value_discarded
	upgrade_desc.get_node('UnlockButton').connect("pressed", self, 'unlockupgrade')
	upgrade_desc.get_node('CloseButton').connect("pressed", upgrade_desc, 'hide')
#warning-ignore:return_value_discarded
#	$ButtonPanel/VBoxContainer/Food.connect('pressed', $FoodConvert, "open")
#warning-ignore:return_value_discarded
	$ButtonPanel/VBoxContainer/Quests.connect("pressed", $Questlog, 'open')
	if globals.is_steam_type():
		$ButtonPanel/VBoxContainer/Scenes.hide()
	else:
		$ButtonPanel/VBoxContainer/Scenes.connect("pressed", $scenes, "open")
	#globals.AddPanelOpenCloseAnimation($TaskList)
	globals.AddPanelOpenCloseAnimation($UpgradeList)
	binded_events.clear()
#	visible = false
#	if resources.is_busy(): yield(resources, "done_work")
#	open()
	
	#very ugly patch. As ugly as very idea to instantiate "closebutton" after everything else in ClosingPanel.gd
	#the purpose is to prevent closebutton from been visible in "scenes" screen
	move_child(closebutton, closebutton.get_index()-1)
	
	TutorialCore.register_static_button("town_upgrade",
		$ButtonPanel/VBoxContainer/Upgrades, 'pressed')
	TutorialCore.register_static_button("unlock_upgrade",
		upgrade_desc.get_node('UnlockButton'), 'pressed')
	TutorialCore.register_dynamic_button("townhall_event",
		self, 'pressed')
	TutorialCore.register_dynamic_button("forge_upgrade",
		self, 'pressed')
	
	resources.preload_res(building_sound)
	if resources.is_busy(): yield(resources, "done_work")

func get_tutorial_button(button_name :String):
	if button_name == 'townhall_event':
		return charpanel.get_child(0)
	elif button_name == 'forge_upgrade':
		#it's presumed, that forge is at the beginning of the list
		$UpgradeList/ScrollContainer.scroll_vertical = 0#quite rough, but better than make whole new tutorial scenario for this
		for btn in upgrade_list.get_children():
			if btn.has_meta("upgrade_code") and btn.get_meta("upgrade_code") == 'forge':
				return btn
		return null#button not ready


func open():
	show()
	if upgrade_desc.visible:
		update_upgrade()

func show():
	update_events_panel()
	state.CurBuild = 'TownHall';
	input_handler.menu_node.visible = false
#	globals.check_signal("BuildingEntered", 'TownHall')
	.show();

func hide():
	state.CurBuild = "";
	input_handler.menu_node.visible = true
	$UpgradeList.hide()
	$scenes.hide()
	.hide();

#func selecttaskfromlist(task):
#	$SelectWorker.OpenSelectTab(task)

func upgradelist():
	input_handler.ClearContainer(upgrade_list)
	var array = []
	for i in Upgradedata.upgradelist:
		array.append(i)
	
	array.sort_custom(self, 'sortupgrades')
	
	for i in array:
		var upgrade = Upgradedata.upgradelist[i]
		var next_level = findupgradelevel(upgrade)
		var has_next_level = upgrade.levels.has(next_level)
		var text = tr(upgrade.name)
		if next_level > 1 && has_next_level:
			text += ": " + str(next_level)
	
		var newbutton = input_handler.DuplicateContainerTemplate(upgrade_list)
		newbutton.set_meta("upgrade_code", i)
		if !has_next_level:
			newbutton.get_node("name").set("custom_colors/font_color", Color(0,0.6,0))
			text += ' ' + tr("UP_UNLOCKED")
			newbutton.get_node("icon").texture = upgrade.levels[next_level-1].icon
		else:
			newbutton.get_node("icon").texture = upgrade.levels[next_level].icon
		newbutton.get_node("name").text = text
		newbutton.connect("pressed", self, "selectupgrade", [i])
	
	$UpgradeList.show()
	if selectedupgrade == null:
		upgrade_desc.hide()
	elif upgrade_desc.visible:
		update_upgrade()


func sortupgrades(first_code, second_code):
	var first = Upgradedata.upgradelist[first_code]
	var second = Upgradedata.upgradelist[second_code]
	if first.levels.has(findupgradelevel(first)) && second.levels.has(findupgradelevel(second)):
		if first.positionorder < second.positionorder:
			return true
		else:
			return false
	elif first.levels.has(findupgradelevel(first)):
		return true
	else:
		return false


func selectupgrade(upgrade_code):
	selectedupgrade = upgrade_code
	upgrade_desc.show()
	update_upgrade()


func update_upgrade():
	var upgrade = Upgradedata.upgradelist[selectedupgrade]
	var text = tr(upgrade.descript)
	upgrade_desc.get_node('Label').text = tr(upgrade.name)
	
	input_handler.ClearContainer(upgrade_desc.get_node('HBoxContainer'))
	
	var next_level = findupgradelevel(upgrade)
	
	if next_level > 1:
		text += "\n\n%s: %s" % [
			tr("UPGRADEPREVBONUS"),
			Upgradedata.get_refined_bonusdescript(selectedupgrade, next_level-1)
		]
	
	var canpurchase = true
	
	if upgrade.levels.has(next_level):
		var level_info = upgrade.levels[next_level]
		var bonusdescript = Upgradedata.get_refined_bonusdescript(selectedupgrade, next_level)
		text += '\n\n' + tr("UPGRADENEXTBONUS") + ': ' + bonusdescript
		if level_info.has("unlock_reqs") and !state.checkreqs(level_info.unlock_reqs):
			canpurchase = false
		upgrade_desc.get_node('goldicon').visible = true
	
		for i in level_info.cost:
			var newnode = input_handler.DuplicateContainerTemplate(upgrade_desc.get_node('HBoxContainer'))
			if i != 'gold':
				var item = Items.Items[i]
				newnode.get_node("icon").texture = item.icon
				newnode.get_node("Label").text = str(level_info.cost[i]) + "/" + str(state.materials[i])
				globals.connectmaterialtooltip(newnode, item)
				if state.materials[i] >= level_info.cost[i]:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0,0.6,0))
				else:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0.6,0,0))
					canpurchase = false
			else:
				newnode.get_node("icon").texture = Items.gold_info.icon
				newnode.get_node("Label").text = str(level_info.cost[i])
				globals.connectmaterialtooltip(newnode, Items.gold_info)
				if state.money >= level_info.cost[i]:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0,0.6,0))
				else:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0.6,0,0))
					canpurchase = false
	else:
		canpurchase = false
		upgrade_desc.get_node('goldicon').visible = false

	upgrade_desc.get_node('RichTextLabel').bbcode_text = text
	upgrade_desc.get_node('UnlockButton').visible = canpurchase
	upgrade_desc.get_node('goldicon/Label').text = String(state.money)


func findupgradelevel(upgrade):
	var rval = 1
	if state.townupgrades.has(upgrade.code):
		rval += state.townupgrades[upgrade.code]
	return rval


func unlockupgrade():
	var upgrade = Upgradedata.upgradelist[selectedupgrade]
	var next_level = findupgradelevel(upgrade)
	for i in upgrade.levels[next_level].cost:
		if i == 'gold':
			state.add_money(-upgrade.levels[next_level].cost[i], false)
		else:
			state.add_materials(i, -upgrade.levels[next_level].cost[i])
	
	if state.townupgrades.has(upgrade.code):
		state.townupgrades[upgrade.code] += 1
	else:
		state.townupgrades[upgrade.code] = 1
	
#	input_handler.SystemMessage(tr("UPGRADEUNLOCKED") + ": " + tr(upgrade.name))
	upgradelist()
	if upgrade.has('effects_hp'):
		for ch in state.heroes.values():
			ch.hp = ch.get_stat('hpmax')
	var building = get_parent().get_building(upgrade.townnode)
	if building != null:
		building.build_icon()
	
	#animation
	var animnode = building
	#there is no background buildings for now
#	if animnode != null:
#		animnode = get_parent().get_building_bg(upgrade.townnode)
	if animnode != null:
		var building_timer = 2.0
		input_handler.ShowOutline(animnode)
		self.modulate.a = 0
		input_handler.block_screen()
		if upgrade.levels[next_level].has("animatebuilding"):
			building_timer = 3.0
			animnode.show()
			input_handler.UnfadeAnimation(animnode, 2.5, 0)
		input_handler.PlaySound(building_sound)
		yield(get_tree().create_timer(building_timer), 'timeout')
		self.modulate.a = 1
		input_handler.unblock_screen()
		input_handler.HideOutline(animnode)
#	globals.check_signal("UpgradeUnlocked", upgrade)
#	globals.EventCheck()
	#state.townupgrades[upgrade.code] = true


func build_events():
	var res = false
	binded_events.clear()
	for ch in Explorationdata.characters:
		for seq in Explorationdata.characters[ch]:
			if state.check_sequence(seq):
				binded_events[ch] = seq
				res = true
				break
	
	if visible :
		update_events_panel()
	
	return res

func update_events_panel():
	$UpcomingEvents.visible = false
	input_handler.ClearContainer(charpanel, ['portrait'])
	for ch in binded_events:
		if binded_events[ch] == null: continue
		$UpcomingEvents.visible = true
		var panel = input_handler.DuplicateContainerTemplate(charpanel, 'portrait')
		panel.connect("pressed", self, "run_seq", [ch])
		var tex = resources.get_res("portrait/%s" % input_handler.scene_node.char_map[ch].portrait)
		panel.texture_normal = tex

func run_seq(ch):
	globals.run_seq(binded_events[ch])
