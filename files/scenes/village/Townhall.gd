extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedworker
var selectedupgrade

var binded_events = {}
onready var charpanel = $UpcomingEvents/ScrollContainer/HBoxContainer

func _ready():
	input_handler.connect("EventFinished", self, "build_events")
	#$ButtonPanel/VBoxContainer/Tasks.connect("pressed",self,'tasklist')
#warning-ignore:return_value_discarded
	$ButtonPanel/VBoxContainer/Upgrades.connect('pressed', self, 'upgradelist')
#warning-ignore:return_value_discarded
	$UpgradeDescript/UnlockButton.connect("pressed", self, 'unlockupgrade')
#warning-ignore:return_value_discarded
#	$ButtonPanel/VBoxContainer/Food.connect('pressed', $FoodConvert, "open")
#warning-ignore:return_value_discarded
	$ButtonPanel/VBoxContainer/Quests.connect("pressed", $Questlog, 'open')
	$ButtonPanel/VBoxContainer/Scenes.connect("pressed", $scenes, "open")
	#globals.AddPanelOpenCloseAnimation($TaskList)
	globals.AddPanelOpenCloseAnimation($UpgradeList)
	globals.AddPanelOpenCloseAnimation($UpgradeDescript)
	
	binded_events.clear()
#	visible = false
#	if resources.is_busy(): yield(resources, "done_work")
#	open()
	
	#very ugly patch. As ugly as very idea to instantiate "closebutton" after everything else in ClosingPanel.gd
	#the purpose is to prevent closebutton from been visible in "scenes" screen
	move_child(closebutton, closebutton.get_index()-1)
	
	TutorialCore.register_static_button("town_upgrade",
		$ButtonPanel/VBoxContainer/Upgrades, 'pressed')
	TutorialCore.register_dynamic_button("townhall_event",
		self, 'pressed')

func get_tutorial_button(button_name :String):
	if button_name == 'townhall_event':
		return charpanel.get_child(0)


func open():
	show()
	if $UpgradeDescript.visible:
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
	.hide();

#func selecttaskfromlist(task):
#	$SelectWorker.OpenSelectTab(task)

func upgradelist():
	$UpgradeList.show()
	$UpgradeDescript.hide()
	input_handler.ClearContainer($UpgradeList/ScrollContainer/VBoxContainer)
	var array = []
	for i in Upgradedata.upgradelist.values():
		array.append(i)
	
	array.sort_custom(self, 'sortupgrades')
	
	for i in array:
		var next_level = findupgradelevel(i)
		var has_next_level = i.levels.has(next_level)
		var text = tr(i.name)
		if next_level > 1 && has_next_level:
			text += ": " + str(next_level)
	
		var newbutton = input_handler.DuplicateContainerTemplate($UpgradeList/ScrollContainer/VBoxContainer)
		if !has_next_level:
			newbutton.get_node("name").set("custom_colors/font_color", Color(0,0.6,0))
			text += ' Unlocked'
			newbutton.get_node("icon").texture = i.levels[next_level-1].icon
		else:
			newbutton.get_node("icon").texture = i.levels[next_level].icon
		newbutton.get_node("name").text = text
		newbutton.connect("pressed", self, "selectupgrade", [i])


func sortupgrades(first, second):
	if first.levels.has(findupgradelevel(first)) && second.levels.has(findupgradelevel(second)):
		if first.positionorder < second.positionorder:
			return true
		else:
			return false
	elif first.levels.has(findupgradelevel(first)):
		return true
	else:
		return false


func selectupgrade(upgrade):
	selectedupgrade = upgrade
	$UpgradeDescript.show()
	update_upgrade()


func update_upgrade():
	var upgrade = selectedupgrade
	var text = tr(upgrade.descript)
	$UpgradeDescript/Label.text = tr(upgrade.name)
	
	input_handler.ClearContainer($UpgradeDescript/HBoxContainer)
	
	var next_level = findupgradelevel(upgrade)
	
	if next_level > 1:
			text += '\n\n' + tr("UPGRADEPREVBONUS") + ': ' + tr(upgrade.levels[next_level-1].bonusdescript)
	
	var canpurchase = true
	
	if upgrade.levels.has(next_level):
		text += '\n\n' + tr("UPGRADENEXTBONUS") + ': ' + tr(upgrade.levels[next_level].bonusdescript)
		if upgrade.levels[next_level].has("unlockable_by_script"):
			canpurchase = false
	
		for i in upgrade.levels[next_level].cost:
			if i != 'gold':
				var item = Items.Items[i]
				var newnode = input_handler.DuplicateContainerTemplate($UpgradeDescript/HBoxContainer)
				newnode.get_node("icon").texture = item.icon
				newnode.get_node("Label").text = str(upgrade.levels[next_level].cost[i]) + "/" + str(state.materials[i])
				globals.connectmaterialtooltip(newnode, item)
				if state.materials[i] >= upgrade.levels[next_level].cost[i]:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0,0.6,0))
				else:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0.6,0,0))
					canpurchase = false
			else:
				var newnode = input_handler.DuplicateContainerTemplate($UpgradeDescript/HBoxContainer)
				newnode.get_node("icon").texture = Items.gold_icon
				newnode.get_node("Label").text = str(upgrade.levels[next_level].cost[i])
				if state.money >= upgrade.levels[next_level].cost[i]:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0,0.6,0))
				else:
					newnode.get_node('Label').set("custom_colors/font_color", Color(0.6,0,0))
					canpurchase = false
	else:
		canpurchase = false

	$UpgradeDescript/RichTextLabel.bbcode_text = text
	$UpgradeDescript/UnlockButton.visible = canpurchase
	$UpgradeDescript/goldicon/Label.text = String(state.money)
	$UpgradeDescript/goldicon.visible = canpurchase


func findupgradelevel(upgrade):
	var rval = 1
	if state.townupgrades.has(upgrade.code):
		rval += state.townupgrades[upgrade.code]
	return rval


func unlockupgrade():
	var upgrade = selectedupgrade
	var next_level = findupgradelevel(upgrade)
	for i in upgrade.levels[next_level].cost:
		if i == 'gold':
			state.add_money(-upgrade.levels[next_level].cost[i], false)
		else:
			state.materials[i] -= upgrade.levels[next_level].cost[i]
	
	if state.townupgrades.has(upgrade.code):
		state.townupgrades[upgrade.code] += 1
	else:
		state.townupgrades[upgrade.code] = 1
	
	input_handler.SystemMessage(tr("UPGRADEUNLOCKED") + ": " + tr(upgrade.name))
	upgradelist()
	if upgrade.has('effects_hp'):
		for ch in state.heroes.values():
			ch.hp = ch.get_stat('hpmax')
	if get_parent().has_node(upgrade.townnode):
		get_parent().get_node(upgrade.townnode).build_icon()
	
	#animation
	if upgrade.levels[next_level].has("animatebuilding"):
		var animnode
		if get_parent().has_node(upgrade.townnode):
			animnode = get_parent().get_node(upgrade.townnode)
		else:
			animnode = get_parent().get_node("Background/"+upgrade.townnode)
		if animnode != null:
			self.modulate.a = 0
			animnode.show()
			input_handler.ShowOutline(animnode)
			input_handler.UnfadeAnimation(animnode, 2.5, 0)
			input_handler.PlaySound("building")
			yield(get_tree().create_timer(3.0), 'timeout')
			self.modulate.a = 1
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
