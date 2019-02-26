
extends Node

var currentenemies
var area
var turns = 0
var animationskip = false

var combatlog = ''

var instantanimation = null

var shotanimationarray = [] #supposedanimation = {code = 'code', runnext = false, delayuntilnext = 0} 

var CombatAnimations = preload("res://src/CombatAnimations.gd").new()

var debug = false

var allowaction = false
var highlightargets = false
var allowedtargets = {}
var turnorder = []
var fightover = false

var playergroup = {}
var enemygroup = {}
var currentactor

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

func _ready():
	for i in range(1,13):
		battlefield[i] = null
	add_child(CombatAnimations)
	$ItemPanel/debugvictory.connect("pressed",self, 'victory')
	$Rewards/CloseButton.connect("pressed",self,'FinishCombat')


func _process(delta):
	pass


func start_combat(newenemygroup):
	enemygroup.clear()
	playergroup.clear()
	turnorder.clear()
	
	fightover = false
	$Rewards.visible = false
	allowaction = false
	enemygroup = newenemygroup
	playergroup = state.combatparty
	buildenemygroup(enemygroup)
	buildplayergroup(playergroup)
	#victory()
	select_actor()

func FinishCombat():
	hide()
	globals.call_deferred('EventCheck');


func select_actor():
	checkdeaths()
	ClearSkillTargets()
	ClearSkillPanel()
	ClearItemPanel()
	if checkwinlose() == true:
		return
	if turnorder.empty():
		newturn()
		calculateorder()
	currentactor = turnorder[0].pos
	turnorder.remove(0)
	if currentactor < 7:
		player_turn(currentactor)
	else:
		enemy_turn(currentactor)

func newturn():
	for i in playergroup.values() + enemygroup.values():
		for k in i.buffs.values():
			k.duration -= 1
			if k.duration < 0:
				i.remove_buff(k.code)

func debuff_all():
	for i in playergroup.values() + enemygroup.values():
		for k in i.buffs:
			i.remove_buff(k.code)

func checkdeaths():
	for i in battlefield:
		if battlefield[i] != null && battlefield[i].hp <= 0:
			battlefield[i].defeated = true
			turnorder.erase(battlefield[i])

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

func victory():
	fightover = true
	
	var tween = input_handler.GetTweenNode($Rewards/victorylabel)
	tween.interpolate_property($Rewards/victorylabel,'rect_scale', Vector2(1.5,1.5), Vector2(1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	input_handler.PlaySound("victory")
	
	var rewardsdict = {materials = {}, items = {}, xp = 0}
	for i in enemygroup.values():
		if i == null:
			continue
		rewardsdict.xp += i.xpreward
		var loot = {materials = Enemydata.loottables[i.loottable].materials.duplicate()}
		for j in loot.materials:
			loot.materials[j] = round(rand_range(loot.materials[j][0], loot.materials[j][1]))
		globals.AddOrIncrementDict(rewardsdict.materials, loot.materials)
	globals.ClearContainer($Rewards/ScrollContainer/HBoxContainer)
	for i in rewardsdict.materials:
		var item = Items.Materials[i]
		var newbutton = globals.DuplicateContainerTemplate($Rewards/ScrollContainer/HBoxContainer)
		newbutton.texture = item.icon
		newbutton.get_node("Label").text = str(rewardsdict.materials[i])
		globals.connecttooltip(newbutton, item.description)
	globals.ClearContainer($Rewards/HBoxContainer/first)
	globals.ClearContainer($Rewards/HBoxContainer/second)
	for i in playergroup.values():
		var newbutton = globals.DuplicateContainerTemplate($Rewards/HBoxContainer/first)
		if $Rewards/HBoxContainer/first.get_children().size() >= 5:
			$Rewards/HBoxContainer/first.remove_child(newbutton)
			$Rewards/HBoxContainer/second.add_child(newbutton)
		newbutton.get_node('icon').texture = i.portrait_circle()
		newbutton.get_node("xpbar").value = i.baseexp
		i.baseexp += rewardsdict.xp
		var subtween = input_handler.GetTweenNode(newbutton)
		subtween.interpolate_property(newbutton.get_node("xpbar"), 'value', newbutton.get_node("xpbar").value, i.baseexp, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT, 1)
		subtween.interpolate_callback(input_handler, 2, 'DelayedText', newbutton.get_node("xpbar/Label"), '+' + str(rewardsdict.xp))
		subtween.start()
	$Rewards.visible = true
	$Rewards.set_meta("result", 'victory')
	for i in battlefield:
		if battlefield[i] != null:
			battlefield[i] = null


func defeat():
	$Rewards.visible = true
	$Rewards.set_meta("result", 'defeat')
	for i in battlefield:
		if battlefield[i] != null:
			battlefield[i] = null

func player_turn(pos):
	var selected_character = playergroup[pos]
	if selected_character.effects.has('stun'):
		select_actor()
		return
	
	allowaction = true
	activecharacter = selected_character
	RebuildSkillPanel()
	RebuildItemPanel()
	SelectSkill(selected_character.selectedskill)

#rangetypes melee, any, backmelee

func UpdateSkillTargets():
	var skill = globals.skills[activeaction]
	var fighter = activecharacter
	var targetgroups = skill.allowedtargets
	var targetpattern = skill.targetpattern
	var rangetype = skill.userange
	
	ClearSkillTargets()
	
	for i in $SkillPanel/ScrollContainer/GridContainer.get_children() + $ItemPanel/ScrollContainer/GridContainer.get_children():
		if i.has_meta('skill'):
			i.pressed = i.get_meta('skill') == skill.code
	
	
	if rangetype == 'weapon':
		if activecharacter.gear.rhand == null:
			rangetype = 'melee'
		else:
			var weapon = state.items[activecharacter.gear.rhand]
			rangetype = weapon.weaponrange
	
	
	highlightargets = true
	
	allowedtargets.clear()
	allowedtargets = {ally = [], enemy = []}
	
	
	if targetgroups.has('enemy'):
		for i in enemygroup:
			if enemygroup[i].defeated == true:
				continue
			if rangetype == 'any':
				allowedtargets.enemy.append(i)
			elif rangetype == 'melee':
				if CheckMeleeRange('enemy'):
					allowedtargets.enemy.append(i)
				else:
					if i in [7,8,9]:
						allowedtargets.enemy.append(i)
	if targetgroups.has('ally'):
		for i in playergroup:
			if playergroup[i].defeated == true || playergroup[i] == fighter:
				continue
			allowedtargets.ally.append(i)
	if targetgroups.has('self'):
		allowedtargets.ally.append(fighter.position)
	Highlight(currentactor,'selected')
	for i in allowedtargets.enemy:
		Highlight(i, 'target')
	for i in allowedtargets.ally:
		Highlight(i, 'targetsupport')

func ClearSkillTargets():
	for i in battlefield:
		if battlefield[i] != null:
			StopHighlight(i)

func CheckMeleeRange(group): #Check if enemy front row is still in place
	var rval = false
	var counter = 0

	match group:
		'enemy':
			for i in range(7,10):
				if battlefield[i] == null || battlefield[i].defeated == true:
					counter += 1
		'player':
			for i in range(1,4):
				if battlefield[i] == null || battlefield[i].defeated == true:
					counter += 1
	if counter == 3:
		rval = true
	return rval

func FindFighterRow(fighter):
	var pos = fighter.position
	if pos in range(4,7) || pos in range(10,13):
		pos = 'backrow'
	else:
		pos = 'frontrow'
	return pos



func enemy_turn(pos):
	var fighter = enemygroup[pos]
	if fighter.effects.has('stun'):
		select_actor()
		return
	
	var castskill = []
	var target = []
	
	#Selecting active skill
	
	Highlight(pos, 'enemy')
	
	for i in fighter.skills:
		var skill = globals.skills[i]
		if fighter.cooldowns.has(skill.code):
			continue
		if skill.aipatterns.has('attack'):
			castskill.append([skill, skill.aipriority])
	
	castskill = input_handler.weightedrandom(castskill)
	
	#Figuring Casting Skill range
	var skillrange = castskill.userange
	if skillrange == 'weapon':
		if fighter.gear.rhand == null:
			skillrange = 'melee'
		else:
			var weapon = state.items[fighter.gear.rhand]
			skillrange = weapon.weaponrange
	
	#Making possible targets array
	if castskill.allowedtargets.has('enemy'):
		for i in playergroup:
			if playergroup[i].defeated == true:
				continue
			if skillrange == 'melee' && !CheckMeleeRange('player') && i in [4,5,6]:
				continue
			
			
			target.append([playergroup[i], 1])
	elif castskill.allowedtargets.has('ally'):
		for i in enemygroup:
			target.append([enemygroup[i], 1])
	
	target = input_handler.weightedrandom(target)
	
	if target == null:
		print(fighter.name, ' no target found')
		return
	
	use_skill(castskill.code, fighter, target)

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
	var container = battlefieldpositions[spot]
	var panel = $Panel/PlayerGroup/Back/left/Template.duplicate()
	fighter.displaynode = panel
	panel.name = 'Character'
	panel.set_script(load("res://files/FigterNode.gd"))
	panel.position = spot
	fighter.position = spot
	panel.fighter = fighter
	panel.connect("signal_RMB", self, "ShowFighterStats")
	panel.connect("signal_RMB_release", self, 'HideFighterStats')
	panel.connect("signal_LMB", self, 'FighterPress')
	panel.connect("mouse_entered", self, 'FighterMouseOver', [fighter])
	panel.connect("mouse_exited", self, 'FighterMouseOverFinish', [fighter])
	panel.set_meta('character',fighter)
	panel.get_node("Icon").texture = fighter.portrait()
	panel.update_hp()
	panel.get_node("Mana").value = globals.calculatepercent(fighter.mana, fighter.manamax)
	panel.get_node("Label").text = fighter.name
	container.add_child(panel)
	panel.rect_position = Vector2(0,0)
	panel.visible = true

var fighterhighlighted = false

func FighterMouseOver(fighter):
	var panel = fighter.displaynode
	fighterhighlighted = true
	panel.get_node("hplabel").show()
	panel.get_node("mplabel").show()
	panel.get_node("hplabel").text = str(fighter.hp) + '/' + str(fighter.hpmax())
	panel.get_node("mplabel").text = str(fighter.mana) + '/' + str(fighter.manamax())
	if allowaction == true && (allowedtargets.enemy.has(fighter.position) || allowedtargets.ally.has(fighter.position)):
		if fighter.combatgroup == 'enemy':
			Input.set_custom_mouse_cursor(cursors.attack)
		else:
			Input.set_custom_mouse_cursor(cursors.support)


func FighterMouseOverFinish(fighter):
	var panel = fighter.displaynode
	fighterhighlighted = false
	panel.get_node("hplabel").hide()
	panel.get_node("mplabel").hide()
	Input.set_custom_mouse_cursor(cursors.default)

func ShowFighterStats(fighter):
	if fightover == true:
		return
	var text = fighter.name + '\nHealth:' + str(fighter.hp) + '/' + str(fighter.hpmax()) + "\nMana" + str(fighter.mana) + '/' + str(fighter.manamax) + '\nDamage:' + str(fighter.damage)
	for i in ['evasion', 'hitrate','armor','armorpenetration','speed']:
		text += '\n' + i + ': ' + str(fighter[i])
	$StatsPanel.show()
	$StatsPanel/RichTextLabel.bbcode_text = text

func HideFighterStats():
	$StatsPanel.hide()

func FighterPress(pos):
	if allowaction == false || (!allowedtargets.enemy.has(pos) && !allowedtargets.ally.has(pos)):
		return
	ClearItemPanel()
	ClearSkillPanel()
	ClearSkillTargets()
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
		enemygroup[i] = combatantdata.combatant.new()
		enemygroup[i].createfromenemy(tempname)
	
	for i in enemygroup:
		if enemygroup[i] == null:
			continue
		enemygroup[i].combatgroup = 'enemy'
		battlefield[i] = enemygroup[i]
		make_fighter_panel(battlefield[i], i)

func buildplayergroup(group):
	var newgroup =  {}
	
	for i in group:
		if group[i] == null:
			continue
		var fighter = state.heroes[group[i]]
		fighter.combatgroup = 'ally'
		battlefield[i] = fighter
		make_fighter_panel(battlefield[i], i)
		newgroup[i] = fighter
	playergroup = newgroup

func SendSkillEffect(skilleffect, caster, target):
	var endtargets = []
	if skilleffect.target == 'self':
		endtargets.append(caster)
	elif skilleffect.target == 'target':
		endtargets.append(target)
	
	var data = {caster = caster}
	if skilleffect.has('value'):
		data.value = skilleffect.value
	
	for i in endtargets:
		if skilleffect.has('chance') && skilleffect.chance < randf():
			continue
		data.target = i
		globals.skillsdata.call(skilleffect.effect, data)
	

func use_skill(skill, caster, target):
	var debugtext = caster.name + ' uses ' + skill + ' on ' + target.name
	allowaction = false
	
	
	skill = globals.skills[skill]
	
	caster.mana -= skill.manacost
	
	
	#making skill effects dict
	var skilleffects = {oncast = [], onhit = []}
	
	for i in skill.casteffects:
		skilleffects[i.period].append(i)
	
	for i in skilleffects.oncast:
		SendSkillEffect(i, caster, target)
	
	var animations = skill.sfx
	var animationdict = {windup = [], predamage = []}
	
	var targets = CalculateTargets(skill, caster, target)
	#sort animations
	for i in animations:
		animationdict[i.period].append(i)
	
	#casteranimations
	
	for i in animationdict.windup:
		var sfxtarget = ProcessSfxTarget(i.target, caster, target)
		CombatAnimations.call(i.code, sfxtarget)
		yield(CombatAnimations, 'pass_next_animation')
	
	if animationdict.windup.size() > 0:
		yield(CombatAnimations, 'cast_finished')
	
	for i in targets:
		
		for j in animationdict.predamage:
			var sfxtarget = ProcessSfxTarget(j.target, caster, i)
			CombatAnimations.call(j.code, sfxtarget)
			yield(CombatAnimations, 'pass_next_animation')
		
		if animationdict.predamage.size() > 0:
			yield(CombatAnimations, 'predamage_finished')
		
		if hitchance(skill,caster,i) == 'hit':
			execute_skill(skill, caster, i)
			for j in skilleffects.onhit:
				SendSkillEffect(j, caster, i)
		else:
			miss(target)

	
	
	
	
	if activeitem != null:
		activeitem.amount -= 1
		activeitem = null
		SelectSkill('attack')
	
	if animationdict.predamage.size() > 0:
		yield(CombatAnimations, 'alleffectsfinished')
	
	if fighterhighlighted == true:
		FighterMouseOver(target)
	#print(caster.name + ' finished attacking') 
	select_actor()

func ProcessSfxTarget(sfxtarget, caster, target):
	match sfxtarget:
		'caster':
			return caster.displaynode
		'target':
			return target.displaynode



var rows = {
	1 : [1,2,3],
	2 : [4,5,6],
	3 : [7,8,9],
	4 : [10,11,12],
}

func CalculateTargets(skill, caster, target):
	var array = []
	
	var targetgroup
	var skilltargetgroups = skill.allowedtargets
	
	if target.position in range(1,7):
		targetgroup = 'player'
	else:
		targetgroup = 'enemy'
	
	
	
	match skill.targetpattern:
		'single':
			array = [target]
		'row':
			for i in rows:
				if rows[i].has(target.position):
					for j in rows[i]:
						if battlefield[j] != null && battlefield[j].defeated != true:
							array.append(battlefield[j])
		'all':
			for i in battlefield:
				if i in range(1,7) && targetgroup == 'player':
					array.append(battlefield[i])
				elif i in range(7, 13) && targetgroup == 'enemy':
					array.append(battlefield[i])
	#print(array)
	return array

func hitchance(skill, caster, target):
	var rval
	
	
	if skill.skilltype == 'item' || caster.combatgroup == target.combatgroup || hitchancevalue(skill, caster, target) > rand_range(0,100):
		rval = 'hit'
	else:
		rval = 'miss'
	
	return rval

func hitchancevalue(skill, caster, target):
	var rval = 0
	rval = caster.hitrate - target.evasion
	return rval

func calculate_number_from_string_array(array, caster, target):
	var endvalue = 0
	var firstrun = true
	for i in array:
		var modvalue = i
		if i.find('.') >= 0:
			i = i.split('.')
			if i[0] == 'caster':
				modvalue = str(caster[i[1]])
			elif i[0] == 'target':
				modvalue = str(target[i[1]])
		if !modvalue[0].is_valid_float():
			if modvalue[0] == '-' && firstrun == true:
				endvalue += float(modvalue)
			else:
				input_handler.string_to_math(endvalue, modvalue)
		else:
			endvalue += float(modvalue)
		firstrun = false
	return endvalue

func execute_skill(skill, caster, target):
	var endvalue = 0
	
	
	var crit = false
	if caster.critchance >= randf()*100:
		crit = true
	
	#damage calculation
	
	endvalue = calculate_number_from_string_array(skill.value, caster, target)
	
	var rangetype
	if skill.userange == 'weapon':
		if caster.gear.rhand == null:
			rangetype = 'melee'
		else:
			var weapon = state.items[caster.gear.rhand]
			rangetype = weapon.weaponrange
	if rangetype == 'melee' && FindFighterRow(caster) == 'backrow' && !CheckMeleeRange(caster.combatgroup):
		endvalue /= 2
	
	var damagetype
	var extradamage = []
	
	#onhiteffects
	if skill.skilltype in ['skill', 'spell']:
		for i in caster.passives[skill.skilltype+'hit'] + caster.passives['anyhit']:
			var passive = globals.combateffects[globals.effects[i].triggereffect]
			if checkreqs(passive, caster, target) == false:
				continue
			
			var neweffect = passive.effectvalue
			var newvalue
			if passive.effect != 'buff':
				newvalue = calculate_number_from_string_array(neweffect.value, caster, target)
			var subtarget
			if passive.has('receiver'):
				if passive.receiver == 'caster':
					subtarget = caster
				elif passive.receiver == 'target':
					subtarget = target
			match passive.effect:
				'skillmod':
					match neweffect.type:
						'damagemod':
							endvalue *= (1+newvalue)
						'damage':
							endvalue += newvalue
					
				'gainstat':
					subtarget[neweffect.type] += newvalue
				'buff':
					var buff = makebuff(passive.effectvalue, caster, target)
					subtarget.add_buff(buff)
				'extradamage':
					extradamage.append({damage_dict = {value = newvalue, element = neweffect.element, tags = [], type = neweffect.type}, target = subtarget})
	
	
	if crit == true:
		endvalue *= caster.critmod
	
	
	#damage type
	if skill.damagetype == 'weapon':
		damagetype = 'phys'
	else:
		damagetype = skill.damagetype
	
	var damage_dict = {value = endvalue, element = damagetype, type = skill.skilltype, tags = skill.tags}
	
	
	deal_damage(damage_dict, caster, target)
	for i in extradamage:
		deal_damage(i.damage_dict, caster, i.target)


func deal_damage(damage_dict, caster, target):
	var endvalue = damage_dict.value
	var damagetype = damage_dict.element
	var type = damage_dict.type
	var reduction = 0
	
	if type == 'skill':
		reduction = max(0, target.armor - caster.armorpenetration)
	elif type == 'spell':
		reduction = max(0, target.mdef)
	if !damage_dict.tags.has('heal'):
		endvalue = endvalue * (float(100 - reduction)/100)
	
	
	if damagetype in ['fire','water','air','earth']:
		endvalue = endvalue * ((100 - target['resist' + damagetype])/100)

	if damage_dict.tags.has('heal'):
		target.hp += ceil(endvalue)
	else:
		target.hp -= ceil(endvalue)

func miss(fighter):
	CombatAnimations.miss(fighter.displaynode)

func makebuff(buff, caster, target):
	var newbuff = {code = buff.code, caster = caster, duration = buff.duration, effects = [], tags = []}
	if buff.has('icon'):
		newbuff.icon = buff.icon
	for i in buff.effects:
		var value = calculate_number_from_string_array(i.value, caster, target)
		var buffeffect = {value = value, stat = i.stat}
		newbuff.effects.append(buffeffect)
	
	return newbuff

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
		'target':
			input_handler.TargetGlow(node)
		'targetsupport':
			input_handler.TargetSupport(node)
		'enemy':
			input_handler.TargetEnemyTurn(node)

func StopHighlight(pos):
	var node = battlefieldpositions[pos].get_node("Character")
	input_handler.StopTweenRepeat(node)

func ClearSkillPanel():
	globals.ClearContainer($SkillPanel/ScrollContainer/GridContainer)

func RebuildSkillPanel():
	ClearSkillPanel()
	for i in activecharacter.skills:
		var newbutton = globals.DuplicateContainerTemplate($SkillPanel/ScrollContainer/GridContainer)
		var skill = globals.skills[i]
		newbutton.get_node("Icon").texture = skill.icon
		newbutton.get_node("manacost").text = str(skill.manacost)
		newbutton.connect('pressed', self, 'SelectSkill', [skill.code])
		if activecharacter.mana < skill.manacost:
			newbutton.disabled = true
		newbutton.set_meta('skill', skill.code)
		globals.connecttooltip(newbutton, skill.description)

func SelectSkill(skill):
	skill = globals.skills[skill]
	if activecharacter.mana < skill.manacost:
		SelectSkill('attack')
		return
	activecharacter.selectedskill = skill.code
	activeaction = skill.code
	UpdateSkillTargets()

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
