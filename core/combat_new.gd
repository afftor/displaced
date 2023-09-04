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
onready var gui_node = $gui
onready var resist_tooltip = $ResistToolTipCont/ResistToolTip

var debug = false

var allowaction = false
var highlightargets = false
var allowedtargets = {'ally':[],'enemy':[]}
var swapchar = null

var fightover = false #for victory
var fight_finished = false #for FinishCombat
var leveled_up_chars = []

var playergroup = {}
var enemygroup_full = []
var enemygroup = {}
var currentactor

var summons = []
var rules = []
var aura_effects = {ally = [], enemy = []}
var aura_bonuses = {ally = {}, enemy = {}}

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
onready var battlefieldpositions = {
	'arron': $battlefield/PlayerGroup/Front/arron,
	'ember':$battlefield/PlayerGroup/Front/ember,
	'erika':$battlefield/PlayerGroup/Front/erika,
	'iola':$battlefield/PlayerGroup/Front/iola,
	'rilu':$battlefield/PlayerGroup/Front/rilu,
	'rose':$battlefield/PlayerGroup/Front/rose,
	4 : $battlefield/EnemyGroup/Front/left,
	5 : $battlefield/EnemyGroup/Front/mid,
	6 : $battlefield/EnemyGroup/Front/right,
	7: $battlefield/EnemyGroup/Back/left,
	8 : $battlefield/EnemyGroup/Back/mid,
	9 : $battlefield/EnemyGroup/Back/right}

#player party should be placed onto 1-3 positions
var positions = {
	1: Vector2(403, 124),
	2: Vector2(259, 323),
	3: Vector2(192, 532),
	4: Vector2(1085, 55),
	5: Vector2(1170, 325),
	6: Vector2(1255, 595),
	7: Vector2(1360, 55),
	8: Vector2(1445, 325),
	9: Vector2(1530, 595),
}

var eot = true
var nextenemy = 7
var curstage = 0
var defeated := []

var q_skills = []

enum {FIN_NO, FIN_STAGE, FIN_VIC, FIN_LOOSE}

var sounds = {
	"victory" : "sound/victory",
	"itemget" : "sound/itemget_1",
	"levelup" : "sound/levelup",
	"start" : "sound/battle_start",
	"levelup_show" : "sound/level_up_window",
	"move_hero" : "sound/dodge"
}

enum {
# T_CHARSELECT,
 T_SKILLSUPPORT, #support skill selected - only targeting mode
 T_SKILLATTACK, #attacking skill selected - T_CHARSELECT + T_SKILLSUPPORT
 T_OVERATTACK, #over possible target for attack
 T_OVERSUPPORT, #over possible target for suuport
 T_OVERATTACKALLY, #over friendly char while having attacking skill selected
 T_AUTO #animations active
}
var cur_state = T_AUTO

signal combat_started
signal turn_started
signal combat_ended
signal player_ready
#feel free to add state signals per need

var is_player_turn = false
var skill_in_progress = false

var resist_tooltip_for_pos = -1

func _ready():
	for i in sounds.values():
		resources.preload_res(i)
	if resources.is_busy(): yield(resources, "done_work")

	for i in range(1,10):
		battlefield[i] = null
#	for i in range(7,13):
#		enemygroup[i] = null
	add_child(CombatAnimations)
	for nd in get_tree().get_nodes_in_group('sfx_a'):
		nd.set_script(load("res://files/scenes/combat/combat_sfx_anchor.gd"))
		nd.set_animation_node(CombatAnimations)
#warning-ignore:return_value_discarded
#	$ItemPanel/debugvictory.connect("pressed",self, 'cheatvictory')
#warning-ignore:return_value_discarded
	$Rewards/CloseButton.connect("pressed",self,'FinishCombat', [true])
	$LevelUp/panel/CloseButton.connect("pressed",self,'on_level_up_close')
	
	TutorialCore.register_static_button("enemy",
		battlefieldpositions[4], 'signal_LMB')
	TutorialCore.register_static_button("character",
		battlefieldpositions['rose'], 'signal_LMB')


func cheatvictory():
	for i in enemygroup.values():
		i.hp = 0
	#checkwinlose()

func _process(delta):
	pass

func test_combat():
#	if resources.is_busy(): yield(resources, "done_work")
#
#	state.add_test_resources()
#
#	for ch in state.characters:
#		state.unlock_char(ch)
#		state.heroes[ch].level = 39
#		state.heroes[ch].hp = state.heroes[ch].hpmax
#	state.heroes.arron.position = 1
#	state.heroes.ember.position = 2
##	state.heroes.rose.position = 3
#
#	show()
#	start_combat([{1:'elvenrat', 4: ['elvenrat', 10]}, {3:'elvenrat', 5: 'elvenrat'}], 40, 'combat_cave')

	var party = [
		{ 1 : ['bomber'], 2 : ['bomber'], 3 : ['bomber'], 
		4 : ['bomber'], 5 : ['bomber'], 6 : ['bomber']}
	]
	input_handler.explore_node.set_party_level_data(party, 27, 27)
	show()
	start_combat(party, 27, 'combat_cave')

#battlefield setup
func start_combat(newenemygroup, level, background, music = 'combattheme'):
	hide_resist_tooltip()
	input_handler.combat_node = self
	turns = 0
	en_level = level
	resources.preload_res("music/%s" % music)
	if resources.is_busy(): yield(resources, "done_work")
	
	rules.clear()
	aura_effects.ally.clear()
	aura_effects.enemy.clear()
	aura_bonuses.ally.clear()
	aura_bonuses.enemy.clear()
	
#	$Background.texture = images.backgrounds[background]
	if background is Array:
		background = input_handler.random_element(background)
	var tmp = resources.get_res("bg/%s" % background)
	$Background.texture = tmp
	$Combatlog/RichTextLabel.clear()
	for i in battlefieldpositions:
		battlefieldpositions[i].set_animation_node(CombatAnimations)
	for i in range (1, 10):
		battlefield[i] = null
	enemygroup.clear()
	playergroup.clear()

	input_handler.PlaySound(sounds["start"])
	input_handler.SetMusic(music, 50)
	fightover = false
	fight_finished = false
	$Rewards.visible = false
	$LevelUp.visible = false
	allowaction = false
	skill_in_progress = false
	curstage = 0
	defeated.clear()
	enemygroup_full = newenemygroup
	buildenemygroup(enemygroup_full[curstage])
	buildplayergroup()
	#victory()
	#start combat triggers
#	for i in battlefield:
#		if battlefield[i] == null: continue
#		battlefield[i].process_event(variables.TR_COMBAT_S)
#		battlefield[i].rebuildbuffs()
	gui_node.combat_start()
#	input_handler.ShowGameTip('aftercombat')
	gui_node.build_enemy_head()
	emit_signal("combat_started")
	newturn()
	call_deferred('select_actor')


func run():
	if !allowaction: return
	FinishCombat(false)

func buildenemygroup(group):
	for i in range(4,7):
		if group.has(i) and group[i] != null:
			group[i+3] = group[i]
		else:
			group[i+3] = null
		group.erase(i)
	for i in range(1,4):
		if group.has(i) and group[i] != null:
			group[i+3] = group[i]
		else:
			group[i+3] = null
		group.erase(i)

	for i in group:
		if group[i] == null:
			battlefield[i] = null
			var panel = gui_node.get_enemy_panel(i)
			panel.disabled = true
			for n in panel.get_children():
				n.visible = false
			continue
		if typeof(group[i]) == TYPE_DICTIONARY:
			var tempname = group[i].unit
			enemygroup[i] = enemy.new()
			enemygroup[i].createfromtemplate(tempname, group[i].level)
		elif typeof(group[i]) == TYPE_ARRAY:
			var tempname = group[i][0]
			enemygroup[i] = enemy.new()
			enemygroup[i].createfromtemplate(tempname, group[i][1])
		else:
			var tempname = group[i]
			enemygroup[i] = enemy.new()
			enemygroup[i].createfromtemplate(tempname, en_level)
		enemygroup[i].position = i
		battlefield[i] = enemygroup[i]
		make_fighter_panel(battlefield[i], i)
		enemygroup[i].displaynode.appear_move()
	gui_node.build_enemy_panels()
	turns += 1
	for i in enemygroup:
		enemygroup[i].process_event(variables.TR_COMBAT_S)


func buildplayergroup():
	var newgroup = {}
	for ch in state.characters:
		var hero = state.heroes[ch]
		if hero.position == null:
			pass
		else:
			battlefield[hero.position] = hero
			newgroup[hero.position] = hero
		make_hero_panel(hero)
		hero.process_event(variables.TR_COMBAT_S)
	playergroup = newgroup
	gui_node.RebuildReserve(true)
	gui_node.build_hero_panels()


func make_fighter_panel(fighter, spot, show = true):
	var panel = battlefieldpositions[spot]
	panel.panel_node = gui_node.get_enemy_panel(spot)
	panel.setup_character(fighter)
	panel.set_global_position(positions[spot])
	panel.visible = show
	panel.noq_rebuildbuffs(fighter.get_all_buffs())


func make_hero_panel(fighter, show = true):
	var spot = fighter.position
	var panel = battlefieldpositions[fighter.id]
	panel.panel_node = gui_node.get_hero_panel(fighter.id)
	panel.panel_node2 = gui_node.get_hero_reserve(fighter.id)
	panel.setup_character(fighter)
	panel.visible = show
	if spot != null:
		panel.set_global_position(positions[spot])
#		print(panel.rect_global_position)
	else:
		panel.set_global_position(Vector2(0,0))
		panel.visible = false
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
		if i.displaynode.visible: i.displaynode.process_enable()
		i.tick_cooldowns()
	turns +=1
	gui_node.RebuildReserve()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	emit_signal("turn_started")


func select_actor():
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	ClearSkillTargets()
	gui_node.ClearSkillPanel()
	gui_node.ClearItemPanel()
	gui_node.active_panel.visible = false
	gui_node.active_panel2.visible = false
	checkdeaths()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	
	var f = checkwinlose()
	if f == FIN_VIC or f == FIN_LOOSE:
		return
	if f == FIN_NO:
		var noone_at_front = true
		for pos in range(4, 7):
			if battlefield[pos] != null:
				noone_at_front = false
				break
		if noone_at_front:
			yield(advance_frontrow(), 'completed')
#	self.charselect = false
	while battlefield.has(nextenemy) and battlefield[nextenemy] == null:
		nextenemy += 1
	if f == FIN_STAGE :
		turns += 1
		curstage += 1
		combatlogadd("\n" + " Wave %d was cleared." % curstage)
		combatlogadd("\n" + "New wave!")
		buildenemygroup(enemygroup_full[curstage])
		gui_node.build_enemy_head()
		newturn()
#	elif get_avail_char_number('enemy') == 0:
	elif nextenemy == 10:
		newturn()
	
	if get_avail_char_number('ally') > 0:
		is_player_turn = true
		turns += 1
		CombatAnimations.check_start()
		if CombatAnimations.is_busy:
			yield(CombatAnimations, 'alleffectsfinished')
#		allowaction = true
		cur_state = T_AUTO
		autoselect_player_char()
#		cur_state = T_CHARSELECT
#		self.charselect = true
	else:
		is_player_turn = false
		enemy_turn(nextenemy)


func autoselect_player_char():
	for i in variables.playerparty:
		var ch = battlefield[i]
		if ch == null : continue
		if ch.acted: continue
		if ch.defeated: continue
		player_turn(i)
		return
	print ("error - no possible chars while having them when counting")


func player_turn(pos):
	turns += 1
	currentactor = pos
	var selected_character = playergroup[pos]
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

	gui_node.RebuildItemPanel()
	gui_node.RebuildDefaultsPanel()
	gui_node.RebuildSkillPanel()
	SelectSkill(selected_character.get_autoselected_skill(), true)
	emit_signal('player_ready')

func select_player_char(char_id):
	for pos in variables.playerparty:
		var ch = battlefield[pos]
		if (ch != null and ch.id == char_id and
				!ch.acted and !ch.defeated):
			player_turn(pos)
			return


func enemy_turn(pos):
	gui_node.RebuildSkillPanel()
	turns += 1
	nextenemy += 1
	var fighter = enemygroup[pos]
	#fighter.update_timers()
	fighter.process_event(variables.TR_TURN_GET)
	fighter.rebuildbuffs()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	if !fighter.can_act():
		fighter.acted = true
		#combatlogadd("%s cannot act" % fighter.name)
		fighter.process_event(variables.TR_TURN_F)
		fighter.rebuildbuffs()
		call_deferred('select_actor')
		return
	#Selecting active skill
	
#	Highlight(pos, 'enemy')
	fighter.acted = true
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
	gui_node.build_selected_item(item)
	#UpdateSkillTargets()


func SelectSkill(skill, system = false):
	swapchar = null
	activecharacter.displaynode.highlight_active()
	Input.set_custom_mouse_cursor(cursors.default)
	skill = Skillsdata.patch_skill(skill, activecharacter)#Skillsdata.skilllist[skill]
	#need to add daily restriction check
	if !activecharacter.can_use_skill(skill) :
		#SelectSkill('attack')
		call_deferred('SelectSkill', ['attack', true])
		return
#	activecharacter.selectedskill = skill.code
	activeaction = skill.code
	UpdateSkillTargets(activecharacter)
	if allowedtargets.ally.empty() and allowedtargets.enemy.empty():
		if checkwinlose() == FIN_NO:
			print ('no legal targets')
			combatlogadd('No legal targets')
			call_deferred('SelectSkill', ['attack', true])
			return
	if skill.allowedtargets.has('self') and skill.allowedtargets.size() == 1 :
		globals.closeskilltooltip()
#		activecharacter.selectedskill = 'attack'
		call_deferred('use_skill', activeaction, activecharacter, activecharacter.position)
	if !allowedtargets.ally.empty():
		cur_state = T_SKILLSUPPORT
	else:
		cur_state = T_SKILLATTACK
	gui_node.build_selected_skill(skill)

#helpers
func get_avail_char_number(group):
	var res = 0
	var rg
	if group == 'ally': rg = [1, 2 ,3]
	else: rg = [4, 5, 6, 7, 8, 9]
	for i in rg:
		if battlefield[i] == null: continue
		if battlefield[i].defeated: continue
#		if battlefield[i].acted: continue
		if !battlefield[i].can_act(): continue
		res += 1
	return res

func SelectExchange(char_id):
	activecharacter.displaynode.highlight_active()
	Input.set_custom_mouse_cursor(cursors.default)
	#need to add daily restriction check
	ClearSkillTargets()
	for pos in variables.playerparty:
		if battlefield[pos] == null: continue
		if battlefield[pos].acted: continue
		allowedtargets.ally.push_back(pos)
	
	if allowedtargets.ally.empty():
		print("error - no char to swap")
	else:
		cur_state = T_SKILLSUPPORT
		swapchar = char_id
		gui_node.build_selected_char(state.heroes[char_id])




func get_first_avail_hero():
	for i in [1, 2 ,3]:
		if battlefield[i] == null: continue
		if battlefield[i].defeated: continue
#		if battlefield[i].acted: continue
		if !battlefield[i].can_act(): continue
		return battlefield[i]
	return null


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
			res = is_player_turn
		'is_enemy_turn':
			res = !is_player_turn
	return res


func checkdeaths():
	for i in battlefield:
		if battlefield[i] != null && battlefield[i].defeated != true && battlefield[i].hp <= 0:
			battlefield[i].death()
			hide_resist_tooltip_if_my(i)
			combatlogadd("\n" + battlefield[i].name + " has been defeated.")
			#add fix around defeated player chars
			if i > 3:
				defeated.push_back(battlefield[i])
#				battlefield[i].displaynode.visible = false
#				battlefield[i].displaynode = null
#				battlefield[i] = null
#				enemygroup.erase(i)
				#add state-based kill effects here
				for pos in variables.playerparty:
					if battlefield[pos] == null: continue
					battlefield[pos].see_enemy_killed()
		if battlefield[i] != null && battlefield[i].has_status('charmed'):
			combatlogadd("\n" + battlefield[i].name + "is charmed and has been removed from combat.")
			defeated.push_back(battlefield[i])
			#2fix
			
#			battlefield[i].displaynode.queue_free()
#			battlefield[i].displaynode = null
#			battlefield[i] = null
#			enemygroup.erase(i)

func remove_enemy(pos, id):
	if battlefield[pos].id != id or enemygroup[pos].id != id:
		return
	enemygroup.erase(pos)
	battlefield[pos] = null

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
		FinishCombat(false)
		return FIN_LOOSE
	elif enemygroupcounter <= 0:
		if curstage + 1 < enemygroup_full.size():
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
	rval = 'sound/slash' #stub
	
	return rval


#position manipulation
func advance_frontrow():
	nextenemy = 4
	
	for pos in range(7, 10):
		if battlefield[pos] == null: continue
		if enemygroup[pos] == null : continue
		enemygroup[pos - 3] = enemygroup[pos]
		enemygroup.erase(pos)
	for i in range(7, 10):
		if battlefield[i] == null: continue
		battlefield[i].displaynode.disable_panel_node()
		battlefield[i].displaynode.visible = false
		battlefield[i] = null
	for i in range(4, 7):
		if !enemygroup.has(i): continue
		if enemygroup[i].defeated: continue
		battlefield[i] = enemygroup[i]
		battlefield[i].position = i
		make_fighter_panel(battlefield[i], i, false)
#		battlefield[i].displaynode.appear()
		battlefield[i].displaynode.advance_move()
	
	gui_node.build_enemy_panels()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	recheck_auras()


#func advance_backrow():#not used for now
#	var pos = 10
#	while pos < enemygroup.size():
#		if enemygroup[pos] == null : continue
#		enemygroup[pos - 3] = enemygroup[pos]
#		enemygroup[pos] = null
#	enemygroup.pop_back()
#	enemygroup.pop_back()
#	enemygroup.pop_back()
#	for i in range(6, 10):
#		battlefield[i] = enemygroup[i]
#		battlefield[i].position = i
#		make_fighter_panel(battlefield[i], i, false)
#		battlefield[i].displaynode.appear()
#	turns += 1
#	CombatAnimations.check_start()
#	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
#	turns += 1
#	recheck_auras()


func swap_active_hero():#not used
	var newhero = swapchar
	swapchar = null
	#remove current char
	activecharacter.acted = true
	activecharacter.displaynode.disappear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	activecharacter.position = null
	#add new char
	activecharacter = state.heroes[newhero]
#	activecharacter.acted = true
	activecharacter.position = currentactor
	playergroup[currentactor] = activecharacter
	battlefield[currentactor] = activecharacter
	make_hero_panel(activecharacter, false)
	activecharacter.displaynode.appear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	
	recheck_auras()
	gui_node.RebuildReserve()
	call_deferred('select_actor')
	


func swap_heroes_old(pos):
	var newhero = swapchar
	swapchar = null
	#remove current char
	var targetchar = battlefield[pos]
	targetchar.displaynode.disappear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	targetchar.position = null
	make_hero_panel(targetchar)
	#add new char
	var newchar = state.heroes[newhero]
#	activecharacter.acted = true
	newchar.position = pos
	playergroup[pos] = newchar
	battlefield[pos] = newchar
	make_hero_panel(newchar, false)
	newchar.displaynode.appear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	
	recheck_auras()
	gui_node.RebuildReserve()
	gui_node.build_hero_panels()
	call_deferred('select_actor')


func move_hero(chid, pos): #reserve -> bf
	gui_node.activate_shades([])
	gui_node.hide_screen()
	allowaction = false
	var newchar = state.heroes[chid]
	if battlefield[pos] != null:
		var targetchar = battlefield[pos]
		targetchar.displaynode.disappear()
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
		turns += 1
		targetchar.position = null
		make_hero_panel(targetchar)
		#add new char
	#	activecharacter.acted = true
	newchar.position = pos
	playergroup[pos] = newchar
	battlefield[pos] = newchar
	make_hero_panel(newchar, false)
	gui_node.build_hero_panels()
	input_handler.PlaySound(sounds["move_hero"])
	newchar.displaynode.appear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	
	recheck_auras()
	gui_node.RebuildReserve()
	allowaction = true
	call_deferred('select_actor')


func reserve_hero(chid): #bf -> reserve
	gui_node.activate_shades([])
	gui_node.hide_screen()
	allowaction = false
	var newchar = state.heroes[chid]
	var pos = newchar.position
	input_handler.PlaySound(sounds["move_hero"])
	newchar.displaynode.disappear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	newchar.position = null
	make_hero_panel(newchar)
#	CombatAnimations.check_start()
#	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
#	turns += 1
	playergroup.erase(pos)
	battlefield[pos] = null
	recheck_auras()
	gui_node.RebuildReserve()
	gui_node.build_hero_panels()
	allowaction = true
	call_deferred('select_actor')


func swap_heroes(chid, pos): #bf <-> bf
	gui_node.activate_shades([])
	gui_node.hide_screen()
	allowaction = false
	var newchar = state.heroes[chid]
	var tpos = newchar.position
	var targetchar = null
	input_handler.PlaySound(sounds["move_hero"])
	if battlefield[pos] != null:
		targetchar = battlefield[pos]
#		print(targetchar.id)
		targetchar.displaynode.disappear()
	newchar.displaynode.disappear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	if targetchar != null:
		targetchar.position = tpos
		playergroup[tpos] = targetchar
		battlefield[tpos] = targetchar
		make_hero_panel(targetchar, false)
		targetchar.displaynode.appear()
	else:
		playergroup.erase(tpos)
		battlefield[tpos] = null
		#add new char
	#	activecharacter.acted = true
	newchar.position = pos
	playergroup[pos] = newchar
	battlefield[pos] = newchar
	make_hero_panel(newchar, false)
	gui_node.build_hero_panels()
	newchar.displaynode.appear()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	turns += 1
	
	recheck_auras()
	allowaction = true
#	gui_node.RebuildReserve()
	call_deferred('select_actor')


func activate_swap(pos_drag = null):
	var res = []
	for pos in [1, 2, 3]:
		if battlefield[pos] == null: res.push_back(pos)
		else:
			if pos == pos_drag: continue
			var tchar = battlefield[pos]
			if !tchar.acted: res.push_back(pos)
	gui_node.activate_shades(res)


func summon(montype, number):
	# for now summoning is implemented only for opponents
	# cause i don't know if ally summons must be player- or ai-controlled
	# and don't know if it is possible to implement ai-controlled ally
	#find empty slot in enemy group
	var pos = [];
	for p in variables.enemyparty:
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
		enemygroup[sum_pos].position = sum_pos
		enemygroup[sum_pos].add_trait('summon')
		make_fighter_panel(battlefield[sum_pos], sum_pos);
#		state.combatparty[sum_pos] = enemygroup[sum_pos].id
		state.heroes[enemygroup[sum_pos].id] = enemygroup[sum_pos]

#combat finishes
var rewardsdict

func victory():#2remake for it is broken for now
	if fightover: return
	fightover = true
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	Input.set_custom_mouse_cursor(cursors.default)
	yield(get_tree().create_timer(0.5), 'timeout')
	$Rewards/CloseButton.disabled = true
	input_handler.StopMusic()
	#on combat ends triggers
	
	var tween = input_handler.GetTweenNode($Rewards/victorylabel)
	tween.interpolate_property($Rewards/victorylabel,'rect_scale', Vector2(1.5,1.5), Vector2(1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	input_handler.PlaySound(sounds["victory"])
	
	rewardsdict = {items = {}, xp = 0, gold = 0}
	for i in defeated:
		var tmp = i.xpreward
		if state.heroes.arron.level > en_level:
			tmp /= 5
		elif state.heroes.arron.level < en_level:
			tmp *= 2
		rewardsdict.xp += tmp
		var table = null
		if typeof(i.loottable) ==  TYPE_DICTIONARY:
			table = i.loottable
		elif Enemydata.loottables.has(i.loottable):
			table = Enemydata.loottables[i.loottable]
		if table != null:
			var loot = {}
			if table.has('items'):
				for j in table.items:
					if randf()*100 <= j.chance:
						loot[j.code] = 1 # round(rand_range(j.min, j.max))
				globals.AddOrIncrementDict(rewardsdict.items, loot)
			if table.has('gold'):
				if typeof(table.gold) == TYPE_ARRAY:
					rewardsdict.gold += globals.rng.randi_range(table.gold[0], table.gold[1])
				else:
					rewardsdict.gold += table.gold
			if table.has('xp'):
				tmp = table.xp
				if state.heroes.arron.level > en_level:
					tmp /= 5
				elif state.heroes.arron.level < en_level:
					tmp *= 2
				rewardsdict.xp += tmp
		state.heroes.erase(i.id)
	defeated.clear()
	
	input_handler.ClearContainerForced($Rewards/HBoxContainer)
	input_handler.ClearContainer($Rewards/ScrollContainer/HBoxContainer)
	
	leveled_up_chars.clear()
	for ch in state.characters:
		var i = state.heroes[ch]
		if !i.unlocked:
			i.baseexp += ceil(rewardsdict.xp)
			continue
		var newbutton = input_handler.DuplicateContainerTemplate($Rewards/HBoxContainer)
#		if $Rewards/HBoxContainer/first.get_children().size() >= 5:
#			$Rewards/HBoxContainer/first.remove_child(newbutton)
#			$Rewards/HBoxContainer/second.add_child(newbutton)
		newbutton.get_node('icon').texture = i.portrait_circle()
		newbutton.get_node("xpbar").max_value = i.get_exp_cap()
		newbutton.get_node("xpbar").value = i.baseexp
		var level = i.level
		i.baseexp += ceil(rewardsdict.xp)
		var subtween = input_handler.GetTweenNode(newbutton)
		if i.level > level:
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'value', newbutton.get_node("xpbar").value, newbutton.get_node("xpbar").max_value, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
			subtween.interpolate_property(newbutton.get_node("xpbar"), 'modulate', newbutton.get_node("xpbar").modulate, Color("fffb00"), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
			subtween.interpolate_callback(input_handler, 1, 'DelayedText', newbutton.get_node("xpbar/Label"), tr("LEVELUP")+ ': ' + str(i.level) + "!")
			subtween.interpolate_callback(input_handler, 1, 'PlaySound', sounds["levelup"])
			leveled_up_chars.push_back(i)
		elif i.level == level && i.baseexp >= i.get_exp_cap() :
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
	
	if rewardsdict.gold > 0:
		state.money += rewardsdict.gold
		var newbutton = input_handler.DuplicateContainerTemplate($Rewards/ScrollContainer/HBoxContainer)
		newbutton.hide()
		newbutton.texture = load("res://assets/images/iconsitems/gold.png")
		newbutton.get_node("Label").text = str(rewardsdict.gold)
	for id in rewardsdict.items:
		var item = Items.Items[id]
		state.materials[id] += rewardsdict.items[id]
		var newbutton = input_handler.DuplicateContainerTemplate($Rewards/ScrollContainer/HBoxContainer)
		newbutton.hide()
		newbutton.texture = item.icon
		newbutton.get_node("Label").text = str(rewardsdict.items[id])
		globals.connectmaterialtooltip(newbutton, item)
#	for i in rewardsdict.materials:
#		var item = Items.Materials[i]
#		var newbutton = input_handler.DuplicateContainerTemplate($Rewards/ScrollContainer/HBoxContainer)
#		newbutton.hide()
#		newbutton.texture = item.icon
#		newbutton.get_node("Label").text = str(rewardsdict.materials[i])
#		state.materials[i] += rewardsdict.materials[i]
#		globals.connectmaterialtooltip(newbutton, item)
#	for i in rewardsdict.items:
#		var newnode = input_handler.DuplicateContainerTemplate($Rewards/ScrollContainer/HBoxContainer)
#		newnode.hide()
#		newnode.texture = load(i.icon)
#		globals.AddItemToInventory(i)
#		globals.connectitemtooltip(newnode, state.items[globals.get_item_id_by_code(i.itembase)])
#		if i.amount == null:
#			newnode.get_node("Label").visible = false
#		else:
#			newnode.get_node("Label").text = str(i.amount)
	
	yield(get_tree().create_timer(1.7), 'timeout')
	on_level_up_close()
	
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

func on_level_up_close():
	if leveled_up_chars.size() > 0:
		var character = leveled_up_chars[0]
		fill_up_level_up(character)
		leveled_up_chars.erase(character)
		$LevelUp/ShowPlayer.play("show")
		$LevelUp/ShowPlayer.seek(0.0,true)#to set all actor's scale to 0
		$LevelUp.visible = true
		input_handler.PlaySound(sounds["levelup_show"])
	else:
		$LevelUp.visible = false

func fill_up_level_up(character):
	var skill_planks = [
		$LevelUp/VBoxContainer/NewSkill,
		$LevelUp/VBoxContainer/NewSkill2
	]
	skill_planks[0].visible = false
	skill_planks[1].visible = false
	
	$LevelUp/panel/Avatar/Circle.texture = character.portrait_circle()
	$LevelUp/panel/Label.text = tr(character.name) + " has just acquired a level!"
	$LevelUp/VBoxContainer/Level/Before.text = str(character.level - 1)
	$LevelUp/VBoxContainer/Level/After.text = str(character.level)
	$LevelUp/VBoxContainer/Health/Before.text = str(ceil(character.get_hpmax_at_level(character.level - 1)))
	$LevelUp/VBoxContainer/Health/After.text = str(ceil(character.get_hpmax_at_level(character.level)))
	$LevelUp/VBoxContainer/Attack/Before.text = str(ceil(character.get_damage_at_level(character.level - 1)))
	$LevelUp/VBoxContainer/Attack/After.text = str(ceil(character.get_damage_at_level(character.level)))
	var skill_num = -1
	for key in combatantdata.charlist[character.id].skilllist:
		if combatantdata.charlist[character.id].skilllist[key] == character.level: # will fail if we go from lvl 5 to 7 and new skill was at lvl 6
			skill_num += 1
			var skill_info = Skillsdata.skilllist[key]
			var skill_icon = skill_planks[skill_num].get_node("Icon")
			skill_icon.texture = skill_info.icon
			globals.connectskilltooltip(skill_icon, character.id, key)
			var skill_name = skill_planks[skill_num].get_node("SkillText")
			skill_name.text = tr("SKILL"+skill_info.name.to_upper())
			skill_planks[skill_num].visible = true
			if skill_num == 1:#unfortunately for this time we can't have more than 2 skills at lvl-up
				break

func FinishCombat(value):
	if fight_finished: #not sure if it's necessary, but for the time I cann't predict all checkwinlose situations
		print("!ALERT! FinishCombat used inappropriately")
		return
	fight_finished = true
	input_handler.SetMusic("towntheme",20)#very slow, so events could take over
	
	for ch in state.heroes.values():
		ch.defeated = false
		ch.cooldowns.clear()
		ch.hp = ch.get_stat('hpmax')
		ch.shield = 0
		ch.process_event(variables.TR_COMBAT_F)
		ch.displaynode = null
	
	for pos in variables.enemyparty:
		if battlefield[pos] == null: continue
		battlefield[pos].displaynode = null
		battlefieldpositions[pos].hide()
		remove_enemy(pos, battlefield[pos].id)
	
	ClearSkillTargets()
	clear_auras()
	CombatAnimations.force_end()
#	input_handler.RevertMusic()
	state.cleanup()
	
	if input_handler.curtains != null: 
		var curtain_time = 0.5
		input_handler.curtains.show_anim(variables.CURTAIN_BATTLE, curtain_time)
		yield(get_tree().create_timer(curtain_time), 'timeout')
	
	emit_signal("combat_ended")
	if input_handler.explore_node != null:
		input_handler.explore_node.combat_finished(value)
	else:
		hide_me()

func hide_me():
	input_handler.combat_node = null
	hide()
	if input_handler.curtains != null: 
		input_handler.curtains.hide_anim(variables.CURTAIN_BATTLE)



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
	
	if rangetype == 'weapon':
		rangetype = fighter.get_weapon_range()
	
	highlightargets = true
	
	if targetgroups.has('enemy'):
		var t_targets
		if rangetype == 'any': t_targets = get_enemy_targets_all(fighter)
		if rangetype == 'melee': t_targets = get_enemy_targets_melee(fighter)
		for t in t_targets:
			allowedtargets.enemy.push_back(t.position)
	if targetgroups.has('ally'):
		var t_targets = get_allied_targets(fighter)
		if rangetype == 'dead':
			t_targets.clear()
			for t in playergroup.values():
				if t.defeated:
					t_targets.push_back(t)
		
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
		battlefield[pos].displaynode.highlight_target_ally()
	activecharacter.displaynode.highlight_active()


func ClearSkillTargets():
	allowedtargets.ally.clear()
	allowedtargets.enemy.clear()


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
	var ttarget = battlefield[target]
	var change = false
	#var skill = Skillsdata.skilllist[s_code]
	if ttarget == null: change = true #forced change
	elif ttarget.defeated or ttarget.hp <= 0: change = true #forced change. or not. nvn error
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
			if avtargets.empty(): return null
			return input_handler.random_element(avtargets).position
		variables.NT_ANY_NOREPEAT:
			var avtargets = get_enemy_targets_all(caster)
			if avtargets.empty(): return null
			avtargets.erase(target)
			return input_handler.random_element(avtargets).position
		variables.NT_MELEE:
			var avtargets = get_enemy_targets_melee(caster)
			if avtargets.empty(): return null
			return input_handler.random_element(avtargets).position
		variables.NT_WEAK:
			var avtargets = get_enemy_targets_all(caster)
			if avtargets.empty(): return null
			var t = 0
			for i in range(avtargets.size()):
				if avtargets[i].hp < avtargets[t].hp: t = i
			return avtargets[t].position
		variables.NT_WEAK_MELEE:
			var avtargets = get_enemy_targets_melee(caster)
			if avtargets.empty(): return null
			var t = 0
			for i in range(avtargets.size()):
				if avtargets[i].hp < avtargets[t].hp: t = i
			return avtargets[t].position
		variables.NT_BACK:
			if target > 6: return null
			else: return target + 3
		variables.NT_CASTER:
			return caster.position


func CalculateTargets(skill, caster, target_pos, finale = false):
	#if target == null: return
	var target = battlefield[target_pos]
	var array = []
	
	var targetgroup
	
#	if target == null:
	if skill.allowedtargets.has('enemy'):
		if caster.combatgroup == 'ally': targetgroup = 'enemy'
		else: targetgroup = 'ally'
	elif skill.allowedtargets.has('ally') or skill.allowedtargets.has('self'):
		targetgroup = caster.combatgroup
	
	match skill.targetpattern:
		'single':
			array = [target]
		'row':
			for i in variables.rows:
				if variables.rows[i].has(target_pos):
					for j in variables.rows[i]:
						if battlefield[j] == null : continue
						var tchar = battlefield[j]
						if tchar.defeated: continue
						#if !tchar.can_be_damaged(skill.code) and !finale: continue
						array.append(tchar)
		'line':
			for i in variables.lines:
				if variables.lines[i].has(target_pos):
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
				if j == target_pos: continue
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
			var tpos = [target_pos]
			if target_pos in [1, 4, 7]: tpos.push_back(target_pos + 1)
			elif target_pos in [3, 6, 9]: tpos.push_back(target_pos - 1)
			else:
				tpos.push_back(target_pos + 1)
				tpos.push_back(target_pos - 1)
			var tpos2 = []
			for pos in tpos: if battlefield[pos] != null: tpos2.push_back(battlefield[pos])
			if tpos2.size() == 3: tpos2.pop_back()
			array = tpos2
		'2random':
			var tpos = get_allied_targets(target) #possible cause error if no target
			while tpos.size() > 2:
				var r = globals.rng.randi_range(0, tpos.size() - 1)
				tpos.remove(r)
			var tpos2 = []
			for pos in tpos: if battlefield[pos] != null: tpos2.push_back(battlefield[pos])
			array = tpos2
		'neighbours':
			var tpos = []
			if target_pos in [1, 4, 7]: tpos.push_back(target_pos + 1)
			elif target_pos in [3, 6, 9]: tpos.push_back(target_pos - 1)
			else:
				tpos.push_back(target_pos + 1)
				tpos.push_back(target_pos - 1)
			if target_pos in [4, 5, 6]:#not sure about this
				tpos.push_back(target_pos + 3)
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
func FighterMouseOver(position):
	if position == null: return
	show_resist_tooltip(position)
	var fighter = battlefield[position]
	var node = fighter.displaynode
	match cur_state:
		T_AUTO:
			return
#		T_CHARSELECT:
#			if fighter.combatgroup == 'enemy': return
#			if fighter.defeated : return
#			if fighter.acted: return
#			node.highlight_hover()
		T_SKILLSUPPORT:
			if position in allowedtargets.ally:
				Input.set_custom_mouse_cursor(cursors.support)
				for pos in allowedtargets.ally + allowedtargets.enemy:
					battlefield[pos].displaynode.stop_highlight()
				var cur_targets = []
				if swapchar != null:
					cur_targets = [fighter]
				else:
					cur_targets = CalculateTargets(Skillsdata.patch_skill(activeaction, activecharacter), activecharacter, position)
				for ch in cur_targets:
					ch.displaynode.highlight_target_ally_final()
				cur_state = T_OVERSUPPORT
				return
			if position in allowedtargets.enemy:
				Input.set_custom_mouse_cursor(cursors.attack)
				for pos in allowedtargets.ally + allowedtargets.enemy:
					battlefield[pos].displaynode.stop_highlight()
				var cur_targets = []
				cur_targets = CalculateTargets(Skillsdata.patch_skill(activeaction, activecharacter), activecharacter, position)
				for ch in cur_targets:
					ch.displaynode.highlight_target_enemy_final()
				cur_state = T_OVERSUPPORT
				return
		T_SKILLATTACK:
			if position in allowedtargets.ally:
				for pos in allowedtargets.ally + allowedtargets.enemy:
					battlefield[pos].displaynode.stop_highlight()
				if fighter.defeated : return
				if fighter.acted: return
				node.highlight_hover()
				cur_state = T_OVERATTACKALLY
				return
			if position in allowedtargets.enemy:
				Input.set_custom_mouse_cursor(cursors.attack)
				for pos in allowedtargets.ally + allowedtargets.enemy:
					battlefield[pos].displaynode.stop_highlight()
				var cur_targets = []
				cur_targets = CalculateTargets(Skillsdata.patch_skill(activeaction, activecharacter), activecharacter, position)
				for ch in cur_targets:
					ch.displaynode.highlight_target_enemy_final()
				cur_state = T_OVERATTACK
				return
		T_OVERSUPPORT, T_OVERATTACK, T_OVERATTACKALLY:
			print("warning - mouseover while targets highlighted")


func FighterMouseOverFinish(position):
	if position == null: return
	hide_resist_tooltip()
	Input.set_custom_mouse_cursor(cursors.default)
	var fighter = battlefield[position]
	var node = fighter.displaynode
	match cur_state:
		T_AUTO:
			return
#		T_CHARSELECT:
#			if fighter.combatgroup == 'enemy': return
#			if fighter.defeated : return
#			if fighter.acted: return
#			node.stop_highlight()
		T_OVERATTACK, T_OVERSUPPORT:
			for nd in battlefieldpositions.values():
				nd.stop_highlight()
			for pos in allowedtargets.enemy:
				battlefieldpositions[pos].highlight_target_enemy()
			for pos in allowedtargets.ally:
				battlefield[pos].displaynode.highlight_target_ally()
			if cur_state == T_OVERATTACK:
				cur_state = T_SKILLATTACK
			else:
				cur_state = T_SKILLSUPPORT
			activecharacter.displaynode.highlight_active()
			return
		T_OVERATTACKALLY:
			for nd in battlefieldpositions.values():
				nd.stop_highlight()
			for pos in allowedtargets.enemy:
				battlefieldpositions[pos].highlight_target_enemy()
#			for pos in allowedtargets.ally:
#				battlefieldpositions[pos].highlight_target_ally()
			cur_state = T_SKILLATTACK
			activecharacter.displaynode.highlight_active()
			return
		T_SKILLSUPPORT, T_SKILLATTACK:
			if !(position in allowedtargets.ally + allowedtargets.enemy):
				return
			print("warning - mouseover finish while targets not highlighted")



func FighterPress(position):
	if allowaction == false : return
	match cur_state:
		T_AUTO:
			return
#		T_CHARSELECT:
#			if position > 3:
#				return
#			if battlefield[position] == null: return
#			if battlefield[position].acted: return
#			if battlefield[position].defeated: return
#			cur_state = T_AUTO
#			player_turn(position)
#			return
		T_OVERATTACK, T_OVERSUPPORT:
			if allowedtargets.ally.has(position) or allowedtargets.enemy.has(position):
				cur_state = T_AUTO
				if swapchar != null:
					activecharacter.acted = true #idk why active and not target, but if you insisted...
					activecharacter.displaynode.process_disable()
					swap_heroes_old(position)
				else:
					if allowedtargets.enemy.has(position):
						activecharacter.skills_autoselect.push_back(activeaction)
					use_skill(activeaction, activecharacter, position)
			return
		T_OVERATTACKALLY:
			if allowedtargets.enemy.has(position):
				cur_state = T_AUTO
				activecharacter.skills_autoselect.push_back(activeaction)
				use_skill(activeaction, activecharacter, position)
			elif position in variables.playerparty:
				if battlefield[position] == null: return
				if battlefield[position].acted: return
				if battlefield[position].defeated: return
				cur_state = T_AUTO
				player_turn(position)
			return
		T_SKILLSUPPORT:
			if allowedtargets.ally.has(position) or allowedtargets.enemy.has(position):
				print("warning - allowed target not highlighted properly")
				cur_state = T_AUTO
				use_skill(activeaction, activecharacter, position)
			return
		T_SKILLATTACK:
			if allowedtargets.enemy.has(position):
				print("warning - allowed target not highlighted properly")
				cur_state = T_AUTO
				activecharacter.skills_autoselect.push_back(activeaction)
				use_skill(activeaction, activecharacter, position)
			elif position in variables.playerparty:
				if battlefield[position] == null: return
				if battlefield[position].acted: return
				if battlefield[position].defeated: return
				cur_state = T_AUTO
				player_turn(position)
			return



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

#those vars seemed to be in use only for "enable_followup" effect in trigger-type effects,
#wich for this moment used only once, and the case is seems to be outdated and doesn't work anymore for other reasons
#var follow_up_skill = null
#var follow_up_flag = false


#skill use
func use_skill(skill_code, caster, target_pos): #code, caster, target_position
	skill_in_progress = true
	globals.hideskilltooltip()
	gui_node.HideSkillPanel()
	caster.acted = true

	for nd in battlefieldpositions.values():
		nd.stop_highlight()
	turns += 1
	var target#is someone, we targeting
	var targets#those, how are actually affected
	target = battlefield[target_pos]
	if activeaction != skill_code: activeaction = skill_code
	allowaction = false

	#skill vars naming system:
	#var skill :Dictionary - raw data, template, reference book of a sort
	#var s_skill1 :S_Skill - metaskill, sample and controller for applicable skills
	#var s_skill2 :S_Skill - applicable skill, created by cloning s_skill1 for each target in each cycle of s_skill1
	#actual damage and effects are made by s_skill2
	var skill = Skillsdata.patch_skill(skill_code, caster)

	print("%s uses %s" % [caster.position, skill.name])
	if activeitem and activeitem.has("name"):
		print('%s uses item %s' % [caster.name, activeitem.name])

	#aside from follow_up_skill usage, there is also follow_up_cond skill parameter, that do not work at the moment
#	follow_up_skill = null
#	follow_up_flag = false
#	if skill.has('follow_up'):
#		follow_up_skill = skill.follow_up
#		follow_up_flag = true
#	elif skill.has('follow_up_cond'):
#		follow_up_skill = skill.follow_up_cond
#		follow_up_flag = false
#	else:
#		follow_up_skill = null
#		follow_up_flag = false


	if caster != null && skill.name != "":
		if activeitem:
			combatlogadd("\n" + caster.name + ' uses ' + activeitem.name + ". ")
		else:
			combatlogadd("\n" + caster.name + ' uses ' + skill.name + ". ")

		if skill.cooldown > 0:
			caster.cooldowns[skill_code] = skill.cooldown

	#caster part of setup
	var s_skill1 = S_Skill.new()
	s_skill1.createfromskill(skill_code, caster)
	s_skill1.process_event(variables.TR_CAST)
	caster.process_event(variables.TR_CAST, s_skill1)

	turns += 1
	#preparing and sort animations
	var animations = skill.sfx
	var animationdict = {windup = [], prehit = [], predamage = [], postdamage = []}
	for i in animations:
		animationdict[i.period].append(i)
	
	#========windup animation and initiate sound
	#for sure at windup there should not be real_target-related animations
	if skill.has('sounddata') and skill.sounddata.initiate != null:
		caster.displaynode.process_sound(skill.sounddata.initiate)
	for i in animationdict.windup:
		var sfxtarget = ProcessSfxTarget(i.target, caster, target)
		sfxtarget.process_sfx_dict(i)
	#=============
	
	#skill's repeat cycle of predamage-damage-postdamage
	var endturn = !s_skill1.tags.has('instant');
	if !endturn:
		caster.acted = false
	var n = 0
	while n < s_skill1.repeat:
		n += 1
		#get all affected targets
		if !s_skill1.tags.has('no_refine'):
			var newtarget = refine_target(s_skill1, caster, target_pos)
			if newtarget == null:
				print("%s's %s has no new target" % [caster.position, skill.name])
				break
			target_pos = newtarget
		
		#======prehit animation
		for i in animationdict.prehit:
			var sfxtarget = ProcessSfxTarget(i.target, caster, target)
			sfxtarget.process_sfx_dict(i)
		#====
		
		turns += 1
		target = battlefield[target_pos]
		if target == null and !skill.tags.has('empty_target'):
			continue
		targets = CalculateTargets(skill, caster, target_pos, true)
		#preparing real_target processing, predamage animations
		var s_skill2_list = []
		for i in targets:
			#======predamage animation and strike sound
			if skill.has('sounddata') and skill.sounddata.strike != null:
				if skill.sounddata.strike == 'weapon':
					caster.displaynode.process_sound(get_weapon_sound(caster))
				else:
					caster.displaynode.process_sound(skill.sounddata.strike)
			for j in animationdict.predamage:
				var sfxtarget = ProcessSfxTarget(j.target, caster, i)
				sfxtarget.process_sfx_dict(j)
			#======
			
			#special results
			if skill.damagetype is String and skill.damagetype == 'summon':
				summon(skill.value[0], skill.value[1]);
			elif skill.damagetype is String and skill.damagetype == 'resurrect':
				if !rules.has('no_res'): i.resurrect(skill.value[0]) #not sure
			#default skill result
			else:
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
				#=========postdamage animation and hit sound
				if skill.has('sounddata') and skill.sounddata.hit != null:
					if skill.sounddata.hittype == 'absolute':
						s_skill2.target.displaynode.process_sound(skill.sounddata.hit)
					elif skill.sounddata.hittype == 'bodyhitsound':
						s_skill2.target.displaynode.process_sound(s_skill2.target.bodyhitsound)
					elif skill.sounddata.hittype == 'bodyarmor':
						s_skill2.target.displaynode.process_sound(calculate_hit_sound(skill, caster, s_skill2.target))
				for j in animationdict.postdamage:
					var sfxtarget = ProcessSfxTarget(j.target, caster, s_skill2.target)
					sfxtarget.process_sfx_dict(j)
				#=========
				#applying resists
				s_skill2.calculate_dmg()
				#logging result & dealing damage
				execute_skill(s_skill2)
		turns += 1
		#wait for damage animations from execute_skill()
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
		#postdamage triggers and cleanup real_target s_skills
		var fkill = false
		for s_skill2 in s_skill2_list:
			s_skill2.process_event(variables.TR_POSTDAMAGE)
			s_skill2.caster.process_event(variables.TR_POSTDAMAGE, s_skill2)
			if s_skill2.target.hp <= 0:
				fkill = true
				s_skill2.caster.process_event(variables.TR_KILL)
			else:
				s_skill2.target.process_event(variables.TR_POST_TARG, s_skill2)
			checkdeaths()
			if s_skill2.target.displaynode != null:
				s_skill2.target.rebuildbuffs()
#			Off_Target_Glow();
			s_skill2.remove_effects()
		if fkill: s_skill1.process_event(variables.TR_KILL)
		
		CombatAnimations.check_start()
		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
		print('%s finishing step %s of %s' % [caster.position, n, skill.name])
	#=========skill itself finished==========
	
	turns += 1
	s_skill1.process_event(variables.TR_SKILL_FINISH)
	caster.process_event(variables.TR_SKILL_FINISH, s_skill1)
	s_skill1.remove_effects()
	CombatAnimations.check_start()
	if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
	
	#checking winlose
	#mind that befor refactoring, skill, that returned on "no newtarget", made no checkwinlose()
#	var f = checkwinlose()
#	if f != FIN_NO:
#		#stop skill for end of stage or combat
#		CombatAnimations.check_start()
#		if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
#		q_skills.clear()
#		if f == FIN_STAGE:
#			call_deferred('select_actor')
#		skill_in_progress = false
#		print('%s ended %s on winlose' % [caster.position, skill.name])
#		return
	
	#activate follow-up skill
#	if follow_up_flag and (follow_up_skill != null):
#		yield(use_skill(follow_up_skill, caster, target_pos), 'completed')
	if skill.has('follow_up'):
		yield(use_skill(skill.follow_up, caster, target_pos), 'completed')
	
	#stop for recursion skills, like follow_ups and queued skills
	if skill.has('not_final'):
		print('%s ended %s as not final' % [caster.position, skill.name])
		return

	print('%s almost ended %s' % [caster.position, skill.name])

	#use queued skills
	while !q_skills.empty():
		var tdata = q_skills.pop_front()
		yield(use_skill(tdata.skill, tdata.caster, tdata.target), 'completed')

	#final
	turns += 1
	if activeitem != null:
		state.add_materials(activeitem.code, -1, false)
#		activeitem.amount -= 1
		activeitem = null
		SelectSkill(caster.get_autoselected_skill(), true)

	caster.rebuildbuffs()
	turns +=1
	if endturn or caster.hp <= 0 or !caster.can_act():
		#on end turn triggers
		if caster.hp > 0:
			caster.process_event(variables.TR_TURN_F)
			if caster.displaynode:
				caster.displaynode.process_disable()
				caster.rebuildbuffs()
		call_deferred('select_actor')
		eot = false
	else:
		if caster.combatgroup == 'ally':
			CombatAnimations.check_start()
			if CombatAnimations.is_busy: yield(CombatAnimations, 'alleffectsfinished')
			#mind that next 4 lines of code has 1 tab less in same code under "no newtarget" return (befor refactoring)
			allowaction = true
			gui_node.RebuildSkillPanel()
			gui_node.RebuildItemPanel()
			SelectSkill(activeaction, true)
		eot = true

	skill_in_progress = false
	print('%s ended %s' % [caster.position, skill.name])

func enqueue_skill(skill_code, caster, target_pos):
	if skill_in_progress:
		q_skills.push_back({skill = skill_code, caster = caster, target = target_pos})
	else:
		use_skill(skill_code, caster, target_pos)

func execute_skill(s_skill2):
	var text = ''
	var args = {critical = false, group = s_skill2.target.combatgroup}
#	var data = {node = self, time = turns, type = 'damage_float', slot = 'damage', params = args.duplicate()}
#	CombatAnimations.add_new_data(data)
	if s_skill2.hit_res == variables.RES_CRIT:
		text += "[color=yellow]Critical!![/color] "
		args.critical = true
	#new section applying conception of multi-value skills
	#TO POLISH & REMAKE
	for i in range(s_skill2.value.size()):
		if s_skill2.damagestat[i] == 'no_stat':
			continue #for skill values that directly process into effects
		var data = {}
		if s_skill2.damagestat[i] == '+damage_hp': #damage, damage no log, negative damage
			var tmp = s_skill2.target.deal_damage(s_skill2.value[i], s_skill2.damagetype)
			if tmp.hp >= 0:
				args.type = s_skill2.damagetype
				args.damage = tmp
				if !s_skill2.tags.has('no_log'):
					text += "%s is hit for %d damage. " %[s_skill2.target.name, tmp.hp]#, s_skill2.value[i]]
				data = {node = s_skill2.target.displaynode, time = turns, type = 'damage_float', slot = 'damage', params = args.duplicate()}
			else:
				args.heal = -tmp.hp
				if !s_skill2.tags.has('no_log'):
					text += "%s is healed for %d health." % [s_skill2.target.name, -tmp.hp]
				data = {node = s_skill2.target.displaynode, time = turns, type = 'heal_float', slot = 'damage', params = args.duplicate()}
			CombatAnimations.add_new_data(data)
		elif s_skill2.damagestat[i] == '-damage_hp': #heal, heal no log
			var tmp = s_skill2.target.heal(s_skill2.value[i])
			args.heal = tmp
			if !s_skill2.tags.has('no_log'):
				text += "%s is healed for %d health." %[s_skill2.target.name, tmp]
			data = {node = s_skill2.target.displaynode, time = turns, type = 'heal_float', slot = 'damage', params = args.duplicate()}
			CombatAnimations.add_new_data(data)
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


#simple actions
func combatlogadd(text):
	var data = {node = gui_node, time = turns, type = 'c_log', slot = 'c_log', params = {text = text}}
	CombatAnimations.add_new_data(data)


func res_all(hpval):
	var p = playergroup
	for ch in p.values():
		if ch.defeated:
			ch.defeated = false
			ch.hp = hpval * ch.get_stat('hpmax')
			ch.acted = false


func clean_summons():
	for pos in battlefield:
		if battlefield[pos] == null:
			continue
		if battlefield[pos].has_status('summon'):
			battlefield[pos].apply_atomic({type = 'stat_set', stat = 'hp', value = 0})

func miss(fighter):
	CombatAnimations.miss(fighter.displaynode)

#auras
func clear_auras():
	for id in aura_effects.ally + aura_effects.enemy:
		var obj = effects_pool.get_effect_by_id(id)
		obj.remove()


func recheck_auras():
	for id in aura_effects.ally + aura_effects.enemy:
		var obj = effects_pool.get_effect_by_id(id)
		obj.recheck()


func update_buffs():
	for i in state.heroes.values():
		i.rebuildbuffs()
		i.recheck_effect_tag('recheck_stats')


func add_bonus(party, b_rec:String, value, revert = false):
	if value == 0: return
	if aura_bonuses[party].has(b_rec):
		if revert:
			aura_bonuses[party][b_rec] -= value
			if b_rec.ends_with('_add') and aura_bonuses[party][b_rec] == 0.0: aura_bonuses[party].erase(b_rec)
			if b_rec.ends_with('_mul') and aura_bonuses[party][b_rec] == 1.0: aura_bonuses[party].erase(b_rec)
		else: aura_bonuses[party][b_rec] += value
	else:
		if revert: print('error bonus not found')
		else:
			#if b_rec.ends_with('_add'): bonuses[b_rec] = value
			if b_rec.ends_with('_mul'): aura_bonuses[party][b_rec] = 1.0 + value
			else: aura_bonuses[party][b_rec] = value


#resist_tooltip
func show_resist_tooltip(pos :int):
	if pos < 4 :
		return
	resist_tooltip_for_pos = pos
	yield(get_tree().create_timer(1), 'timeout')
	
	if resist_tooltip_for_pos != pos:
		return
	var fighter = battlefield[pos]
	if !fighter or fighter.defeated:
		resist_tooltip_for_pos = -1
		return
	resist_tooltip.show_up(fighter.id)
	var container = resist_tooltip.get_parent()
	var pos_rect = fighter.displaynode.get_global_rect()
	if pos == 6 or pos == 9:#at the bottom
		var sprite_top_center = fighter.displaynode.get_global_sprite_top_center()
		container.rect_position.y = (sprite_top_center.y - container.rect_size.y)
	else:
		container.rect_position.y = pos_rect.end.y
	container.rect_position.x = (pos_rect.position.x
		+ pos_rect.size.x * 0.5
		- container.rect_size.x * 0.5)
	if pos == 9:#need to do something with this porn
		container.rect_position.x -= 30

func hide_resist_tooltip():
	resist_tooltip_for_pos = -1
	resist_tooltip.hide()

func hide_resist_tooltip_if_my(pos :int):
	if resist_tooltip_for_pos == pos:
		hide_resist_tooltip()
