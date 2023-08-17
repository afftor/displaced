extends Reference
class_name ai_base

var app_obj  #applied character

var skill_targets = {} #s_name:[targets]

var current_state
var next_state

func get_skill_list():
	return app_obj.skills


func calculate_target_list(hide_ignore = false): #utility checks and targets calculating 
	#for most of the cases reimplementing this function in inherited classes is not reqired
	#works worser for skills with repeat and random targets
	for s_n in get_skill_list():
		var t_skill = Skillsdata.skilllist[s_n]
		var target_array = []
		var starget
		if t_skill.allowedtargets.has('self'): starget = 'self'
		if t_skill.allowedtargets.has('ally'): starget = 'ally'
		if t_skill.allowedtargets.has('enemy'): starget = 'enemy'
		match starget:
			'self':
				var target_dir = {target = app_obj.position, quality = 1.0}
				var act_targets = input_handler.combat_node.CalculateTargets(t_skill, app_obj, app_obj.position)
				if act_targets.size() == 0: 
					target_dir.quality = 0
					target_array.push_back(target_dir)
				else:
					#heal value degrades with current hp
					if t_skill.tags.has('heal'):
						for t in act_targets:
							target_dir.quality += t.need_heal() / act_targets.size()
					#assuming cd of buffs is not lesser than their duration
					#buffs are always effective
					if t_skill.tags.has('buff'): 
						target_dir.quality = max(target_dir.quality, 1.0)
					target_array.push_back(target_dir)
			'ally':
				var pos_targets = input_handler.combat_node.get_allied_targets(app_obj)
				for target in pos_targets:
					var target_dir = {target = target.position, quality = 1.0}
					var act_targets = input_handler.combat_node.CalculateTargets(t_skill, app_obj, target.position)
					if act_targets.size() == 0: 
						target_dir.quality = 0
						target_array.push_back(target_dir)
					else:
						#heal value degrades with current hp
						if t_skill.tags.has('heal'):
							for t in act_targets:
								target_dir.quality += t.need_heal() / act_targets.size()
						#assuming cd of buffs is not lesser than their duration
						#buffs are always effective
						if t_skill.tags.has('buff'): 
							target_dir.quality = max(target_dir.quality, 1.0)
						#aoe skills are more desired if there are more targets in area
						match t_skill.targetpattern:
							'all':
								if act_targets.size() < 4: target_dir.quality *= 0.5
								if act_targets.size() < 2: target_dir.quality *= 0.5
							'line':
								if act_targets.size() < 2: target_dir.quality *= 0.4
							'row':
								if act_targets.size() < 2: target_dir.quality *= 0.5
						target_array.push_back(target_dir)
			'enemy':
				var pos_targets
				match t_skill.userange:
					'melee', 'weapon': pos_targets = input_handler.combat_node.get_enemy_targets_melee(app_obj, hide_ignore)
					'any': pos_targets = input_handler.combat_node.get_enemy_targets_all(app_obj, hide_ignore)
				for target in pos_targets:
					var target_dir = {target = target.position, quality = 1.0}
					var act_targets = input_handler.combat_node.CalculateTargets(t_skill, app_obj, target.position)
					if act_targets.size() == 0: 
						target_dir.quality = 0
						target_array.push_back(target_dir)
					else:
						#assuming debuffs and damage are always effective
						#not true, but implementing resist check is not trivial
						#aoe skills are more desired if there are more targets in area
						match t_skill.targetpattern:
							'all':
								if act_targets.size() < 4: target_dir.quality *= 0.5
								if act_targets.size() < 2: target_dir.quality *= 0.5
							'line':
								if act_targets.size() < 2: target_dir.quality *= 0.5
							'row':
								if act_targets.size() < 2: target_dir.quality *= 0.5
						target_array.push_back(target_dir)
		skill_targets[s_n] = target_array

func if_has_target(s_name, t_pos):
	for t in skill_targets[s_name]:
		if t.target == t_pos: return true
	return false

func _get_weight_for_skill(s_name):
	var res = 1.0
	var t_skill = Skillsdata.skilllist[s_name]
	if !app_obj.can_use_skill(t_skill): return 0
	#check if skill is in cooldown
	if app_obj.cooldowns.has(s_name): return 0
	#no targets check
	if skill_targets[s_name].size() == 0: return 0
	#calculate base weight for current state
	if t_skill.has('ai_priority'): res = t_skill.ai_priority
	#correct weight for skills with only bad-quality targets
	var tmp  = 0.0
	for target in skill_targets[s_name]: tmp = max(target.quality, tmp)
	tmp = clamp(tmp, 0.3, 0.75)*2.0 - 0.5
	res *= tmp
	if app_obj.taunt != null:
		var taunt_t = state.heroes[app_obj.taunt]
		if !if_has_target(s_name, taunt_t.position): res = 0
	return res

func _get_action(hide_ignore = false):
	calculate_target_list(hide_ignore)
#	if !hide_ignore: _set_next_state()
	var actions = []
	for s_n in get_skill_list():
		var tmp = _get_weight_for_skill(s_n)
		if tmp > 0: actions.push_back([s_n, tmp])
	if actions.size() == 0:
		if app_obj.taunt != null:
			print ("can't attack taunt")
			app_obj.taunt = null
			return _get_action(hide_ignore)
		else:
			print ('ERROR IN AI TEMPLATE')
	var res = input_handler.weightedrandom(actions)
	return res

func _get_target(s_name):#for chosen with _get_action() func
	var targets = []
	if app_obj.taunt != null:
		var taunt_t = state.heroes[app_obj.taunt]
		return taunt_t.position
	for t in skill_targets[s_name]:
		targets.push_back([t.target, t.quality])
	return input_handler.weightedrandom(targets)

func get_spec_data():
	return 0

func bind(ch):
	app_obj = ch
