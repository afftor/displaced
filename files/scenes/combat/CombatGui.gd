extends Control

onready var combat = get_parent()

onready var utility_bar = $SkillPanel/UtilityContainer
onready var active_panel = $ActiveActionPanel

var show_log = false

func _ready():
	utility_bar.get_node("Escape").connect("pressed", combat, "run")
	$SkillPanel/CategoriesContainer/SkillsButton.connect('pressed', self, "RebuildSkillPanel")
	$SkillPanel/CategoriesContainer/ItemsButton.connect('pressed', self, "RebuildItemPanel")
	$Combatlog.connect("pressed", self, 'set_log')
	set_log(false)
	bind_hero_panels()

func combat_start():
	clear_log()
	set_log(false)

#panels
func get_hero_panel(hero_id):
	return get_node("PlayerStats/VBoxContainer/%s" % hero_id)


func get_enemy_panel(pos):
	pos -= 4
	var r = pos / 3
	var l = pos % 3
	return get_node("EmemyStats/VBoxContainer").get_child(l * 2 + r)


func bind_hero_panels():
	for ch in state.characters:
		var node = get_hero_panel(ch)
		node.connect('pressed', self, 'ShowFighterStats', [ch])


func ShowFighterStats(fighter):
	var node = input_handler.get_spec_node(input_handler.NODE_SLAVEPANEL)
	node.open(state.heroes[fighter], true)


func build_hero_panels():
	var ch_order = []
	for pos in range(1, 4):
		var ch = combat.battlefield[pos]
		if ch == null: continue
		ch_order.push_back(ch.id)
	for ch in state.characters:
		if ch_order.has(ch): continue
		ch_order.push_back(ch)
	for i in range(ch_order.size()):
		var ch = ch_order[i]
		var node = get_hero_panel(ch)
		$PlayerStats/VBoxContainer.move_child(node, i)
		var hero = state.heroes[ch]
		node.visible = hero.unlocked
		if hero.position != null:
			node.modulate = Color(1,1,1,1)
		else:
			node.modulate = Color(1,1,1,0.4)


func build_enemy_panels():
	for pos in range(4, 10):
		var node = get_enemy_panel(pos)
		node.connect("mouse_exited", self, "HideEnemyTooltip")
		var ch = combat.battlefield[pos]
		if ch == null:
			node.modulate = Color(1,1,1,0.4)
			node.disabled = true
			for n in node.get_children():
				n.visible = false
			if node.is_connected("mouse_entered", self, "ShowEnemyTooltip"):
				node.disconnect("mouse_entered", self, "ShowEnemyTooltip")
		else:
			node.disabled = false
			node.modulate = Color(1,1,1,1)
			for n in node.get_children():
				n.visible = true
			if node.is_connected("mouse_entered", self, "ShowEnemyTooltip"):
				node.disconnect("mouse_entered", self, "ShowEnemyTooltip")
			node.connect("mouse_entered", self, "ShowEnemyTooltip", [ch, node])

#2do, 
func ShowEnemyTooltip(fighter, node):
	pass

func HideEnemyTooltip():
	pass

#skill panel
func ClearSkillPanel():
	input_handler.ClearContainer($SkillPanel/SkillContainer)


func RebuildSkillPanel():
	if !combat.allowaction: return
	var activecharacter = combat.activecharacter
	ClearSkillPanel()
	for i in activecharacter.skills:
		if i in ['attack', 'defence']: continue
		var newbutton = input_handler.DuplicateContainerTemplate($SkillPanel/SkillContainer)
		var skill = Skillsdata.patch_skill(i, activecharacter)
		newbutton.get_node("TextureRect").texture = skill.icon
		newbutton.get_node("Cooldown").text = ""
		if skill.tags.has('disabled'):
			newbutton.disabled = true
			newbutton.get_node("TextureRect").material = load("res://assets/sfx/bw_shader.tres")
		if activecharacter.cooldowns.has(i):
			newbutton.disabled = true
			newbutton.get_node("Cooldown").text = str(activecharacter.cooldowns[i])
			newbutton.get_node("TextureRect").material = load("res://assets/sfx/bw_shader.tres")
		if !activecharacter.process_check(skill.reqs):
			newbutton.disabled = true
			newbutton.get_node("TextureRect").material = load("res://assets/sfx/bw_shader.tres")
		if !activecharacter.can_use_skill(skill):
			newbutton.disabled = true
			newbutton.get_node("TextureRect").material = load("res://assets/sfx/bw_shader.tres")
		newbutton.connect('pressed', combat, 'SelectSkill', [skill.code])
		newbutton.set_meta('skill', skill.code)
		globals.connectskilltooltip(newbutton, activecharacter.id, i)
	$SkillPanel/SkillContainer.visible = true
	$SkillPanel/DefaultSkillContainer.visible = true
	$SkillPanel/ItemContainer.visible = false


#item panel
func ClearItemPanel():
	input_handler.ClearContainer($SkillPanel/ItemContainer)

func RebuildItemPanel():
	if !combat.allowaction: return
	var array = []
	ClearItemPanel()
	for i in state.items.values():
		if i.itemtype == 'usable_combat':
			array.append(i)
	for i in array:
		var newbutton = input_handler.DuplicateContainerTemplate($SkillPanel/ItemContainer)
		newbutton.get_node("Icon").texture = load(i.icon)
		newbutton.get_node("Icon/Label").text = str(i.amount)
		newbutton.set_meta('skill', i.useskill)
		newbutton.connect('pressed', combat, 'ActivateItem', [i])
		globals.connectitemtooltip(newbutton, i)
	$SkillPanel/SkillContainer.visible = false
	$SkillPanel/DefaultSkillContainer.visible = false
	$SkillPanel/ItemContainer.visible = true


#utility & default
func RebuildDefaultsPanel():
	if !combat.allowaction: return
	var activecharacter = combat.activecharacter
	for i in ['attack', 'defence']:
		var newbutton = get_node("SkillPanel/DefaultSkillContainer").get_node(i)
		var skill = Skillsdata.patch_skill(i, activecharacter)
		if !newbutton.is_connected('pressed', combat, 'SelectSkill'):
			newbutton.connect('pressed', combat, 'SelectSkill', [skill.code])
			newbutton.set_meta('skill', skill.code)
		globals.connectskilltooltip(newbutton, activecharacter.id, i)


func RebuildReserve(forced = false):
	if !combat.allowaction and !forced: return
	input_handler.ClearContainer(utility_bar, ['Escape', 'Button'])
	utility_bar.get_node("Escape").visible = true
	for ch in state.characters:
		var hero = state.heroes[ch]
		if !hero.unlocked: continue
		if hero.position != null: continue
		var button = input_handler.DuplicateContainerTemplate(utility_bar, 'Button')
		button.get_node('TextureRect').texture = hero.portrait_circle()
		if hero.acted:
			button.disabled = true
		else:
			button.connect('pressed', combat, 'SelectExchange', [ch])


#global info
func build_enemy_head():
	var cw = combat.curstage + 1
	var nw = combat.enemygroup_full.size()
	$EmemyStats/Label.text = "Wave %d/%d" % [cw, nw]

#stub for next 3 actions
#this panel not helps in re-selecting heroes 
func build_selected_skill(skill): #not skill_id
	active_panel.visible = true
	active_panel.get_node("TextureRect").texture = skill.icon
	active_panel.get_node("Label").text = skill.name


func build_selected_item(item): 
	active_panel.visible = true
	active_panel.get_node("TextureRect").texture = load(item.icon)
	active_panel.get_node("Label").text = item.name


func build_selected_char(hero):
	active_panel.visible = true
	active_panel.get_node("TextureRect").texture = hero.portrait_circle()
	active_panel.get_node("Label").text = hero.name



#combatlog
func clear_log():
	$Combatlog/RichTextLabel.clear()


func combatlogadd_q(text):
	$Combatlog/RichTextLabel.append_bbcode(text)


func set_log(value = !show_log):
	show_log = value
	if show_log:
		$Combatlog.rect_size.y += 700
		$Combatlog.rect_position.y -= 700
	else:
#		$Combatlog.rect_min_size.y -= 200
		$Combatlog.rect_size.y -= 700
		$Combatlog.rect_position.y += 700
