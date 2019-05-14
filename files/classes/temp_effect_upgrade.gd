extends base_effect
class_name temp_e_upgrade
#temp effect that can be upgraded
#designed for non-stackable using but do not force it
#all levels are upgradeble effects with the same name (still do not force it)

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

func upgrade():
	if !template.has('next_level'): return
	remove()
	createfromtemplate(template.next_level)
	apply()
	pass

func process_event(ev):
	if ev == tick_event:
		remains -= 1
		if remains == 0:
			remove()
		for b in buffs:
			b.calculate_args()
	if ev == rem_event:
		remove()

func serialize():
	var tmp = .serialize()
	tmp['type'] = 'temp_u'
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