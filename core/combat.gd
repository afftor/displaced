extends Control

var currentenemies
var area
var turns = 0
var animationskip = false

var encountercode

var combatlog = ''

var instantanimation = null

var shotanimationarray = [] #supposedanimation = {code = 'code', runnext = false, delayuntilnext = 0}

var CombatAnimations = preload("res://core/CombatAnimations.gd").new()

var debug = false

var allowaction = false
var highlightargets = false
var allowedtargets = {}
var turnorder = []
var fightover = false

var playergroup = {}
var enemygroup = {}
var currentactor

var summons = []

var activeaction
var activeitem
var activecharacter

var cursors = {
	default = load("res://assets/images/gui/universal/cursordefault.png"),
	attack = load("res://assets/images/gui/universal/cursorfight.png"),
	support = load("res://assets/images/gui/universal/cursorsupport.png"),
	
}

var enemypaneltextures = {
	normal = null,
	target = null,
}
var playerpaneltextures = {
	normal = null,
	target = null,
	disabled = null,
}

var battlefield = {}
onready var battlefieldpositions = {1 : $Panel/PlayerGroup/Front/left, 2 : $Panel/PlayerGroup/Front/mid, 3 : $Panel/PlayerGroup/Front/right,
4 : $Panel/PlayerGroup/Back/left, 5 : $Panel/PlayerGroup/Back/mid, 6 : $Panel/PlayerGroup/Back/right,
7 : $Panel2/EnemyGroup/Front/left, 8 : $Panel2/EnemyGroup/Front/mid, 9 : $Panel2/EnemyGroup/Front/right,
10: $Panel2/EnemyGroup/Back/left, 11 : $Panel2/EnemyGroup/Back/mid, 12 : $Panel2/EnemyGroup/Back/right}

var testenemygroup = {1 : 'elvenrat', 5 : 'elvenrat', 6 : 'elvenrat'}
var testplayergroup = {4 : 'elvenrat', 5 : 'elvenrat', 6 : 'elvenrat'}

var eot = true

func _ready():
	for i in range(1,13):
		battlefield[i] = null
	add_child(CombatAnimations)
#warning-ignore:return_value_discarded
	$ItemPanel/debugvictory.connect("pressed",self, 'cheatvictory')
#warning-ignore:return_value_discarded
	$Rewards/CloseButton.connect("pressed",self,'FinishCombat')


func cheatvictory():
	for i in enemygroup.values():
		i.hp = 0
	#checkwinlose()

func _process(delta):
	pass


func start_combat(newenemygroup, background, music = 'combattheme'):
	globals.combat_node = self
	turns = 0
	$Background.texture = images.backgrounds[background]
	$Combatlog/RichTextLabel.clear()
	enemygroup.clear()
	playergroup.clear()
	turnorder.clear()
	input_handler.SetMusic(music)
	fightover = false
	$Rewards.visible = false
	allowaction = false
	enemygroup = newenemygroup
	playergroup = state.combatparty
	buildenemygroup(enemygroup)
	buildplayergroup(playergroup)
	#victory()
	#start combat triggers
	for i in state.combatparty:
		if state.combatparty[i] == null: continue
		var p = state.heroes[state.combatparty[i]]
		p.process_event(variables.TR_COMBAT_S)
		p.displaynode.rebuildbuffs()
	input_handler.ShowGameTip('aftercombat')
	select_actor()

func FinishCombat():
	for i in state.heroes.values():
		i.cooldowns.clear()
	for i in battlefield:
		if battlefield[i] != null:
			battlefield[i].displaynode.queue_free()
			battlefield[i].displaynode = null
			battlefield[i] = null
	for i in range(7,13):
		if state.combatparty[i] == null:continue
#warning-ignore:return_value_discarded
		state.heroes.erase(state.combatparty[i])
		state.combatparty[i] = null
	hide()
	input_handler.ShowGameTip('explore')
	globals.check_signal("CombatEnded", encountercode)
	input_handler.SetMusic("towntheme")
	get_parent().wincontinue()
	get_parent().levelupscheck()
#	globals.call_deferred('EventCheck')


func select_actor():
	ClearSkillTargets()
	ClearSkillPanel()
	ClearItemPanel()
	checkdeaths()
	if checkwinlose() == true:
		return
	if turnorder.empty():
		#to test, maybe this is wrong decision
		calculateorder()
		newturn()
	currentactor = turnorder[0].pos
	turnorder.remove(0)
	#currentactor.update_timers()
	if currentactor < 7:
		player_turn(currentactor)
	else:
		enemy_turn(currentactor)

func newturn():
	for i in playergroup.values() + enemygroup.values():
		i.process_event(variables.TR_TURN_S)
		i.displaynode.rebuildbuffs()
		var cooldowncleararray = []
		for k in i.cooldowns:
			i.cooldowns[k] -= 1
			if i.cooldowns[k] <= 0:
				cooldowncleararray.append(k)
		for k in cooldowncleararray:
			i.cooldowns.erase(k)

func checkdeaths():
	for i in battlefield:
		if battlefield[i] != null && battlefield[i].defeated != true && battlefield[i].hp <= 0:
			battlefield[i].death()
			combatlogadd("\n" + battlefield[i].name + " has been defeated.")
			for j in range(turnorder.size()):
				if turnorder[j].pos == i:
					turnorder.remove(j)
					break
			#turnorder.erase(battlefield[i])
			if summons.has(i):
				battlefield[i].displaynode.queue_free()
				battlefield[i].displaynode = null
				battlefield[i] = null
				enemygroup.erase(i)
				summons.erase(i);
#warning-ignore:return_value_discarded
				state.heroes.erase(state.combatparty[i])
				state.combatparty[i] = null
				


func checkwinlose():
	var playergroupcounter = 0
	var enemygroupcounter = 0
	for i in battlefield:
		if battlefield[i] == null:
			continue
		if battlefield[i].defeated == true:
			continue
		if i in range(1,7):
			playergroupcounter += 1
		else:
			enemygroupcounter += 1
	if playergroupcounter <= 0:
		defeat()
		return true
	elif enemygroupcounter <= 0:
		victory()
		return true

var rewardsdict

func victory():
	Input.set_custom_mouse_cursor(cursors.default)
	yield(get_tree().create_timer(0.5), 'timeout')
	fightover = true
	$Rewards/CloseButton.disabled = true
	input_handler.StopMusic()
	#on combat ends triggers
	for p in playergroup.values():
		p.process_event(variables.TR_COMBAT_F)
	
	var tween = input_handler.GetTweenNode($Rewards/victorylabel)
	tween.interpolate_property($Rewards/victorylabel,'rect_scale', Vector2(1.5,1.5), Vector2(1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	input_handler.PlaySound("victory")
	
	rewardsdict = {materials = {}, items = [], xp = 0}
	for i in enemygroup.values():
		if i == null:
			continue
		rewardsdict.xp += i.xpreward
		var loot = {}
		if Enemydata.loottables[i.loottable].has('materials'):
			for j in Enemydata.loottables[i.loottable].materials:
				if randf()*100 <= j.chance:
					loot[j.code] = round(rand_range(j.min, j.max))
			globals.AddOrIncrementDict(rewardsdict.materials, loot)
		if Enemydata.loottables[i.loottable].has('usables'):
			for j in Enemydata.loottables[i.loottable].usables:
				if randf()*100 <= j.chance:
					var newitem = globals.CreateUsableItem(j.code, round(rand_range(j.min, j.max)))
					rewardsdict.items.append(newitem)
	
	globals.ClearContainerForced($Rewards/HBoxContainer/first)
	globals.ClearContainerForced($Rewards/HBoxContainer/second)
	globals.ClearContainer($Rewards/ScrollContainer/HBoxContainer)
	for i in playergroup.values():
		var newbutton = globals.DuplicateContainerTemplate($Rewards/HBoxContainer/first)
		if $Rewards/HBoxContainer/first.get_children().size() >= 5:
			$Rewards/HBoxContainer/first.remove_child(newbutton)
			$Rewards/HBoxContainer/second.add_child(newbutton)
		newbutton.get_node('icon').texture = i.portrait_circle()
		newbutton.get_node("xpbar").value = i.baseexp
		var level = i.level
		i.baseexp += ceil(rewardsdict.xp*i.xpmod)
		var subtween = input_handler.GetTweenNode(newbutton)
		if i.level > level:
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'value', newbutton.get_node("xpbar").value, 100, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'modulate', newbutton.get_node("xpbar").modulate, Color("fffb00"), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
			subtween.interpolate_callback(input_handler, 1, 'DelayedText', newbutton.get_node("xpbar/Label"), tr("LEVELUP")+ ': ' + str(i.level) + "!")
			subtween.interpolate_callback(input_handler, 1, 'PlaySound', "levelup")
		elif i.level == level && i.baseexp == 100 :
			newbutton.get_node("xpbar").value = 100
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'modulate', newbutton.get_node("xpbar").modulate, Color("fffb00"), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
			subtween.interpolate_callback(input_handler, 0, 'DelayedText', newbutton.get_node("xpbar/Label"), tr("MAXLEVEL"))
		else:
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'value', newbutton.get_node("xpbar").value, i.baseexp, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
			subtween.interpolate_callback(input_handler, 2, 'DelayedText', newbutton.get_node("xpbar/Label"), '+' + str(ceil(rewardsdict.xp*i.xpmod)))
		subtween.start()
	#$Rewards/ScrollContainer/HBoxContainer.move_child($Rewards/ScrollContainer/HBoxContainer/Button, $Rewards/ScrollContainer/HBoxContainer.get_children().size())
	$Rewards.visible = true
	$Rewards.set_meta("result", 'victory')
	for i in rewardsdict.materials:
		var item = Items.Materials[i]
		var newbutton = globals.DuplicateContainerTemplate($Rewards/ScrollContainer/HBoxContainer)
		newbutton.hide()
		newbutton.texture = item.icon
		newbutton.get_node("Label").text = str(rewardsdict.materials[i])
		state.materials[i] += rewardsdict.materials[i]
		globals.connectmaterialtooltip(newbutton, item)
	for i in rewardsdict.items:
		var newnode = globals.DuplicateContainerTemplate($Rewards/ScrollContainer/HBoxContainer)
		newnode.hide()
		newnode.texture = load(i.icon)
		globals.AddItemToInventory(i)
		globals.connectitemtooltip(newnode, state.items[globals.get_item_id_by_code(i.itembase)])
		if i.amount == null:
			newnode.get_node("Label").visible = false
		else:
			newnode.get_node("Label").text = str(i.amount)
	
	yield(get_tree().create_timer(1.7), 'timeout')
	
	for i in $Rewards/ScrollContainer/HBoxContainer.get_children():
		if i.name == 'Button':
			continue
		tween = input_handler.GetTweenNode(i)
		yield(get_tree().create_timer(1), 'timeout')
		i.show()
		input_handler.PlaySound("itemget")
		tween.interpolate_property(i,'rect_scale', Vector2(1.5,1.5), Vector2(1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	
	#yield(get_tree().create_timer(1), 'timeout')
	$Rewards/CloseButton.disabled = false
	

func defeat():
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	globals.CurrentScene.GameOverShow()
	set_process(false)
	set_process_input(false)

func player_turn(pos):
	turns += 1
	var selected_character = playergroup[pos]
	#selected_character.update_timers()
	selected_character.process_event(variables.TR_TURN_GET)
	selected_character.displaynode.rebuildbuffs()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	
	if !selected_character.can_act():
		selected_character.process_event(variables.TR_TURN_F)
		selected_character.displaynode.rebuildbuffs()
		call_deferred('select_actor')
		return
	allowaction = true
	activecharacter = selected_character
	RebuildSkillPanel()
	RebuildItemPanel()
	SelectSkill(selected_character.selectedskill)

#rangetypes melee, any, backmelee

func get_allied_targets(fighter):
	var res = []
	if fighter.position in range(1, 7):
		for p in playergroup.values():
			if !p.defeated: res.push_back(p)
	else:
		for p in enemygroup.values():
			if !p.defeated: res.push_back(p)
	return res

func get_enemy_targets_all(fighter, hide_ignore = false):
	var res = []
	if fighter.position in range(1, 7):
		for p in enemygroup.values():
			if p.defeated: continue
			#if p.has_status('hide') and !hide_ignore: continue
			res.push_back(p)
	else:
		for p in playergroup.values():
			if p.defeated: continue
			#if p.has_status('hide') and !hide_ignore: continue
			res.push_back(p)
	return res

func get_enemy_targets_melee(fighter, hide_ignore = false):
	var res = []
	if fighter.position in range(1, 7):
		for p in enemygroup.values():
			if p.defeated: continue
			#if p.has_status('hide') and !hide_ignore: continue
			if CheckMeleeRange('enemy', hide_ignore) and p.position > 9: continue
			res.push_back(p)
	else:
		for p in playergroup.values():
			if p.defeated: continue
			#if p.has_status('hide') and !hide_ignore: continue
			if CheckMeleeRange('ally', hide_ignore) and p.position > 3: continue
			res.push_back(p)
	return res

func UpdateSkillTargets(caster, glow_skip = false):
	var skill = Skillsdata.skilllist[activeaction]
	var fighter = caster
	var targetgroups = skill.allowedtargets
	var targetpattern = skill.targetpattern
	var rangetype = skill.userange
	ClearSkillTargets()
	
	for i in $SkillPanel/ScrollContainer/GridContainer.get_children() + $ItemPanel/ScrollContainer/GridContainer.get_children():
		if i.has_meta('skill'):
			i.pressed = i.get_meta('skill') == skill.code
	
	if rangetype == 'weapon':
		if fighter.gear.rhand == null:
			rangetype = 'melee'
		else:
			var weapon = state.items[fighter.gear.rhand]
			rangetype = weapon.weaponrange
	
	highlightargets = true
	allowedtargets.clear()
	allowedtargets = {ally = [], enemy = []}
	
	if targetgroups.has('enemy'):
		var t_targets
		if rangetype == 'any': t_targets = get_enemy_targets_all(fighter)
		if rangetype == 'melee': t_targets = get_enemy_targets_melee(fighter)
		for t in t_targets:
			allowedtargets.enemy.push_back(t.position)
	if targetgroups.has('ally'):
		var t_targets = get_allied_targets(fighter)
#		if rangetype == 'dead':
#			t_targets.clear()
#			for t in playergroup.values():
#				var tchar = characters_pool.get_char_by_id(t)
#				if tchar.defeated:
#					t_targets.push_back(tchar)
#			pass
		for t in t_targets:
			allowedtargets.ally.push_back(t.position)
	if targetgroups.has('self'):
		allowedtargets.ally.append(int(fighter.position))
	
	if glow_skip: return
	Highlight(currentactor,'selected')
	Off_Target_Glow();
	for f in allowedtargets.enemy:
		Target_Glow(f);
	for f in allowedtargets.ally:
		Target_Glow(f);

func ClearSkillTargets():
	for i in battlefield:
		if battlefield[i] != null && battlefield[i].displaynode != null:
			StopHighlight(i)

func CheckMeleeRange(group, hide_ignore = false): #Check if group front row is still in place
	var rval = false
	var counter = 0
	#reqires adding hide checks
	match group:
		'enemy':
			for pos in range(7,10):
				if battlefield[pos] == null:continue
				var tchar = battlefield[pos]
				if tchar.defeated == true: continue
				#if tchar.has_status('hide') and !hide_ignore: continue
				counter += 1
		'ally':
			for pos in range(1,4):
				if battlefield[pos] == null:continue
				var tchar = battlefield[pos]
				if tchar.defeated == true: continue
				#if tchar.has_status('hide') and !hide_ignore: continue
				counter += 1
	if counter > 0: rval = true
	return rval

func can_be_taunted(caster, target):
	match target.combatgroup:
		'ally':
			if target.position < 4: return true
			if !CheckMeleeRange('ally'): return true
		'enemy':
			if target.position < 10: return true
			if !CheckMeleeRange('enemy'): return true
	#var s_code = caster.get_skill_by_tag('default')
	var skill = Skillsdata.skilllist['attack']
	return (skill.userange == 'any') or (skill.userange == 'weapon' and caster.get_weapon_range() == 'any')

func enemy_turn(pos):
	turns += 1
	var fighter = enemygroup[pos]
	#fighter.update_timers()
	fighter.process_event(variables.TR_TURN_GET)
	fighter.displaynode.rebuildbuffs()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	if !fighter.can_act():
		#combatlogadd("%s cannot act" % fighter.name)
		fighter.process_event(variables.TR_TURN_F)
		fighter.displaynode.rebuildbuffs()
		call_deferred('select_actor')
		return
	#Selecting active skill
	
	Highlight(pos, 'enemy')
	
	turns += 1
	var castskill = fighter.ai._get_action()
	var target = fighter.ai._get_target(castskill)
	if target == null:
		castskill = fighter.ai._get_action(true)
		target = fighter.ai._get_target(castskill)
	if target == null:
		checkwinlose()
		return
	target = battlefield[target]
	
#	if fighter.has_status('confuse'):
#		castskill = fighter.get_skill_by_tag('default')
#		activeaction = castskill
#		UpdateSkillTargets(fighter, true)
#		target = get_random_target()
	#if fighter.has_status('taunt'):
	if fighter.taunt != null:
		var targ = state.heroes[fighter.taunt]
		fighter.taunt = null
		if can_be_taunted(fighter, targ):
			target = targ;
			castskill = fighter.get_skill_by_tag('default')
	if target == null:
		print(fighter.name, ' no target found')
		return
	use_skill(castskill, fighter, target)
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	#yield(self, "skill_use_finshed")
	while eot:
		turns += 1
		castskill = fighter.ai._get_action()
		target = battlefield[fighter.ai._get_target(castskill)]
		use_skill(castskill, fighter, target)
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')

func calculateorder():
	turnorder.clear()
	for i in playergroup:
		if playergroup[i].defeated == true:
			continue
		turnorder.append({speed = playergroup[i].speed + randf() * 5, pos = i})
	for i in enemygroup:
		if enemygroup[i].defeated == true:
			continue
		turnorder.append({speed = enemygroup[i].speed + randf() * 5, pos = i})
	
	turnorder.sort_custom(self, 'speedsort')

func speedsort(first, second):
	if first.speed > second.speed:
		return true
	else:
		return false

func make_fighter_panel(fighter, spot):
	#need to implement clearing panel if fighter is null for the sake of removing summons
	#or simply implement func clear_fighter_panel(pos)
	var container = battlefieldpositions[spot]
	var panel = $Panel/PlayerGroup/Back/left/Template.duplicate()
	panel.material = $Panel/PlayerGroup/Back/left/Template.material.duplicate()
	panel.get_node('border').material = $Panel/PlayerGroup/Back/left/Template.get_node('border').material.duplicate()
	fighter.displaynode = panel
	panel.name = 'Character'
	panel.set_script(load("res://files/scenes/FighterNode.gd"))
	panel.position = int(spot)
	fighter.position = int(spot)
	panel.animation_node = CombatAnimations
	panel.fighter = fighter
	panel.hp = fighter.hp
	panel.mp = fighter.mana
	panel.connect("signal_RMB", self, "ShowFighterStats")
	panel.connect("signal_RMB_release", self, 'HideFighterStats')
	panel.connect("signal_LMB", self, 'FighterPress')
	panel.connect("mouse_entered", self, 'FighterMouseOver', [fighter])
	panel.connect("mouse_exited", self, 'FighterMouseOverFinish', [fighter])
	if variables.CombatAllyHpAlwaysVisible && fighter.combatgroup == 'ally':
		panel.get_node("hplabel").show()
		panel.get_node("mplabel").show()
	panel.set_meta('character',fighter)
	panel.get_node("Icon").texture = fighter.combat_portrait()
	panel.get_node("HP").value = globals.calculatepercent(fighter.hp, fighter.get_stat('hpmax'))
	panel.get_node("Mana").value = globals.calculatepercent(fighter.mana, fighter.get_stat('manamax'))
	panel.update_hp_label(fighter.hp, 100.0)
	panel.update_mp_label(fighter.mana, 100.0)
	if fighter.get_stat('manamax') == 0:
		panel.get_node("Mana").value = 0
	panel.get_node("Label").text = fighter.name
	container.add_child(panel)
	panel.rect_position = Vector2(0,0)
	#setuping target glowing
	var g_color;
	if spot < 7:
		g_color = Color(0.0, 1.0, 0.0, 0.0);
	else:
		g_color = Color(1.0, 0.0, 0.0, 0.0);
	panel.material.set_shader_param('modulate', g_color);
	panel.visible = true
	panel.noq_rebuildbuffs(fighter.get_all_buffs())

var fighterhighlighted = false

func FighterShowStats(fighter):
	var panel = fighter.displaynode
	panel.get_node("hplabel").show()
	panel.get_node("mplabel").show()

func FighterMouseOver(fighter):
	FighterShowStats(fighter)
	if allowaction == true && (allowedtargets.enemy.has(fighter.position) || allowedtargets.ally.has(fighter.position)):
		if fighter.combatgroup == 'enemy':
			Input.set_custom_mouse_cursor(cursors.attack)
		else:
			Input.set_custom_mouse_cursor(cursors.support)
		var cur_targets = [];
		cur_targets = CalculateTargets(Skillsdata.skilllist[activeaction], fighter); 
		Stop_Target_Glow();
		for c in cur_targets:
			Target_eff_Glow(c.position);


func FighterMouseOverFinish(fighter):
	if !allowaction: return;
	var panel = fighter.displaynode
	fighterhighlighted = false
	if variables.CombatAllyHpAlwaysVisible == false || fighter.combatgroup == 'enemy':
		panel.get_node("hplabel").hide()
		panel.get_node("mplabel").hide()
	Input.set_custom_mouse_cursor(cursors.default)
	Stop_Target_Glow();
	for f in allowedtargets.enemy:
		Target_Glow(f);
	for f in allowedtargets.ally:
		Target_Glow(f);

func ShowFighterStats(fighter):
	if fightover == true:
		return
	var text = ''
	if fighter.combatgroup == 'ally':

		$StatsPanel/hp.text = 'Health: ' + str(fighter.hp) + '/' + str(fighter.get_stat('hpmax'))
		if fighter.get_stat('manamax') > 0:
			$StatsPanel/mana.text = "Mana: " + str(fighter.mana) + '/' + str(fighter.get_stat('manamax'))
		else:
			$StatsPanel/mana.text = ''
	else:
		$StatsPanel/hp.text = 'Health: ' + str(round(globals.calculatepercent(fighter.hp, fighter.get_stat('hpmax')))) + "%"
		if fighter.get_stat('manamax') > 0:
			$StatsPanel/mana.text = "Mana: " + str(round(globals.calculatepercent(fighter.mana, fighter.get_stat('manamax')))) + "%"
		else:
			$StatsPanel/mana.text = ''
	$StatsPanel/damage.text = "Damage: " + str(round(fighter.get_stat('damage'))) 
	$StatsPanel/crit.text = tr("CRITICAL") + ": " + str(fighter.get_stat('critchance')) + "%/" + str(fighter.get_stat('critmod')*100) + '%' 
	$StatsPanel/hitrate.text = "Hit Rate: " + str(fighter.get_stat('hitrate'))
	$StatsPanel/armorpen.text = "Armor Penetration: " + str(fighter.get_stat('armorpenetration'))
	
	$StatsPanel/armor.text = "Armor: " + str(fighter.get_stat('armor')) 
	$StatsPanel/mdef.text = "M. Armor: " + str(fighter.get_stat('mdef'))
	$StatsPanel/evasion.text =  "Evasion: " + str(fighter.get_stat('evasion')) 
	$StatsPanel/speed.text = "Speed: " + str(fighter.get_stat('speed'))

	for i in ['fire','water','earth','air']:
		get_node("StatsPanel/resist"+i).text = "Resist " + i.capitalize() + ": " + str(fighter['resist'+i]) + " "
	$StatsPanel.show()
	$StatsPanel/name.text = tr(fighter.name)
	$StatsPanel/descript.text = fighter.flavor
	$StatsPanel/TextureRect.texture = fighter.combat_full_portrait()
#	for i in fighter.buffs:
#		text += i + "\n"
	for b in fighter.get_all_buffs():
		text += b.name + '\n'
	$StatsPanel/effects.bbcode_text = text

func HideFighterStats():
	$StatsPanel.hide()

func FighterPress(pos):
	if allowaction == false || (!allowedtargets.enemy.has(pos) && !allowedtargets.ally.has(pos)):
		return
	ClearSkillTargets()
	ClearItemPanel()
	ClearSkillPanel()
	use_skill(activeaction, activecharacter, battlefield[pos])


func buildenemygroup(enemygroup):
	for i in range(1,7):
		if enemygroup[i] != null:
			enemygroup[i+6] = enemygroup[i]
		enemygroup.erase(i)
	
	for i in enemygroup:
		if enemygroup[i] == null:
			continue
		var tempname = enemygroup[i]
		enemygroup[i] = combatant.new()
		enemygroup[i].createfromenemy(tempname)
		enemygroup[i].combatgroup = 'enemy'
		battlefield[i] = enemygroup[i]
		make_fighter_panel(battlefield[i], i)
		#new part for gamestate 
		state.heroes[enemygroup[i].id] = enemygroup[i]
		state.combatparty[i] = enemygroup[i].id
		

func buildplayergroup(group):
	var newgroup = {}
	for i in group:
		if i > 6: break
		if group[i] == null:
			continue
		var fighter = state.heroes[group[i]]
		fighter.combatgroup = 'ally'
		battlefield[i] = fighter
		make_fighter_panel(battlefield[i], i)
		newgroup[i] = fighter
	playergroup = newgroup

func summon(montype, limit):
	# for now summoning is implemented only for opponents
	# cause i don't know if ally summons must be player- or ai-controlled
	# and don't know if it is possible to implement ai-controlled ally
	if summons.size() >= limit: return
	#find empty slot in enemy group
	var group = [7,8,9,10,11,12];
	var pos = [];
	for p in group:
		if battlefield[p] == null: pos.push_back(p);
	if pos.size() == 0: return;
	var sum_pos = pos[randi() % pos.size()];
	summons.push_back(sum_pos);
	enemygroup[sum_pos] = combatant.new();
	enemygroup[sum_pos].createfromenemy(montype);
	enemygroup[sum_pos].combatgroup = 'enemy'
	battlefield[sum_pos] = enemygroup[sum_pos];
	make_fighter_panel(battlefield[sum_pos], sum_pos);
	state.combatparty[sum_pos] = enemygroup[sum_pos].id
	state.heroes[enemygroup[sum_pos].id] = enemygroup[sum_pos]


func use_skill(skill_code, caster, target):
	if activeaction != skill_code: activeaction = skill_code
	allowaction = false
	
	var skill = Skillsdata.skilllist[skill_code]
	
	if caster != null && skill.name != "":
		if activeitem:
			combatlogadd("\n" + caster.name + ' uses ' + activeitem.name + ". ")
		else:
			combatlogadd("\n" + caster.name + ' uses ' + skill.name + ". ")
		caster.mana -= skill.manacost
		
		if skill.cooldown > 0:
			caster.cooldowns[skill_code] = skill.cooldown
	
	#caster part of setup
	var s_skill1 = S_Skill.new()
	s_skill1.createfromskill(skill_code)
	s_skill1.setup_caster(caster)
	s_skill1.process_event(variables.TR_CAST)
	
	caster.process_event(variables.TR_CAST, s_skill1)


	turns += 1
	#preparing animations
	var animations = skill.sfx
	var animationdict = {windup = [], predamage = [], postdamage = []}
	#sort animations
	for i in animations:
		animationdict[i.period].append(i)
	#casteranimations
	#for sure at windup there should not be real_target-related animations
	if skill.has('sounddata') and skill.sounddata.initiate != null:
		caster.displaynode.process_sound(skill.sounddata.initiate)
	for i in animationdict.windup:
		var sfxtarget = ProcessSfxTarget(i.target, caster, target)
		sfxtarget.process_sfx(i.code)
	#skill's repeat cycle of predamage-damage-postdamage
	var targets
	var endturn = !s_skill1.tags.has('instant');
	for n in range(s_skill1.repeat):
		#get all affected targets
		if skill.has('random_target') or (target != null and target.hp <= 0) :
			if checkwinlose(): 
				eot = false
				return
			UpdateSkillTargets(caster, true);
			target = get_random_target()
		targets = CalculateTargets(skill, target, true) 
		#preparing real_target processing, predamage animations
		var s_skill2_list = []
		for i in targets:
			if skill.has('sounddata') and skill.sounddata.strike != null:
				if skill.sounddata.strike == 'weapon':
					caster.displaynode.process_sound(get_weapon_sound(caster))
				else:
					caster.displaynode.process_sound(skill.sounddata.strike)
			for j in animationdict.predamage:
				var sfxtarget = ProcessSfxTarget(j.target, caster, i)
				sfxtarget.process_sfx(j.code)
			#special results
			if skill.damagetype == 'summon':
				summon(skill.value[0], skill.value[1]);
			elif skill.damagetype == 'resurrect':
				i.resurrect(skill.value[0]) #not sure
			else: 
				#default skill result
				#execute_skill(s_skill1, caster, i)
				var s_skill2:S_Skill = s_skill1.clone()
				s_skill2.setup_target(i)
				#place for non-existing another trigger
				s_skill2.setup_final()
				s_skill2.hit_roll()
				s_skill2.resolve_value(CheckMeleeRange(caster.combatgroup))
				s_skill2_list.push_back(s_skill2)
		turns += 1
		#predamage triggers
		for s_skill2 in s_skill2_list:
			s_skill2.process_event(variables.TR_HIT)
			s_skill2.caster.process_event(variables.TR_HIT, s_skill2)
			s_skill2.target.process_event(variables.TR_DEF, s_skill2)
			s_skill2.setup_effects_final()
		turns += 1
		#damage
		for s_skill2 in s_skill2_list:
			#check miss
			if s_skill2.hit_res == variables.RES_MISS:
				s_skill2.target.play_sfx('miss')
				combatlogadd(target.name + " evades the damage.")
				Off_Target_Glow()
			else:
				#hit landed animation
				if skill.has('sounddata') and skill.sounddata.hit != null:
					if skill.sounddata.hittype == 'absolute':
						s_skill2.target.displaynode.process_sound(skill.sounddata.hit)
					elif skill.sounddata.hittype == 'bodyarmor':
						s_skill2.target.displaynode.process_sound(calculate_hit_sound(skill, caster, s_skill2.target))
				for j in animationdict.postdamage:
					var sfxtarget = ProcessSfxTarget(j.target, caster, s_skill2.target)
					sfxtarget.process_sfx(j.code)
				#applying resists
				s_skill2.calculate_dmg()
				#logging result & dealing damage
				execute_skill(s_skill2)
		turns += 1
		#postdamage triggers and cleanup real_target s_skills
		for s_skill2 in s_skill2_list:
			s_skill2.process_event(variables.TR_POSTDAMAGE)
			s_skill2.caster.process_event(variables.TR_POSTDAMAGE, s_skill2)
			if s_skill2.target.hp <= 0:
				s_skill2.process_event(variables.TR_KILL)
				s_skill2.caster.process_event(variables.TR_KILL)
			s_skill2.target.displaynode.rebuildbuffs()
			checkdeaths()
			if s_skill2.target.displaynode != null:
				s_skill2.target.displaynode.rebuildbuffs()
			Off_Target_Glow();
			s_skill2.remove_effects()
	turns += 1
	s_skill1.process_event(variables.TR_SKILL_FINISH)
	caster.process_event(variables.TR_SKILL_FINISH, s_skill1)
	s_skill1.remove_effects()
	#follow-up
	if skill.has('follow_up'):
		use_skill(skill.follow_up, caster, target)
	if skill.has('not_final'): return
	
	#final
	turns += 1
	if activeitem != null:
		activeitem.amount -= 1
		activeitem = null
		SelectSkill(caster.get_skill_by_tag('default'))
	
	caster.displaynode.rebuildbuffs()
	if fighterhighlighted == true:
		FighterMouseOver(target)
	#print(caster.name + ' finished attacking') 
	if endturn or caster.hp <= 0 or !caster.can_act():
		#on end turn triggers
		caster.process_event(variables.TR_TURN_F)
		call_deferred('select_actor')
		eot = false
	else:
		if activecharacter.combatgroup == 'ally':
			CombatAnimations.check_start()
			if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
		allowaction = true
		RebuildSkillPanel()
		RebuildItemPanel()
		SelectSkill(activeaction)
		eot = true


func ProcessSfxTarget(sfxtarget, caster, target):
	match sfxtarget:
		'caster':
			return caster.displaynode
		'target':
			return target.displaynode



#var rows = {
#	1:[1,4],
#	2:[2,5],
#	3:[3,6],
#	4:[7,10],
#	5:[8,11],
#	6:[9,12],
#} 
#var lines = {
#	1 : [1,2,3],
#	2 : [4,5,6],
#	3 : [7,8,9],
#	4 : [10,11,12],
#}


func CalculateTargets(skill, target, finale = false):
	if target == null: return 
	var array = []
	
	var targetgroup
	
	if int(target.position) in range(1,7):
		targetgroup = 'player'
	else:
		targetgroup = 'enemy'

	match skill.targetpattern:
		'single':
			array = [target]
		'row':
			for i in variables.rows:
				if variables.rows[i].has(target.position):
					for j in variables.rows[i]:
						if battlefield[j] == null : continue
						var tchar = battlefield[j]
						if tchar.defeated: continue
						#if !tchar.can_be_damaged(skill.code) and !finale: continue
						array.append(tchar)
		'line':
			for i in variables.lines:
				if variables.lines[i].has(target.position):
					for j in variables.lines[i]:
						if battlefield[j] == null : continue
						var tchar = battlefield[j]
						if tchar.defeated: continue
						#if !tchar.can_be_damaged(skill.code) and !finale: continue
						array.append(tchar)
		'all':
			for j in range(1, 13):
				if j in range(1,7) && targetgroup == 'player':
					if battlefield[j] == null : continue
					var tchar = battlefield[j]
					if tchar.defeated: continue
					#if !tchar.can_be_damaged(skill.code) and !finale: continue
					array.append(tchar)
				elif j in range(7, 13) && targetgroup == 'enemy':
					if battlefield[j] == null : continue
					var tchar = battlefield[j]
					if tchar.defeated: continue
					#if !tchar.can_be_damaged(skill.code) and !finale: continue
					array.append(tchar)
	if (!finale) and skill.has('random_target'):
		array.clear()
		for pos in allowedtargets.enemy + allowedtargets.ally:
			var tchar = battlefield[pos]
			array.push_back(tchar)
	return array

func get_random_target():
	var tmparr = []
	for pos in allowedtargets.enemy + allowedtargets.ally:
		var tchar = battlefield[pos]
		tmparr.push_back(tchar)
	var i = globals.rng.randi_range(0, tmparr.size()-1)
	return tmparr[i]

func execute_skill(s_skill2):
	var text = ''
	if s_skill2.hit_res == variables.RES_CRIT:
		text += "[color=yellow]Critical!![/color] "
		s_skill2.target.displaynode.process_critical()
	#new section applying conception of multi-value skills
	#TO POLISH & REMAKE
	for i in range(s_skill2.value.size()):
		if s_skill2.damagestat[i] == 'no_stat': continue #for skill values that directly process into effects
		if s_skill2.damagestat[i] == '+damage_hp': #drain, damage, damage no log, drain no log
			if s_skill2.is_drain && s_skill2.tags.has('no_log'):
				var rval = s_skill2.target.deal_damage(s_skill2.value[i], s_skill2.damagetype)
				var rval2 = s_skill2.caster.heal(rval)
			elif s_skill2.is_drain:
				var rval = s_skill2.target.deal_damage(s_skill2.value[i], s_skill2.damagetype)
				var rval2 = s_skill2.caster.heal(rval)
				text += "%s drained %d health from %s and gained %d health." %[s_skill2.caster.name, rval, s_skill2.target.name, rval2]
			elif s_skill2.tags.has('no_log') && !s_skill2.is_drain:
				var rval = s_skill2.target.deal_damage(s_skill2.value[i], s_skill2.damagetype)
			else:
				var rval = s_skill2.target.deal_damage(s_skill2.value[i], s_skill2.damagetype)
				text += "%s is hit for %d damage. " %[s_skill2.target.name, rval]#, s_skill2.value[i]] 
		elif s_skill2.damagestat[i] == '-damage_hp': #heal, heal no log
			if s_skill2.tags.has('no_log'):
				var rval = s_skill2.target.heal(s_skill2.value[i])
			else:
				var rval = s_skill2.target.heal(s_skill2.value[i])
				text += "%s is healed for %d health." %[s_skill2.target.name, rval]
		elif s_skill2.damagestat[i] == '+restore_mana': #heal, heal no log
			if !s_skill2.tags.has('no log'):
				var rval = s_skill2.target.mana_update(s_skill2.value[i])
				text += "%s restored %d mana." %[s_skill2.target.name, rval] 
			else:
				s_skill2.target.mana_update(s_skill2.value[i])
		elif s_skill2.damagestat[i] == '-restore_mana': #drain, damage, damage no log, drain no log
			var rval = s_skill2.target.mana_update(-s_skill2.value[i])
			if s_skill2.is_drain:
				var rval2 = s_skill2.caster.mana_update(rval)
				if !s_skill2.tags.has('no log'):
					text += "%s drained %d mana from %s and gained %d mana." %[s_skill2.caster.name, rval, s_skill2.target.name, rval2]
			if !s_skill2.tags.has('no log'):
				text += "%s lost %d mana." %[s_skill2.target.name, rval] 
		else: 
			var mod = s_skill2.damagestat[i][0]
			var stat = s_skill2.damagestat[i].right(1) 
			if mod == '+':
				var rval = s_skill2.target.stat_update(stat, s_skill2.value[i])
				if !s_skill2.tags.has('no log'):
					text += "%s restored %d %s." %[s_skill2.target.name, rval, tr(stat)] 
			elif mod == '-':
				var rval = s_skill2.target.stat_update(stat, -s_skill2.value[i])
				if s_skill2.is_drain:
					var rval2 = s_skill2.caster.stat_update(stat, -rval)
					if !s_skill2.tags.has('no log'):
						text += "%s drained %d %s from %s." %[s_skill2.caster.name, s_skill2.value[i], tr(stat),  s_skill2.target.name]
				elif !s_skill2.tags.has('no log'):
					text += "%s loses %d %s." %[s_skill2.target.name, -rval, tr(stat)]
			elif mod == '=':
				var rval = s_skill2.target.stat_update(stat, s_skill2.value[i], true)
				if s_skill2.is_drain:# use this on your own risk
					var rval2 = s_skill2.caster.stat_update(stat, -rval)
					if !s_skill2.tags.has('no log'):
						text += "%s drained %d %s from %s." %[s_skill2.caster.name, s_skill2.value[i], tr(stat),  s_skill2.target.name]
				elif !s_skill2.tags.has('no log'):
					text += "%s's %s is now %d." %[s_skill2.target.name, tr(stat), s_skill2.value[i]] 
			else: print('error in damagestat %s' % s_skill2.damagestat[i])
	combatlogadd(text)


func miss(fighter):
	CombatAnimations.miss(fighter.displaynode)

#func makebuff(buff, caster, target):
#	var newbuff = {code = buff.code, caster = caster, duration = buff.duration, effects = [], tags = []}
#	if buff.has('icon'):
#		newbuff.icon = buff.icon
#	for i in buff.effects:
#		var value = calculate_number_from_string_array(i.value, caster, target)
#		var buffeffect = {value = value, stat = i.stat}
#		newbuff.effects.append(buffeffect)
#
#	return newbuff

func checkreqs(passive, caster, target):
	var rval = true
	
	if passive.has('casterreq'):
		if !input_handler.requirementcombatantcheck(passive.casterreq, caster):
			return false
	if passive.has('targetreq'):
		if !input_handler.requirementcombatantcheck(passive.targetreq, target):
			return false
	
	return rval

func Highlight(pos, type):
	var node = battlefieldpositions[pos].get_node("Character")
	match type:
		'selected':
			input_handler.SelectionGlow(node)
#		'target':
#			input_handler.TargetGlow(node)
#		'targetsupport':
#			input_handler.TargetSupport(node)
#		'enemy':
#			input_handler.TargetEnemyTurn(node)

func StopHighlight(pos):
	var node = battlefieldpositions[pos].get_node("Character")
	input_handler.StopTweenRepeat(node)

func Target_eff_Glow (pos):
	var node = battlefieldpositions[pos].get_node("Character");
	if node == null: return;
	var temp
	
	temp = Color(1.0,0.0,1.0,1.0);
	node.get_node('border').material.set_shader_param('modulate', temp);

func Target_Glow (pos):
	var node = battlefieldpositions[pos].get_node("Character");
	if node == null: return;
	var temp
	if pos in range(1,7):
		temp = Color(0.0,1.0,0.0,1.0);
	else:
		temp = Color(1.0,0.0,0.0,1.0);
	node.get_node('border').visible = true;
	node.get_node('border').material.set_shader_param('modulate', temp);

func Stop_Target_Glow ():
	for pos in range(1,13):
		var p_node = battlefieldpositions[pos];
		if !p_node.has_node('Character'): continue;
		var node = p_node.get_node("Character");
		#if node == null: continue;
		#node.material.shader_param.Modulate.a = 0.0;
		var temp = node.get_node('border').material.get_shader_param('modulate');
		temp.a = 0.0;
		node.get_node('border').material.set_shader_param('modulate', temp);

func Off_Target_Glow ():
	for pos in range(1,13):
		var p_node = battlefieldpositions[pos];
		if !p_node.has_node('Character'): continue;
		var node = p_node.get_node("Character");
		#if node == null: continue;
		#node.material.shader_param.Modulate.a = 0.0;
		#var temp = node.get_node('border').material.get_shader_param('modulate');
		#temp.a = 0.0;
		node.get_node('border').visible = false;

func ClearSkillPanel():
	globals.ClearContainer($SkillPanel/ScrollContainer/GridContainer)

func RebuildSkillPanel():
	ClearSkillPanel()
	for i in activecharacter.skills:
		var newbutton = globals.DuplicateContainerTemplate($SkillPanel/ScrollContainer/GridContainer)
		var skill = Skillsdata.skilllist[i]
		newbutton.get_node("Icon").texture = skill.icon
		newbutton.get_node("manacost").text = str(skill.manacost)
		if skill.manacost <= 0:
			newbutton.get_node("manacost").hide()
		if skill.manacost > activecharacter.mana:
			newbutton.get_node("Icon").modulate = Color(0,0,1)
		if activecharacter.cooldowns.has(i):
			newbutton.disabled = true
			newbutton.get_node("Icon").material = load("res://assets/sfx/bw_shader.tres")
		if !activecharacter.process_check(skill.reqs):
			newbutton.disabled = true
			newbutton.get_node("Icon").material = load("res://assets/sfx/bw_shader.tres")
		newbutton.connect('pressed', self, 'SelectSkill', [skill.code])
		if activecharacter.mana < skill.manacost:
			newbutton.disabled = true
			newbutton.get_node("Icon").material = load("res://assets/sfx/bw_shader.tres")
		newbutton.set_meta('skill', skill.code)
		globals.connectskilltooltip(newbutton, i, activecharacter)

func SelectSkill(skill):
	Input.set_custom_mouse_cursor(cursors.default)
	skill = Skillsdata.skilllist[skill]
	#need to add daily restriction check
	if activecharacter.mana < skill.manacost || activecharacter.cooldowns.has(skill.code) :
		#SelectSkill('attack')
		call_deferred('SelectSkill', 'attack')
		return
	activecharacter.selectedskill = skill.code
	activeaction = skill.code
	UpdateSkillTargets(activecharacter)
	if allowedtargets.ally.size() == 0 and allowedtargets.enemy.size() == 0:
		checkwinlose();
	if skill.allowedtargets.has('self') and skill.allowedtargets.size() == 1 :
		globals.closeskilltooltip()
		activecharacter.selectedskill = 'attack'
		call_deferred('use_skill', activeaction, activecharacter, activecharacter)
	

func RebuildItemPanel():
	var array = []
	
	ClearItemPanel()
	
	for i in state.items.values():
		if i.itemtype == 'usable':
			array.append(i)
	
	for i in array:
		var newbutton = globals.DuplicateContainerTemplate($ItemPanel/ScrollContainer/GridContainer)
		newbutton.get_node("Icon").texture = load(i.icon)
		newbutton.get_node("Label").text = str(i.amount)
		newbutton.set_meta('skill', i.useskill)
		newbutton.connect('pressed', self, 'ActivateItem', [i])
		globals.connectitemtooltip(newbutton, i)

func ClearItemPanel():
	globals.ClearContainer($ItemPanel/ScrollContainer/GridContainer)

func ActivateItem(item):
	activeaction = item.useskill
	activeitem = item
	SelectSkill(activeaction)
	#UpdateSkillTargets()

func get_weapon_sound(caster):
	var item = caster.gear.rhand
	if state.items.has(item):
		item = state.items[item]
	else:
		item = null
	if item == null:
		return 'dodge'
	else:
		return item.hitsound

func calculate_hit_sound(skill, caster, target):
	var rval
	var hitsound
	if skill.sounddata.strike == 'weapon':
		hitsound = get_weapon_sound(caster)
	else:
		hitsound = skill.sounddata.strike
	
	match hitsound:
		'dodge':
			match target.bodyhitsound:
				'flesh':pass
				'wood':pass
				'stone':pass
		'blade':
			match target.bodyhitsound:
				'flesh':pass
				'wood':pass
				'stone':pass
	rval = 'fleshhit'
	
	return rval

func combatlogadd(text):
	var data = {node = self, time = turns, type = 'c_log', slot = 'c_log', params = {text = text}}
	CombatAnimations.add_new_data(data)

func combatlogadd_q(text):
	$Combatlog/RichTextLabel.append_bbcode(text)
