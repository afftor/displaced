extends Control


var en_level = 0
var currentenemies
var area
var turns = 0
var animationskip = false

var encountercode

var combatlog = ''

var instantanimation = null

var shotanimationarray = [] #supposedanimation = {code = 'code', runnext = false, delayuntilnext = 0}

var CombatAnimations = preload("res://core/CombatAnimations_new.gd").new()

var debug = false

var allowaction = false
var highlightargets = false
var allowedtargets = {'ally':[],'enemy':[]}
var turnorder = []
var fightover = false

var playergroup = {}
var enemygroup_full = []
var enemygroup = {}
var currentactor

var summons = []
var rules = []

var activeaction
var activeitem
var activecharacter


var follow_up_skill = null
var follow_up_flag = false

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
onready var battlefieldpositions = {1 : $battlefield/PlayerGroup/Front/left, 2 : $battlefield/PlayerGroup/Front/mid, 3 : $battlefield/PlayerGroup/Front/right,
#4 : $Panel/PlayerGroup/Back/left, 5 : $Panel/PlayerGroup/Back/mid, 6 : $Panel/PlayerGroup/Back/right,
4 : $battlefield/EnemyGroup/Front/left, 5 : $battlefield/EnemyGroup/Front/mid, 6 : $battlefield/EnemyGroup/Front/right,
7: $battlefield/EnemyGroup/Back/left, 8 : $battlefield/EnemyGroup/Back/mid, 9 : $battlefield/EnemyGroup/Back/right}

#player party should be placed onto 1-3 positions


var eot = true
var nextenemy = 7
var curstage = 0
var defeated := []

var q_skills = []

enum {FIN_NO, FIN_STAGE, FIN_VIC, FIN_LOOSE}

var sounds = {
	"victory" : "sound/victory",
	"itemget" : "sound/itemget_1",
	"levelup" : "sound/levelup"
}

enum {T_CHARSELECT, T_SKILLSELECTED, T_TARGETOVER, T_AUTO}
var cur_state = T_AUTO

func _ready():
	for i in sounds.values():
		resources.preload_res(i)
	yield(resources, "done_work")
	
	for i in range(1,10):
		battlefield[i] = null
#	for i in range(7,13):
#		enemygroup[i] = null
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

func test_combat():
	for ch in ['rilu', 'ember', 'iola']:
		state.unlock_char(ch)
	state.combatparty[1] = 'arron'
	state.combatparty[2] = 'ember'
#	state.combatparty[3] = 'iola'
	start_combat([{1:'elvenrat', 4: 'elvenrat'}], 1, 'cave')
#	start_combat([{1:'elvenrat',2:'elvenrat',
#	3:'elvenrat',4:'elvenrat',5:'elvenrat',6:'elvenrat'}],20, 'cave')

#battlefield setup
func start_combat(newenemygroup, level, background, music = 'combattheme'):
	$test.visible = false
	globals.combat_node = self
	turns = 0
	en_level = level
	rules.clear()
#	$Background.texture = images.backgrounds[background]
	var tmp = resources.get_res("bg/%s" % background)
	$Background.texture = tmp
	$Combatlog/RichTextLabel.clear()
	for i in battlefieldpositions:
		battlefieldpositions[i].animation_node = CombatAnimations
		battlefield[i] = null
	enemygroup.clear()
	playergroup.clear()
	turnorder.clear()
	input_handler.SetMusic(music)
	fightover = false
	$Rewards.visible = false
	allowaction = false
	curstage = 0
	defeated.clear()
	enemygroup_full = newenemygroup
	playergroup = state.combatparty
	buildenemygroup(enemygroup_full[curstage])
	buildplayergroup(playergroup)
	#victory()
	#start combat triggers
	for i in battlefield:
		if battlefield[i] == null: continue
		battlefield[i].process_event(variables.TR_COMBAT_S)
		battlefield[i].rebuildbuffs()
	input_handler.ShowGameTip('aftercombat')
	newturn()
	call_deferred('select_actor')


func buildenemygroup(group):
	for i in range(4,7):
		if group.has(i) and group[i] != null:
			group[i+3] = group[i]
		group.erase(i)
	for i in range(1,4):
		if group.has(i) and group[i] != null:
			group[i+3] = group[i]
		group.erase(i)

	for i in group:
		if group[i] == null:
			enemygroup[i] = null
			battlefield[i] = null
			continue
		var tempname = group[i]
		enemygroup[i] = enemy.new()
		enemygroup[i].createfromtemplate(tempname, en_level)
		enemygroup[i].position = i
		battlefield[i] = enemygroup[i]
		make_fighter_panel(battlefield[i], i)
		#new part for gamestate 
#		state.heroes[enemygroup[i].id] = enemygroup[i]
#		state.combatparty[i] = enemygroup[i].id


func buildplayergroup(group):
	var newgroup = {}
	for i in group:
		if i > 3: break
		if group[i] == null:
			continue
		var fighter = state.heroes[group[i]]
		battlefield[i] = fighter
		make_fighter_panel(battlefield[i], i)
		newgroup[i] = fighter
	playergroup = newgroup


func make_fighter_panel(fighter, spot, show = true):
	var panel = battlefieldpositions[spot]
	panel.setup_character(fighter)
	if show: panel.visible = true
	panel.noq_rebuildbuffs(fighter.get_all_buffs())


#main loop
func newturn():
	nextenemy = 4
#	for i in playergroup.values() + enemygroup.values():
	for i in state.heroes.values():
		i.acted = false
		if i.defeated: continue
		i.process_event(variables.TR_TURN_S)
		i.rebuildbuffs()
		if i.displaynode != null: i.displaynode.process_enable()
		i.tick_cooldowns()
	turns +=1
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')


func select_actor():
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	ClearSkillTargets()
	ClearSkillPanel()
	ClearItemPanel()
	checkdeaths()
	var f = checkwinlose()
	if f == FIN_VIC or f == FIN_LOOSE:
		return
#	self.charselect = false
	while battlefield.has(nextenemy) and battlefield[nextenemy] == null:
		nextenemy += 1
	if f == FIN_STAGE :
		turns += 1
		curstage += 1
		combatlogadd("\n" + " Wave %d was cleared." % curstage)
		combatlogadd("\n" + "New wave!")
		buildenemygroup(enemygroup_full[curstage])
		newturn()
	elif get_avail_char_number('enemy') == 0: 
		newturn()
	
	if get_avail_char_number('ally') > 0:
		turns += 1
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: 
			yield(CombatAnimations, 'alleffectsfinished')
		allowaction = true
		cur_state = T_CHARSELECT
#		self.charselect = true
	else:
		enemy_turn(nextenemy)


func player_turn(pos): 
	turns += 1
	currentactor = pos
	var selected_character = playergroup[pos]
	selected_character.acted = true
	#selected_character.update_timers()
	selected_character.process_event(variables.TR_TURN_GET)
	selected_character.rebuildbuffs()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	
	if !selected_character.can_act():
		selected_character.process_event(variables.TR_TURN_F)
		selected_character.rebuildbuffs()
		call_deferred('select_actor')
		return
	allowaction = true
	activecharacter = selected_character
	RebuildSkillPanel()
	RebuildItemPanel()
	SelectSkill(selected_character.selectedskill)


func enemy_turn(pos):
	turns += 1
	nextenemy += 1
	var fighter = enemygroup[pos]
	#fighter.update_timers()
	fighter.process_event(variables.TR_TURN_GET)
	fighter.rebuildbuffs()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	fighter.acted = true
	if !fighter.can_act():
		#combatlogadd("%s cannot act" % fighter.name)
		fighter.process_event(variables.TR_TURN_F)
		fighter.rebuildbuffs()
		call_deferred('select_actor')
		return
	#Selecting active skill
	
#	Highlight(pos, 'enemy')
	
	turns += 1
	var castskill = fighter.ai._get_action()
	var target = fighter.ai._get_target(castskill)
	if target == null:
		castskill = fighter.ai._get_action(true)
		target = fighter.ai._get_target(castskill)
	if target == null:
		if checkwinlose() == FIN_NO: 
			print ('error getting targets')
		return
	#target = battlefield[target]
	
	if target == null:
		print(fighter.name, ' no target found')
		return
	yield(use_skill(castskill, fighter, target), 'completed')
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	#yield(self, "skill_use_finshed")
	while eot:
		turns += 1
		castskill = fighter.ai._get_action()
		#target = battlefield[fighter.ai._get_target(castskill)]
		target = fighter.ai._get_target(castskill)
		yield(use_skill(castskill, fighter, target), 'completed')
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')


func ActivateItem(item):
	activeaction = item.useskill
	activeitem = item
	SelectSkill(activeaction)
	#UpdateSkillTargets()


func SelectSkill(skill):
	cur_state = T_SKILLSELECTED
	activecharacter.displaynode.highlight_active()
	Input.set_custom_mouse_cursor(cursors.default)
	skill = Skillsdata.patch_skill(skill, activecharacter)#Skillsdata.skilllist[skill]
	#need to add daily restriction check
	if !activecharacter.can_use_skill(skill) :
		#SelectSkill('attack')
		call_deferred('SelectSkill', 'attack')
		return
	activecharacter.selectedskill = skill.code
	activeaction = skill.code
	UpdateSkillTargets(activecharacter)
	if allowedtargets.ally.size() == 0 and allowedtargets.enemy.size() == 0:
		if checkwinlose() == FIN_NO:
			print ('no legal targets')
			combatlogadd('No legal targets')
			call_deferred('SelectSkill', 'attack')
			return
	if skill.allowedtargets.has('self') and skill.allowedtargets.size() == 1 :
		globals.closeskilltooltip()
		activecharacter.selectedskill = 'attack'
		call_deferred('use_skill', activeaction, activecharacter, activecharacter.position)


#helpers
func get_avail_char_number(group):
	var res = 0
	var rg
	if group == 'ally': rg = [1, 2 ,3]
	else: rg = [4, 5, 6, 7, 8, 9]
	for i in rg:
		if battlefield[i] == null: continue
		if battlefield[i].defeated: continue
		if battlefield[i].acted: continue
		res += 1
	return res 


func checkreqs(passive, caster, target): #not used?
	var rval = true
	
	if passive.has('casterreq'):
		if !caster.requirementcombatantcheck(passive.casterreq):
			return false
	if passive.has('targetreq'):
		if !target.requirementcombatantcheck(passive.targetreq):
			return false
	
	return rval


func process_check(dir):
	var res
	match dir.type:
		'single_enemy':
			var tres = 0
			for ch in enemygroup.values():
				if ch != null: tres += 1
			res = tres == 1
		'is_player_turn':
			res = activecharacter.position < 4
		'is_enemy_turn':
			res = activecharacter.position >= 4
	return res


func checkdeaths():
	for i in battlefield:
		if battlefield[i] != null && battlefield[i].defeated != true && battlefield[i].hp <= 0:
			battlefield[i].death()
			combatlogadd("\n" + battlefield[i].name + " has been defeated.")
#			for j in range(turnorder.size()):
#				if turnorder[j].pos == i:
#					turnorder.remove(j)
#					break
			#turnorder.erase(battlefield[i])
			#if summons.has(i):
			#add fix around defeated player chars
			defeated.push_back(battlefield[i])
#			battlefield[i].displaynode.queue_free()
			battlefield[i].displaynode.visible = false
			battlefield[i].displaynode = null
			battlefield[i] = null
			enemygroup.erase(i)
			#summons.erase(i);
#warning-ignore:return_value_discarded
#			state.heroes.erase(state.combatparty[i])
#			state.combatparty[i] = null
		if battlefield[i] != null && battlefield[i].has_status('charmed'):
			combatlogadd("\n" + battlefield[i].name + "is charmed and has been removed from combat.")
			defeated.push_back(battlefield[i])
			battlefield[i].displaynode.queue_free()
			battlefield[i].displaynode = null
			battlefield[i] = null
			enemygroup.erase(i)
			#summons.erase(i);
#warning-ignore:return_value_discarded
#			state.heroes.erase(state.combatparty[i])
#			state.combatparty[i] = null


func checkwinlose():
	var playergroupcounter = 0
	var enemygroupcounter = 0
	for i in battlefield:
		if battlefield[i] == null:
			continue
		if battlefield[i].defeated == true:
			continue
		if i in range(1,4):
			playergroupcounter += 1
		else:
			enemygroupcounter += 1
	if playergroupcounter <= 0:
		defeat()
		return FIN_LOOSE
	elif enemygroupcounter <= 0:
#		curstage += 1
#		turns += 1
#		combatlogadd("\n" + " Wave %d was cleared." % (curstage + 1))
		if curstage + 1 < enemygroup_full.size():
#			combatlogadd("\n" + "New wave!")
#			buildenemygroup(enemygroup_full[curstage])
			return FIN_STAGE
		victory()
		return FIN_VIC
	return FIN_NO


func get_weapon_sound(caster):
	return caster.get_weapon_sound()


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


#position manipulation
func advance_frontrow():
	for pos in range(6, 10):
		if battlefield[pos] == null: continue
		if enemygroup[pos] == null : continue
		enemygroup[pos - 3] = enemygroup[pos]
#		enemygroup[pos] = null
		enemygroup.erase(pos)
	for i in range(6, 10):
		if battlefield[i] == null: continue
		#battlefield[i] = enemygroup[i]
		#make_fighter_panel(battlefield[i], i, false)
		battlefield[i].displaynode.disappear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	for i in range(6, 10):
		if battlefield[i] == null: continue
#		battlefield[i].displaynode.queue_free()
		battlefield[i].displaynode.visible = false
		battlefield[i] = null
	for i in range(4, 7):
		if !enemygroup.has(i): continue
		battlefield[i] = enemygroup[i]
		battlefield[i].position = i
		make_fighter_panel(battlefield[i], i, false)
		battlefield[i].displaynode.appear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	#advance_backrow()


func advance_backrow():#not used for now
	var pos = 10
	while pos < enemygroup.size():
		if enemygroup[pos] == null : continue
		enemygroup[pos - 3] = enemygroup[pos]
		enemygroup[pos] = null
	enemygroup.pop_back()
	enemygroup.pop_back()
	enemygroup.pop_back()
	for i in range(6, 10):
		battlefield[i] = enemygroup[i]
		battlefield[i].position = i
		make_fighter_panel(battlefield[i], i, false)
		battlefield[i].displaynode.appear()
	turns += 1
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')


#func advance_frontrow():
#	for pos in range(6, 10):
#		if battlefield[pos] == null: continue
#		if enemygroup[pos] == null : continue
#		enemygroup[pos - 3] = enemygroup[pos]
##		enemygroup[pos] = null
#		enemygroup.erase(pos)
#	for i in range(6, 10):
#		if battlefield[i] == null: continue
#		#battlefield[i] = enemygroup[i]
#		#make_fighter_panel(battlefield[i], i, false)
#		battlefield[i].displaynode.disappear()
#	CombatAnimations.check_start()
#	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
#	turns += 1
#	for i in range(6, 10):
#		if battlefield[i] == null: continue
#		battlefield[i].displaynode.queue_free()
#		battlefield[i] = null
#	for i in range(4, 7):
#		if !enemygroup.has(i): continue
#		battlefield[i] = enemygroup[i]
#		battlefield[i].position = i
#		make_fighter_panel(battlefield[i], i, false)
#		battlefield[i].displaynode.appear()
#	CombatAnimations.check_start()
#	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
#	turns += 1


func swap_hero(newhero):
	#remove current char
	activecharacter.displaynode.disappear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	activecharacter.position = null
	activecharacter.displaynode.queue_free()
	#add new char
	activecharacter = state.heroes[newhero]
	activecharacter.acted = true
	activecharacter.position = currentactor
	playergroup[currentactor] = activecharacter
	battlefield[currentactor] = activecharacter
	make_fighter_panel(activecharacter, currentactor, false)
	activecharacter.displaynode.appear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	
	call_deferred('select_actor')


func summon(montype, number):
	# for now summoning is implemented only for opponents
	# cause i don't know if ally summons must be player- or ai-controlled
	# and don't know if it is possible to implement ai-controlled ally
	#find empty slot in enemy group
	var group = [4,5,6,7,8,9];
	var pos = [];
	for p in group:
		if battlefield[p] == null: pos.push_back(p);
	if typeof(number) == TYPE_ARRAY:
		number = globals.rng.randi_range(number[0], number[1])
	for i in range(number):
		if pos.size() == 0: return;
		var sum_pos = pos[randi() % pos.size()];
		pos.erase(sum_pos)
		enemygroup[sum_pos] = enemy.new();
		enemygroup[sum_pos].createfromtemplate(montype, en_level);
		battlefield[sum_pos] = enemygroup[sum_pos];
		enemygroup[sum_pos].acted = true
		make_fighter_panel(battlefield[sum_pos], sum_pos);
#		state.combatparty[sum_pos] = enemygroup[sum_pos].id
		state.heroes[enemygroup[sum_pos].id] = enemygroup[sum_pos]

#combat finishes
var rewardsdict

func victory():
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	Input.set_custom_mouse_cursor(cursors.default)
	yield(get_tree().create_timer(0.5), 'timeout')
	fightover = true
	$Rewards/CloseButton.disabled = true
	input_handler.StopMusic()
	#on combat ends triggers
	for p in state.heroes.values():
		p.process_event(variables.TR_COMBAT_F)
	
	var tween = input_handler.GetTweenNode($Rewards/victorylabel)
	tween.interpolate_property($Rewards/victorylabel,'rect_scale', Vector2(1.5,1.5), Vector2(1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	input_handler.PlaySound(sounds["victory"])
	
	rewardsdict = {materials = {}, items = [], xp = 0}
	for i in defeated:
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
		state.heroes.erase(i.id)
	defeated.clear()
	
	globals.ClearContainerForced($Rewards/HBoxContainer/first)
	globals.ClearContainerForced($Rewards/HBoxContainer/second)
	globals.ClearContainer($Rewards/ScrollContainer/HBoxContainer)
	for i in state.heroes.values():
		if i.combatgroup != 'ally': continue
		if !i.unlocked:
			i.baseexp += ceil(rewardsdict.xp)
			continue
		var newbutton = globals.DuplicateContainerTemplate($Rewards/HBoxContainer/first)
		if $Rewards/HBoxContainer/first.get_children().size() >= 5:
			$Rewards/HBoxContainer/first.remove_child(newbutton)
			$Rewards/HBoxContainer/second.add_child(newbutton)
		newbutton.get_node('icon').texture = i.portrait_circle()
		newbutton.get_node("xpbar").value = i.baseexp
		var level = i.level
		i.baseexp += ceil(rewardsdict.xp)
		var subtween = input_handler.GetTweenNode(newbutton)
		if i.level > level:
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'value', newbutton.get_node("xpbar").value, 100, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'modulate', newbutton.get_node("xpbar").modulate, Color("fffb00"), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
			subtween.interpolate_callback(input_handler, 1, 'DelayedText', newbutton.get_node("xpbar/Label"), tr("LEVELUP")+ ': ' + str(i.level) + "!")
			subtween.interpolate_callback(input_handler, 1, 'PlaySound', sounds["levelup"])
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
		input_handler.PlaySound(sounds["itemget"])
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


func FinishCombat():
	for i in state.heroes.values():
		i.cooldowns.clear()
	for i in battlefield:
		if battlefield[i] != null:
			battlefield[i].displaynode.queue_free()
			battlefield[i].displaynode = null
			battlefield[i] = null
	state.cleanup()
	hide()
	input_handler.ShowGameTip('explore')
	globals.check_signal("CombatEnded", encountercode)
	input_handler.SetMusic("towntheme")
	get_parent().wincontinue()
	get_parent().levelupscheck()
#	globals.call_deferred('EventCheck')


#targeting
#rangetypes melee, any, backmelee
func get_allied_targets(fighter):
	var res = []
	if fighter.position in range(1, 4):
		for p in playergroup.values():
			if !p.defeated: res.push_back(p)
	else:
		for p in enemygroup.values():
			if !p.defeated: res.push_back(p)
	return res


func get_enemy_targets_all(fighter, hide_ignore = false):
	var res = []
	if fighter.position in range(1, 4):
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
	if fighter.position in range(1, 4):
		for p in enemygroup.values():
			if p.defeated: continue
			#if p.has_status('hide') and !hide_ignore: continue
			if CheckMeleeRange('enemy', hide_ignore) and p.position > 6: continue
			res.push_back(p)
	else:
		for p in playergroup.values():
			if p.defeated: continue
			#if p.has_status('hide') and !hide_ignore: continue
			#if CheckMeleeRange('ally', hide_ignore) and p.position > 3: continue
			res.push_back(p)
	return res


func UpdateSkillTargets(caster, glow_skip = false):
	var skill = Skillsdata.patch_skill(activeaction, caster)#Skillsdata.skilllist[activeaction]
	var fighter = caster
	var targetgroups = skill.allowedtargets
	var targetpattern = skill.targetpattern
	var rangetype = skill.userange
	ClearSkillTargets()
	
	for i in $SkillPanel/ScrollContainer/GridContainer.get_children() + $ItemPanel/ScrollContainer/GridContainer.get_children():
		if i.has_meta('skill'):
			i.pressed = i.get_meta('skill') == skill.code
	
	if rangetype == 'weapon':
		rangetype = fighter.get_weapon_range()
	
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

	for nd in battlefieldpositions.values():
		nd.stop_highlight()
	for pos in allowedtargets.enemy:
		battlefieldpositions[pos].highlight_target_enemy()
	for pos in allowedtargets.ally:
		battlefieldpositions[pos].highlight_target_ally()
	activecharacter.displaynode.highlight_active()
	cur_state = T_SKILLSELECTED


func ClearSkillTargets():
	allowedtargets.ally.clear()
	allowedtargets.enemy.clear()
#	for i in battlefield:
#		if battlefield[i] != null && battlefield[i].displaynode != null:
#			StopHighlight(i)


func CheckMeleeRange(group, hide_ignore = false): #Check if group front row is still in place
	var rval = false
	var counter = 0
	#reqires adding hide checks
	match group:
		'enemy':
			for pos in range(4,7):
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
			if target.position < 7: return true
			if !CheckMeleeRange('enemy'): return true
	#var s_code = caster.get_skill_by_tag('default')
	var skill = Skillsdata.patch_skill('attack', activecharacter)#Skillsdata.skilllist['attack']
	return (skill.userange == 'any') or (skill.userange == 'weapon' and caster.get_weapon_range() == 'any')


func refine_target(skill, caster, target): #s_skill, caster, target_positin
	var change = false
	#var skill = Skillsdata.skilllist[s_code]
	if target == null: change = true #forced change
#	elif target.defeated or target.hp <= 0: change = true #forced change. or not. nvn error
	elif skill.keep_target == variables.TARGET_NOKEEP: change = true #intentional change
	elif skill.keep_target == variables.TARGET_KEEPFIRST: skill.keep_target = variables.TARGET_NOKEEP
	elif skill.keep_target == variables.TARGET_MOVEFIRST: 
		skill.keep_target = variables.TARGET_KEEP
		change = true
	if !change: return target
	#fing new target
	match skill.next_target:
		variables.NT_ANY: 
			var avtargets = get_enemy_targets_all(caster)
			return input_handler.random_element(avtargets).position
		variables.NT_ANY_NOREPEAT: 
			var avtargets = get_enemy_targets_all(caster)
			avtargets.erase(target)
			return input_handler.random_element(avtargets).position
		variables.NT_MELEE:
			var avtargets = get_enemy_targets_melee(caster)
			return input_handler.random_element(avtargets).position
		variables.NT_WEAK:
			var avtargets = get_enemy_targets_all(caster)
			if avtargets.size() == 0: return null
			var t = 0
			for i in range(avtargets.size()):
				if avtargets[i].hp < avtargets[t].hp: t = i
			return avtargets[t].position
		variables.NT_WEAK_MELEE:
			var avtargets = get_enemy_targets_melee(caster)
			if avtargets.size() == 0: return null
			var t = 0
			for i in range(avtargets.size()):
				if avtargets[i].hp < avtargets[t].hp: t = i
			return avtargets[t].position
		variables.NT_BACK:
			if target > 6: return null
			else: return target + 3
		variables.NT_CASTER:
			return caster.position


func CalculateTargets(skill, caster, target, finale = false):
	#if target == null: return 
	var array = []
	
	var targetgroup
	
#	if target == null:
	if skill.allowedtargets.has('enemy'):
		if caster.combatgroup == 'ally': targetgroup = 'enemy'
		else: targetgroup = 'ally'
	elif skill.allowedtargets.has('ally') or skill.allowedtargets.has('self'):
		targetgroup = caster.combatgroup
#	elif int(target.position) in range(1,4):
#		targetgroup = 'ally'
#	else:
#		targetgroup = 'enemy'

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
			for j in range(1, 10):
				if j in range(1,4) && targetgroup == 'ally':
					if battlefield[j] == null : continue
					var tchar = battlefield[j]
					if tchar.defeated: continue
					#if !tchar.can_be_damaged(skill.code) and !finale: continue
					array.append(tchar)
				elif j in range(4, 10) && targetgroup == 'enemy':
					if battlefield[j] == null : continue
					var tchar = battlefield[j]
					if tchar.defeated: continue
					#if !tchar.can_be_damaged(skill.code) and !finale: continue
					array.append(tchar)
		'no_target':
			for j in range(1, 10):
				if j == target.position: continue
				if j in range(1,4) && targetgroup == 'ally':
					if battlefield[j] == null : continue
					var tchar = battlefield[j]
					if tchar.defeated: continue
					#if !tchar.can_be_damaged(skill.code) and !finale: continue
					array.append(tchar)
				elif j in range(4, 10) && targetgroup == 'enemy':
					if battlefield[j] == null : continue
					var tchar = battlefield[j]
					if tchar.defeated: continue
					#if !tchar.can_be_damaged(skill.code) and !finale: continue
					array.append(tchar)
		'sideslash':
			var tpos = [target.position]
			if target.position in [1, 4, 7]: tpos.push_back(target.position + 1)
			elif target.position in [3, 6, 9]: tpos.push_back(target.position - 1)
			else: 
				tpos.push_back(target.position + 1)
				tpos.push_back(target.position - 1)
			var tpos2 = []
			for pos in tpos: if battlefield[pos] != null: tpos2.push_back(battlefield[pos])
			if tpos2.size() == 3: tpos2.pop_back()
			array = tpos2
		'2random':
			var tpos = get_allied_targets(target)
			while tpos.size() > 2:
				var r = globals.rng.randi_range(0, tpos.size() - 1)
				tpos.remove(r)
			var tpos2 = []
			for pos in tpos: if battlefield[pos] != null: tpos2.push_back(battlefield[pos])
			array = tpos2
		'neighbours':
			var tpos = []
			if target.position in [1, 4, 7]: tpos.push_back(target.position + 1)
			elif target.position in [3, 6, 9]: tpos.push_back(target.position - 1)
			else: 
				tpos.push_back(target.position + 1)
				tpos.push_back(target.position - 1)
			if target.position in [4, 5, 6]:#not sure about this
				tpos.push_back(target.position + 3)
			var tpos2 = []
			for pos in tpos: if battlefield[pos] != null: tpos2.push_back(battlefield[pos])
			array = tpos2
	if (!finale) and skill.tags.has('random_target'):
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


#visuals
#var fighterhighlighted = false

func FighterShowStats(position):
	var panel = battlefieldpositions[position]
	panel.get_node("hplabel").show()


func FighterHideStats(position):
	var panel = battlefieldpositions[position]
	panel.get_node("hplabel").hide()
	

func FighterMouseOver(position):
	var fighter = battlefield[position]
	var node = battlefieldpositions[position]
	FighterShowStats(position)
	match cur_state:
		T_AUTO: 
			return
		T_CHARSELECT: 
			if fighter.combatgroup == 'enemy': return
			if fighter.defeated : return
			if fighter.acted: return
			node.highlight_hover()
		T_SKILLSELECTED:
			if position in allowedtargets.ally:
				Input.set_custom_mouse_cursor(cursors.support)
				for pos in allowedtargets.ally + allowedtargets.enemy:
					battlefieldpositions[pos].stop_highlight()
				var cur_targets = []
				cur_targets = CalculateTargets(Skillsdata.patch_skill(activeaction, activecharacter), activecharacter, fighter)
				for ch in cur_targets:
					ch.displaynode.highlight_target_ally_final()
				cur_state = T_TARGETOVER
				return
			if position in allowedtargets.enemy:
				Input.set_custom_mouse_cursor(cursors.attack)
				for pos in allowedtargets.ally + allowedtargets.enemy:
					battlefieldpositions[pos].stop_highlight()
				var cur_targets = []
				cur_targets = CalculateTargets(Skillsdata.patch_skill(activeaction, activecharacter), activecharacter, fighter)
				for ch in cur_targets:
					ch.displaynode.highlight_target_enemy_final()
				cur_state = T_TARGETOVER
				return
		T_TARGETOVER: 
			print("warning - mouseover while targets highlighted")
#	if (allowaction == true && charselect == false) && (allowedtargets.enemy.has(fighter.position) || allowedtargets.ally.has(fighter.position)):
#		if fighter.combatgroup == 'enemy':
#			Input.set_custom_mouse_cursor(cursors.attack)
#		else:
#			Input.set_custom_mouse_cursor(cursors.support)
#		var cur_targets = [];
#		cur_targets = CalculateTargets(Skillsdata.patch_skill(activeaction, activecharacter), activecharacter, fighter); 
#		Stop_Target_Glow();
#		for c in cur_targets:
#			Target_eff_Glow(c.position);


func FighterMouseOverFinish(position):
	Input.set_custom_mouse_cursor(cursors.default)
	var fighter = battlefield[position]
	var node = battlefieldpositions[position]
	FighterHideStats(position)
	match cur_state:
		T_AUTO: 
			return
		T_CHARSELECT: 
			if fighter.combatgroup == 'enemy': return
			if fighter.defeated : return
			if fighter.acted: return
			node.stop_highlight()
		T_TARGETOVER:
			for nd in battlefieldpositions.values():
				nd.stop_highlight()
			for pos in allowedtargets.enemy:
				battlefieldpositions[pos].highlight_target_enemy()
			for pos in allowedtargets.ally:
				battlefieldpositions[pos].highlight_target_ally()
			cur_state = T_SKILLSELECTED
			activecharacter.displaynode.highlight_active()
			return
		T_SKILLSELECTED: 
			if !(position in allowedtargets.ally + allowedtargets.enemy):
				return
			print("warning - mouseover finish while targets not highlighted")
#	var fighter = battlefield[position]
#	FighterHideStats(fighter)
#	if !allowaction: return;
#	var panel = fighter.displaynode
#	fighterhighlighted = false
#	if variables.CombatAllyHpAlwaysVisible == false || fighter.combatgroup == 'enemy':
#		panel.get_node("hplabel").hide()
#		panel.get_node("mplabel").hide()
#	Input.set_custom_mouse_cursor(cursors.default)
#	Stop_Target_Glow();
#	for f in allowedtargets.enemy:
#		Target_Glow(f);
#	for f in allowedtargets.ally:
#		Target_Glow(f);


func ShowFighterStats(fighter): #obviosly we need to turn statspanel into isolated scene to handle all statlist changes 
	if cur_state == T_AUTO:
		return
	if fightover == true:
		return
	var text = ''
	if fighter.combatgroup == 'ally':

		$StatsPanel/hp.text = 'Health: ' + str(fighter.hp) + '/' + str(fighter.get_stat('hpmax'))
	else:
		$StatsPanel/hp.text = 'Health: ' + str(round(globals.calculatepercent(fighter.hp, fighter.get_stat('hpmax')))) + "%"
	$StatsPanel/damage.text = "Damage: " + str(round(fighter.get_stat('damage'))) 
	$StatsPanel/crit.text = tr("CRITICAL") + ": " + str(fighter.get_stat('critchance')) + "%/" + str(fighter.get_stat('critmod')*100) + '%' 
	$StatsPanel/hitrate.text = "Hit Rate: " + str(fighter.get_stat('hitrate'))
	$StatsPanel/evasion.text =  "Evasion: " + str(fighter.get_stat('evasion')) 

	for i in ['slash', 'pierce', 'bludgeon', 'light', 'dark', 'air', 'water', 'earth', 'fire']:
		get_node("StatsPanel/resist"+i).text = "Resist " + i.capitalize() + ": " + str(fighter.get_stat('resists')[i]) + " "
	$StatsPanel.show()
	$StatsPanel/name.text = tr(fighter.name)
	$StatsPanel/descript.text = fighter.flavor
	$StatsPanel/TextureRect.texture = fighter.combat_full_portrait()
	for b in fighter.get_all_buffs():
		text += b.name + '\n'
	$StatsPanel/effects.bbcode_text = text


func HideFighterStats():
	$StatsPanel.hide()


func FighterPress(position):
	if allowaction == false : return
	match cur_state:
		T_AUTO: 
			return
		T_CHARSELECT: 
			if position > 3:
				return
			if battlefield[position] == null: return
			if battlefield[position].acted: return
			if battlefield[position].defeated: return
			cur_state = T_AUTO
			player_turn(position)
		T_TARGETOVER:
			if allowedtargets.ally.has(position) or allowedtargets.enemy.has(position):
				cur_state = T_AUTO
				use_skill(activeaction, activecharacter, position)
				return
		T_SKILLSELECTED: 
			if allowedtargets.ally.has(position) or allowedtargets.enemy.has(position):
				print("warning - allowed target not highlighted properly")
				cur_state = T_AUTO
				use_skill(activeaction, activecharacter, position)
			return
#	if charselect:
#		if pos > 3: return
#		if battlefield[pos] == null: return
#		if battlefield[pos].displaynode.disabled: return
#		self.charselect = false
#		player_turn(pos)
#		return
#	if (!allowedtargets.enemy.has(pos) && !allowedtargets.ally.has(pos)):
#		return
#	ClearSkillTargets()
#	ClearItemPanel()
#	ClearSkillPanel()
#	use_skill(activeaction, activecharacter, pos)


func ProcessSfxTarget(sfxtarget, caster, target):
	match sfxtarget:
		'caster':
			return caster.displaynode
		'target':
			return target.displaynode
		'caster_group':
			return caster.displaynode.get_parent().get_parent()
		'target_group':
			return target.displaynode.get_parent().get_parent()
		'full':
			return $battlefield



#skill use
func use_skill(skill_code, caster, target_pos): #code, caster, target_position
	for nd in battlefieldpositions.values():
		nd.stop_highlight()
	turns += 1
	var target = battlefield[target_pos]
	if activeaction != skill_code: activeaction = skill_code
	allowaction = false
	
	var skill = Skillsdata.patch_skill(skill_code, caster)#Skillsdata.skilllist[skill_code]
	if skill.has('follow_up'):
		follow_up_skill = skill.follow_up
		follow_up_flag = true
	elif skill.has('follow_up_cond'):
		follow_up_skill = skill.follow_up_cond
		follow_up_flag = false
	else:
		follow_up_skill = null
		follow_up_flag = false
	
	if caster != null && skill.name != "":
		if activeitem:
			combatlogadd("\n" + caster.name + ' uses ' + activeitem.name + ". ")
			print(caster.name + ' uses ' + activeitem.name)
		else:
			combatlogadd("\n" + caster.name + ' uses ' + skill.name + ". ")
#			combatlogadd("\n" + str(caster.position) + ' uses ' + skill.name + ". ")
			print(str(caster.position) + ' uses ' + skill.name)
#		caster.mana -= skill.manacost
		
		if skill.cooldown > 0:
			caster.cooldowns[skill_code] = skill.cooldown
	
	#caster part of setup
	var s_skill1 = S_Skill.new()
	s_skill1.createfromskill(skill_code, caster)
	#s_skill1.setup_caster(caster)
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
	var n = 0
	while n < s_skill1.repeat:
		n += 1
		#get all affected targets
		var newtarget = refine_target(s_skill1, caster, target_pos)
		if newtarget == null: #finish skill usage
			turns += 1
			s_skill1.process_event(variables.TR_SKILL_FINISH)
			caster.process_event(variables.TR_SKILL_FINISH, s_skill1)
			s_skill1.remove_effects()
			#follow-up
			if skill.has('follow_up'):
				yield(use_skill(skill.follow_up, caster, target_pos), 'completed')
			if skill.has('not_final'): return
			#final
			turns += 1
			if activeitem != null:
				activeitem.amount -= 1
				activeitem = null
				SelectSkill(caster.get_skill_by_tag('default'))
			
			caster.rebuildbuffs()
#			if fighterhighlighted == true:
#				FighterMouseOver(target)
			#print(caster.name + ' finished attacking')
			if caster.combatgroup == 'ally':
				var temp = 0
				for pos in range(4, 7): if  battlefield[pos] == null: temp += 1
				if temp == 3: 
					yield(advance_frontrow(), 'completed')
			turns += 1
			CombatAnimations.check_start()
			if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
			if endturn or caster.hp <= 0 or !caster.can_act():
				#on end turn triggers
				caster.process_event(variables.TR_TURN_F)
				caster.displaynode.process_disable()
				call_deferred('select_actor')
				eot = false
			else:
				if caster.combatgroup == 'ally':
					CombatAnimations.check_start()
					if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
				allowaction = true
				RebuildSkillPanel()
				RebuildItemPanel()
				SelectSkill(activeaction)
				eot = true
			return
		target_pos = newtarget
		target = battlefield[newtarget]
		if target == null and !skill.tags.has('empty_target'): continue
		targets = CalculateTargets(skill, caster, target, true) 
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
				if !rules.has('no_res'): i.resurrect(skill.value[0]) #not sure
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
				combatlogadd(s_skill2.target.name + " evades the damage.")
#				Off_Target_Glow()
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
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
		print(str(caster.position) + ' finishing ' + skill.name)
		#postdamage triggers and cleanup real_target s_skills
		var fkill = false
		for s_skill2 in s_skill2_list:
			s_skill2.process_event(variables.TR_POSTDAMAGE)
			s_skill2.caster.process_event(variables.TR_POSTDAMAGE, s_skill2)
			if s_skill2.target.hp <= 0:
				fkill = true
				s_skill2.target.process_event(variables.TR_DEATH)
				s_skill2.caster.process_event(variables.TR_KILL)
			else:
				s_skill2.target.process_event(variables.TR_POST_TARG, s_skill2)
			checkdeaths()
			if s_skill2.target.displaynode != null:
				s_skill2.target.rebuildbuffs()
#			Off_Target_Glow();
			s_skill2.remove_effects()
		if fkill: s_skill1.process_event(variables.TR_KILL)
	turns += 1
	s_skill1.process_event(variables.TR_SKILL_FINISH)
	caster.process_event(variables.TR_SKILL_FINISH, s_skill1)
	s_skill1.remove_effects()
	
	var f = checkwinlose()
	if f != FIN_NO:
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
		q_skills.clear()
		if f == FIN_STAGE: 
			call_deferred('select_actor')
		return
	#follow-up
	if follow_up_flag and (follow_up_skill != null):
		yield(use_skill(follow_up_skill, caster, target_pos), 'completed')
	if skill.has('not_final'): 
		print(str(caster.position) + ' ended pretime ' + skill.name)
		return
	
	print(str(caster.position) + ' almost ended ' + skill.name)
	
	#use queued skills
	while !q_skills.empty():
		var tdata = q_skills.pop_front()
		yield(use_skill(tdata.skill, tdata.caster, tdata.target), 'completed')
	
	#final
	turns += 1
	if activeitem != null:
		activeitem.amount -= 1
		activeitem = null
		SelectSkill(caster.get_skill_by_tag('default'))
	
	caster.rebuildbuffs()
#	if fighterhighlighted == true:
#		FighterMouseOver(target)
	#print(caster.name + ' finished attacking')

	if caster.combatgroup == 'ally' and checkwinlose() == FIN_NO:
		var temp = 0
		for pos in range(4, 7): if  battlefield[pos] == null: temp += 1
		if temp == 3: 
			yield(advance_frontrow(), 'completed')
	turns +=1
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	if endturn or caster.hp <= 0 or !caster.can_act():
		#on end turn triggers
		caster.process_event(variables.TR_TURN_F)
		caster.displaynode.process_disable()
		call_deferred('select_actor')
		eot = false
	else:
		if caster.combatgroup == 'ally':
			CombatAnimations.check_start()
			if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
		allowaction = true
		RebuildSkillPanel()
		RebuildItemPanel()
		SelectSkill(activeaction)
		eot = true
	print(str(caster.position) + ' ended ' + skill.name)


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
#		elif s_skill2.damagestat[i] == '+restore_mana': #heal, heal no log
#			if !s_skill2.tags.has('no log'):
#				var rval = s_skill2.target.mana_update(s_skill2.value[i])
#				text += "%s restored %d mana." %[s_skill2.target.name, rval] 
#			else:
#				s_skill2.target.mana_update(s_skill2.value[i])
#		elif s_skill2.damagestat[i] == '-restore_mana': #drain, damage, damage no log, drain no log
#			var rval = s_skill2.target.mana_update(-s_skill2.value[i])
#			if s_skill2.is_drain:
#				var rval2 = s_skill2.caster.mana_update(rval)
#				if !s_skill2.tags.has('no log'):
#					text += "%s drained %d mana from %s and gained %d mana." %[s_skill2.caster.name, rval, s_skill2.target.name, rval2]
#			if !s_skill2.tags.has('no log'):
#				text += "%s lost %d mana." %[s_skill2.target.name, rval] 
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


#panels
func ClearSkillPanel():
	globals.ClearContainer($SkillPanel/ScrollContainer/GridContainer)


func RebuildSkillPanel():
	ClearSkillPanel()
	for i in activecharacter.skills:
		var newbutton = globals.DuplicateContainerTemplate($SkillPanel/ScrollContainer/GridContainer)
		var skill = Skillsdata.patch_skill(i, activecharacter)#Skillsdata.skilllist[i]
		newbutton.get_node("Icon").texture = skill.icon
#		newbutton.get_node("manacost").text = str(skill.manacost)
#		if skill.manacost <= 0:
#			newbutton.get_node("manacost").hide()
		if activecharacter.cooldowns.has(i):
			newbutton.disabled = true
			newbutton.get_node("Icon").material = load("res://assets/sfx/bw_shader.tres")
		if !activecharacter.process_check(skill.reqs):
			newbutton.disabled = true
			newbutton.get_node("Icon").material = load("res://assets/sfx/bw_shader.tres")
		if !activecharacter.can_use_skill(skill):
			newbutton.disabled = true
			newbutton.get_node("Icon").material = load("res://assets/sfx/bw_shader.tres")
		newbutton.connect('pressed', self, 'SelectSkill', [skill.code])
#		if activecharacter.mana < skill.manacost:
#			newbutton.get_node("Icon").modulate = Color(0,0,1)
#			newbutton.disabled = true
#			newbutton.get_node("Icon").material = load("res://assets/sfx/bw_shader.tres")
		newbutton.set_meta('skill', skill.code)
		globals.connectskilltooltip(newbutton, i, activecharacter)


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


#simple actions
func combatlogadd(text):
	var data = {node = self, time = turns, type = 'c_log', slot = 'c_log', params = {text = text}}
	CombatAnimations.add_new_data(data)


func combatlogadd_q(text):
	$Combatlog/RichTextLabel.append_bbcode(text)


func res_all(hpval):
	var p = playergroup
#	if party == 'ally':
#		p = playergroup
#	if party == 'enemy':
#		p = enemygroup
	for ch in p.values():
		if ch.defeated: 
			ch.defeated = false
			ch.hppercent = hpval
			ch.acted = false # or not


func miss(fighter):
	CombatAnimations.miss(fighter.displaynode)

#part for missing swap char panel
#pathes may be subject of changing
#mb need all this part to move to apopriate (non-existing now) scene
func UpdateCharPanel():
	var pan = get_node("CharSwitchPanel")
	var chpool = []
	for nm in state.characters:
		var ch = state.heroes[nm]
		if !ch.unlocked:
			continue 
		if ch.position != null:
			continue
		if ch.hp <= 0:
			continue
		chpool.push_back(ch)
	if chpool.size() == 0:
		pan.get_node("no_chars").visible = true
		pan.get_node("char1").visible = false
		pan.get_node("char2").visible = false
		pan.get_node("char3").visible = false
	else:
		pan.get_node("no_chars").visible = false
#		pan.get_node("char1").visible = false
#		pan.get_node("char2").visible = false
#		pan.get_node("char3").visible = false
		if chpool.size() == 1:
			pan.get_node("char1").visible = false
			pan.get_node("char2").visible = true
			setup_swap_portrait(pan.get_node("char2"), chpool[0])
			pan.get_node("char3").visible = false
		if chpool.size() == 2:
			pan.get_node("char1").visible = true
			setup_swap_portrait(pan.get_node("char1"), chpool[0])
			pan.get_node("char2").visible = false
			pan.get_node("char3").visible = true
			setup_swap_portrait(pan.get_node("char3"), chpool[1])
		if chpool.size() == 3:
			pan.get_node("char1").visible = true
			setup_swap_portrait(pan.get_node("char1"), chpool[0])
			pan.get_node("char2").visible = true
			setup_swap_portrait(pan.get_node("char2"), chpool[1])
			pan.get_node("char3").visible = true
			setup_swap_portrait(pan.get_node("char3"), chpool[2])
	pan.visible = true


func setup_swap_portrait(node, ch):
	node.get_node('icon').texture = ch.combaticon
	node.get_node('name').text = ch.name
	node.hint_tooltip = ch.flavor
	node.connect('pressed', self, 'swap_hero', [ch.id])
	#possibly add more info


func hide_swap_panel():
	var pan = get_node("CharSwitchPanel")
	pan.visible = false
