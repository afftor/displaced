extends base_effect
class_name aura_effect
# auras can only have stat_add and stat_add_p atomics
# auras can not have sub_effects

var cond_true = false

func _init(caller).(caller):
	pass

func apply():
	if input_handler.combat_node == null: return
	is_applied = true
	recheck()

func remove():
	if !is_applied: return
	var obj = get_applied_obj()
	if cond_true:
		if obj != null:
			obj.remove_effect(id)
			for a in atomic:
				obj.remove_aura_atomic(a)
		atomic.clear()
		buffs.clear()
	else:
		obj.remove_effect(id)
	is_applied = false

#auras should not be serialized
func serialize():
	print("ERROR - aura serialized")
	var tmp = .serialize()
	return tmp
#
#func deserialize(tmp):
#	.deserialize(tmp)
#	cond_true = tmp['cond']

func recheck():
	if !is_applied: return
	.recheck()
	var tres = true
	var obj = get_applied_obj()
	for cond in template.conditions:
		tres = tres && obj.process_check(cond)
	if tres == cond_true: return
	if tres:
		cond_true = true
		atomic.clear()
		calculate_args()
		for a in template.atomic:
			var tmp := atomic_effect.new(a, id)
			tmp.resolve_template()
			#tmp.apply_template(obj)
			obj.apply_aura_atomic(tmp.template)
			atomic.push_back(tmp.template)
		buffs.clear()
		for e in template.buffs:
			var tmp = Buff.new(id)
			tmp.createfromtemplate(e)
			tmp.calculate_args()
			buffs.push_back(tmp)
	else:
		cond_true = false
		for a in atomic:
			obj.remove_aura_atomic(a)
		atomic.clear()
		buffs.clear()
	if input_handler.combat_node == null: return
	input_handler.combat_node.update_buffs()


