extends base_effect
class_name temp_e_simple
#temp effect with unlimited stacking and icon for each instance
#to limit stacking use counting methods in combatant and reset duration (make sure not to use parent linkings for limited stackable temps)
#to limit one icon for all instances use corresponding counting methods with one_icon flag
#ALL TEMP EFFECTS ARE NAMED - their template has to have 'name' field (even if effect has no id in effects table)
#rem_event removes all instances of effect

var tick_event := []
#all temp effects should be removed on death or combat end
var rem_event := [variables.TR_COMBAT_F, variables.TR_DEATH]
var remains := -1

var template_name

func _init(caller).(caller):
	pass

func createfromtemplate(tmp):
	.createfromtemplate(tmp)
	if template.has('tick_event'):
		if typeof(template.tick_event) == TYPE_ARRAY:
			tick_event = template.tick_event.duplicate()
		else:
			tick_event.clear()
			tick_event.push_back(template.tick_event)
	if template.has('rem_event'):
		if typeof(template.rem_event) == TYPE_ARRAY:
			rem_event.append_array(template.rem_event)
		else:
			rem_event.push_back(template.rem_event)
	template_name = template.name

func apply():
	.apply()
	if template.has('duration'): 
		if typeof(template.duration) == TYPE_STRING:
			match template.duration:
				'parent':
					var par = get_parent()
					if par != null:
						template.duration = int(par.template.duration)
					else:
						print('error in template %s' % template_name)
						template.duration = -1
				'parent_arg':
					var par = get_parent()
					if par != null:
						template.duration = int(par.self_args['duration'])
					else:
						print('error in template %s' % template_name)
						template.duration = -1
		elif typeof(template.duration) == TYPE_DICTIONARY:
			if template.duration.obj == 'parent_args':
				var par = get_parent()
				if par != null:
					template.duration = int(par.get_arg(template.duration.param))
				else:
					print('error in template %s' % template_name)
					template.duration = -1
			else:
				print('error in template %s' % template_name)
				template.duration = -1
		elif template.duration < 0:
			print('error in template %s' % template_name)
			#obj/param dictionary now replicates this
#			var par = get_parent()
#			if par != null:
#				template.duration = int(par.get_arg(-template.duration - 1))
#			else:
#				print('error in template %s' % template_name)
#				template.duration = -1
		remains = template.duration
	var obj = get_applied_obj()
	for eff in sub_effects:
		obj.apply_effect(eff)
#	print("%s applied on %s" % [template_name, obj.name])

func tick_eff():
	remains -= 1
	for b in buffs:
		b.calculate_args()
	if remains == 0:
		remove()

func process_event(ev):
	if !is_applied: return
#	print("process_event %s for %s of %s" % [ev, template_name, get_applied_obj_name()])
	if tick_event.has(ev):
		tick_eff()
	if rem_event.has(ev):
		remove()

func reset_duration():
	if template.has('duration'): remains = template.duration

func serialize():
	var tmp = .serialize()
	tmp['type'] = 'temp_s'
	tmp['remains'] = remains
	return tmp
	pass

func deserialize(tmp):
	.deserialize(tmp)
	tick_event.clear()
	if template.has('tick_event'):
		if typeof(template.tick_event) == TYPE_ARRAY:
			for tr in template.tick_event:
				tick_event.push_back(int(tr))
		else:
			tick_event.push_back(int(template.tick_event))
	rem_event.clear()
	if template.has('rem_event'):
		if typeof(template.rem_event) == TYPE_ARRAY:
			for tr in template.rem_event:
				rem_event.push_back(int(tr))
		else:
			rem_event.push_back(int(template.rem_event))
	remains = int(tmp.remains)
	template_name = template.name
	pass

func soft_remove(): #remove without calling app_obj.remove_effect(), useful for recreating effect
	is_applied = false
	var obj = get_applied_obj()
	for a in atomic:
		if obj != null:
			#tmp.remove_template(obj)
			obj.remove_atomic(a)
	atomic.clear()
	buffs.clear()
	for e in sub_effects:
		var t = effects_pool.get_effect_by_id(e)
		t.remove()
	sub_effects.clear()
	pass

func remove():
	if !is_applied: return
	.remove()
	for e in sub_effects:
		var t = effects_pool.get_effect_by_id(e)
		t.remove()
	sub_effects.clear()
	is_applied = false
