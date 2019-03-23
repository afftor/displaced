	extends "res://files/Close Panel Button/ClosingPanel.gd"

var selectedworker
var selectedupgrade

func _ready():
	#$ButtonPanel/VBoxContainer/Tasks.connect("pressed",self,'tasklist')
	$ButtonPanel/VBoxContainer/Upgrades.connect('pressed', self, 'upgradelist')
	$UpgradeDescript/UnlockButton.connect("pressed", self, 'unlockupgrade')
	$ButtonPanel/VBoxContainer/Food.connect('pressed', $FoodConvert, "open")
	$ButtonPanel/VBoxContainer/Quests.connect("pressed", $Questlog, 'open')
	#globals.AddPanelOpenCloseAnimation($TaskList)
	globals.AddPanelOpenCloseAnimation($UpgradeList)
	globals.AddPanelOpenCloseAnimation($UpgradeDescript)


func open():
	show()

func show():
	state.CurBuild = 'TownHall';
	input_handler.emit_signal("BuildingEntered", 'TownHall')
	.show();

func hide():
		state.CurBuild = "";
		.hide();

#func selecttaskfromlist(task):
#	$SelectWorker.OpenSelectTab(task)

func upgradelist():
	$UpgradeList.show()
	$UpgradeDescript.hide()
	globals.ClearContainer($UpgradeList/ScrollContainer/VBoxContainer)
	var array = []
	for i in globals.upgradelist.values():
		array.append(i)
	
	array.sort_custom(self, 'sortupgrades')
	
	for i in array:
		var currentupgradelevel = findupgradelevel(i)
		
		var check = true
		if i.levels.has(currentupgradelevel):
			for k in i.levels[currentupgradelevel].unlockreqs:
				if state.valuecheck(k) == false:
					check = false
		if check == false:
			continue
		
		var text = i.name
		
		if currentupgradelevel > 1 && i.levels.has(currentupgradelevel):
			text += ": " + str(currentupgradelevel)
		
		
		var newbutton = globals.DuplicateContainerTemplate($UpgradeList/ScrollContainer/VBoxContainer)
		if i.levels.has(currentupgradelevel) == false:
			newbutton.get_node("name").set("custom_colors/font_color", Color(0,0.6,0))
			text += ' Unlocked'
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
	var text = upgrade.descript
	selectedupgrade = upgrade
	$UpgradeDescript.show()
	$UpgradeDescript/Label.text = upgrade.name
	
	
	
	globals.ClearContainer($UpgradeDescript/HBoxContainer)
	
	var currentupgradelevel = findupgradelevel(upgrade)
	
	
	if currentupgradelevel > 1:
			text += '\n\n' + tr("UPGRADEPREVBONUS") + ': ' + upgrade.levels[currentupgradelevel-1].bonusdescript
	
	var canpurchase = true
	
	if upgrade.levels.has(currentupgradelevel):
		text += '\n\n' + tr("UPGRADENEXTBONUS") + ': ' + upgrade.levels[currentupgradelevel].bonusdescript
		
		for i in upgrade.levels[currentupgradelevel].cost:
			var item = Items.Materials[i]
			var newnode = globals.DuplicateContainerTemplate($UpgradeDescript/HBoxContainer)
			newnode.get_node("icon").texture = item.icon
			newnode.get_node("Label").text = str(state.materials[i]) + "/"+ str(upgrade.levels[currentupgradelevel].cost[i])
			globals.connectmaterialtooltip(newnode, item)
			if state.materials[i] >= upgrade.levels[currentupgradelevel].cost[i]:
				newnode.get_node('Label').set("custom_colors/font_color", Color(0,0.6,0))
			else:
				newnode.get_node('Label').set("custom_colors/font_color", Color(0.6,0,0))
				canpurchase = false
	else:
		canpurchase = false
	
	$UpgradeDescript/RichTextLabel.bbcode_text = text
	$UpgradeDescript/UnlockButton.visible = canpurchase

func findupgradelevel(upgrade):
	var rval = 1
	if state.townupgrades.has(upgrade.code):
		rval += state.townupgrades[upgrade.code]
	return rval

func unlockupgrade():
	var upgrade = selectedupgrade
	var currentupgradelevel = findupgradelevel(upgrade)
	for i in upgrade.levels[currentupgradelevel].cost:
		state.materials[i] -= upgrade.levels[currentupgradelevel].cost[i]
	
	if state.townupgrades.has(upgrade.code):
		state.townupgrades[upgrade.code] += 1
	else:
		state.townupgrades[upgrade.code] = 1
	input_handler.SystemMessage(tr("UPGRADEUNLOCKED") + ": " + upgrade.name)
	input_handler.emit_signal("UpgradeUnlocked", upgrade)
	upgradelist()
	#state.townupgrades[upgrade.code] = true

