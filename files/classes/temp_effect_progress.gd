extends base_effect
class_name temp_e_progress
#temp effect that progress on expiring

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
	remains = template.duration
	var obj = get_applied_obj()
	for eff in sub_effects:
		obj.apply_effect(eff)

func upgrade():
	remove()
	createfromtemplate(template.next_level)
	apply()
	pass

func process_event(ev):
	var res = variables.TE_RES_NOACT
	if ev == tick_event:
		res = variables.TE_RES_TICK
		remains -= 1
		for b in buffs:
			b.calculate_args()
		if remains == 0:
			upgrade()
			res = variables.TE_RES_UPGRADE
	if ev == rem_event:
		remove()
		res = variables.TE_RES_REMOVE
	return res

func serialize():
	var tmp = .serialize()
	tmp['type'] = 'temp_p'
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