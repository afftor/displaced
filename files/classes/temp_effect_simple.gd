extends base_effect
class_name temp_e_simple
#temp effect with unlimited stacking and icon for each instance
#to limit stacking use counting methods in combatant and reset duration (make sure not to use parent linkings for limited stackable temps)
#to limit one icon for all instances use corresponding counting methods with one_icon flag
#ALL TEMP EFFECTS ARE NAMED - their template has to have 'name' field (even if effect has no id in effects table)
#rem_event removes all instances of effect

var tick_event := -1
var rem_event := -1
var remains := -1

var template_name

func _init(caller).(caller):
	pass

func createfromtemplate(tmp):
	.createfromtemplate(tmp)
	if template.has('tick_event'): tick_event = template.tick_event
	if template.has('rem_event'): rem_event = template.rem_event
	template_name = template.name

func apply():
	.apply()
	if template.has('duration'): remains = template.duration
	var obj = get_applied_obj()
	for eff in sub_effects:
		obj.apply_effect(eff)

func process_event(ev):
	var res = variables.TE_RES_NOACT
	if ev == tick_event:
		res = variables.TE_RES_TICK
		remains -= 1
		for b in buffs:
			b.calculate_args()
		if remains == 0:
			remove()
			res = variables.TE_RES_REMOVE
	if ev == rem_event:
		remove()
		res = variables.TE_RES_REMOVE
	return res

func reset_duration():
	if template.has('duration'): remains = template.duration
	for b in buffs:
		b.calculate_args()

func serialize():
	var tmp = .serialize()
	tmp['type'] = 'temp_s'
	tmp['remains'] = remains
	return tmp
	pass

func deserialize(tmp):
	.deserialize(tmp)
	if template.has('tick_event'): tick_event = template.tick_event
	if template.has('rem_event'): rem_event = template.rem_event
	remains = tmp.remains
	template_name = template.name
	pass

func remove():
	.remove()
	for e in sub_effects:
		var t = effects_pool.get_effect_by_id(e)
		t.remove()
	sub_effects.clear()
	is_applied = false