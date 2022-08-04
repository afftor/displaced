extends Control

onready var combat = get_parent()

onready var utility_bar = $SkillPanel/UtilityContainer
onready var active_panel = $ActiveActionPanel
onready var active_panel2 = $ActiveActionPanel2

var hpanel1 = load("res://files/scenes/combat/char_stat_party.tscn")
var hpanel2 = load("res://files/scenes/combat/char_stat_reserve.tscn")

func _ready():
	$SkillPanel/Escape.connect("pressed", combat, "run")
	$SkillPanel/CategoriesContainer/SkillsButton.connect('pressed', self, "RebuildSkillPanel")
	$SkillPanel/CategoriesContainer/ItemsButton.connect('pressed', self, "RebuildItemPanel")
	$Combatlog2.connect("pressed", self, 'set_log')
	bind_hero_panels()
	hide_screen()

func combat_start():
	clear_log()
	prepare_shades()
	hide_screen()
	$Combatlog.visible = false

#panels
func get_hero_panel(hero_id):
	return get_node("PlayerStats/VBoxContainer/%s" % hero_id)

func get_hero_reserve(hero_id):
	return get_node("PlayerStats/VBoxContainer/%s_reserve" % hero_id)

func get_enemy_panel(pos):
	pos -= 4
	var r = pos / 3
	var l = pos % 3
	return get_node("EmemyStats/VBoxContainer").get_child(l * 2 + r)


func bind_hero_panels():
	input_handler.ClearContainerForced($PlayerStats/VBoxContainer)
	for ch in state.characters:
		var node = hpanel1.instance()
		node.name = ch
		node.connect('pressed', self, 'ShowHeroTooltip', [ch])
		$PlayerStats/VBoxContainer.add_child(node)
	for ch in state.characters:
		var node = hpanel2.instance()
		node.name = ch + '_reserve'
		node.connect('pressed', self, 'ShowHeroTooltip', [ch])
		$PlayerStats/VBoxContainer.add_child(node)


func ShowFighterStats(fighter): #obsolete
	var node = input_handler.get_spec_node(input_handler.NODE_SLAVEPANEL)
	node.open(state.heroes[fighter], true)


func build_hero_panels():
	var ch_order = []
	for pos in range(1, 4):
		var ch = combat.battlefield[pos]
		if ch == null: continue
		ch_order.push_back(ch.id)
#	for ch in state.characters:
#		if ch_order.has(ch): continue
#		ch_order.push_back(ch)
	for i in range(ch_order.size()):
		var ch = ch_order[i]
		var node = get_hero_panel(ch)
		$PlayerStats/VBoxContainer.move_child(node, i)
		var ch_d = state.heroes[ch].displaynode
		ch_d.get_parent().move_child(ch_d, i)
	for ch in state.characters:
		var hero = state.heroes[ch]
		var node1 = get_hero_panel(ch)
		var node2 = get_hero_reserve(ch)
		node1.visible = hero.unlocked
		node2.visible = hero.unlocked
		if hero.position != null:
			node2.visible = false
		else:
			node1.visible = false


func build_enemy_panels():
	for pos in range(4, 10):
		var node = get_enemy_panel(pos)
#		node.connect("mouse_exited", self, "HideEnemyTooltip")
		var ch = combat.battlefield[pos]
		if ch == null:
			node.modulate = Color(1,1,1,0.4)
			node.disabled = true
			for n in node.get_children():
				n.visible = false
			if node.is_connected("pressed", self, "ShowEnemyTooltip"):
				node.disconnect("pressed", self, "ShowEnemyTooltip")
		else:
			node.disabled = false
			node.modulate = Color(1,1,1,1)
			for n in node.get_children():
				n.visible = true
			if node.is_connected("pressed", self, "ShowEnemyTooltip"):
				node.disconnect("pressed", self, "ShowEnemyTooltip")
			node.connect("pressed", self, "ShowEnemyTooltip", [ch.id])


func ShowEnemyTooltip(fighter):
	if $enemypanel.ch_id == fighter and $enemypanel.visible:
		HideEnemyTooltip()
		return 
	$enemypanel.build_for_fighter(fighter)
	$enemypanel.show()


func HideEnemyTooltip():
	$enemypanel.hide()


func ShowHeroTooltip(fighter):
	if $heropanel.ch_id == fighter and $heropanel.visible:
		HideHeroTooltip()
		return 
	$heropanel.build_for_fighter(fighter)
	$heropanel.show()

func HideHeroTooltip():
	$heropanel.hide()

#shades
func prepare_shades():
	for shade in $CharShades.get_children():
		shade.set_inactive()
		shade.rect_position = combat.positions[shade.pos]
		shade.rect_position.x += 100
		shade.rect_position.y += 40


func activate_shades(positions = []):
	$dropscreen.visible = true
	for shade in $CharShades.get_children():
		if shade.pos in positions:
			shade.set_active()
		else:
			shade.set_inactive()


func hide_screen():
	$dropscreen.visible = false


func skill_button_pressed(mode, arg):
	if !combat.allowaction: return
	match mode:
		'skill':
			combat.SelectSkill(arg)
		'item':
			combat.ActivateItem(arg)

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
#		newbutton.connect('pressed', combat, 'SelectSkill', [skill.code])
		newbutton.connect('pressed', self, 'skill_button_pressed', ['skill', skill.code])
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
	ClearItemPanel()
	for id in state.materials:
		if state.materials[id] <= 0: continue
		var i = Items.Items[id]
		if i.itemtype == 'usable_combat':
			var newbutton = input_handler.DuplicateContainerTemplate($SkillPanel/ItemContainer)
			newbutton.get_node("icon").texture = i.icon
			newbutton.get_node("count").text = str(state.materials[id])
			newbutton.set_meta('skill', i.useskill)
			newbutton.connect('pressed', self, 'skill_button_pressed', ['item', i])
			globals.connectmaterialtooltip(newbutton, i)
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
	$SkillPanel/Escape.visible = true
#	for ch in state.characters:
#		var hero = state.heroes[ch]
#		if !hero.unlocked: continue
#		if hero.position != null: continue
#		var button = input_handler.DuplicateContainerTemplate(utility_bar, 'Button')
#		button.get_node('TextureRect').texture = hero.portrait_circle()
#		if hero.acted:
#			button.disabled = true
#		else:
#			button.connect('pressed', combat, 'SelectExchange', [ch])


#global info
func build_enemy_head():
	var cw = combat.curstage + 1
	var nw = combat.enemygroup_full.size()
	$EmemyStats/Label.text = "Wave %d/%d" % [cw, nw]

#stub for next 3 actions
#this panel not helps in re-selecting heroes 
func build_selected_skill(skill): #not skill_id
	active_panel.visible = true
	active_panel2.visible = true
	active_panel2.get_node("TextureRect").texture = skill.icon
	active_panel2.get_node("Label").text = tr("SKILL" + skill.name.to_upper())


func build_selected_item(item): 
	active_panel.visible = true
	active_panel2.visible = true
	active_panel2.get_node("TextureRect").texture = item.icon
	active_panel2.get_node("Label").text = item.name


func build_selected_char(hero):
	active_panel.visible = true
	active_panel2.visible = true
	active_panel2.get_node("TextureRect").texture = hero.portrait_circle()
	active_panel2.get_node("Label").text = hero.name



#combatlog
func clear_log():
	$Combatlog/RichTextLabel.clear()


func combatlogadd_q(text):
	$Combatlog/RichTextLabel.append_bbcode(text)


func set_log():
	$Combatlog.visible = !$Combatlog.visible
