extends base_effect
class_name oneshot_effect
#non-reverecible effects that exist in effect_pool only inbetween stable states
#only one effects that can modify s_skill template

var applied_obj = null

func _init(caller).(caller):
	pass

func apply():
	atomic.clear()
	for a in template.atomic:
		var tmp := atomic_effect.new(a, self)
		tmp.resolve_template()
		applied_obj.apply_atomic(tmp.template)
		atomic.push_back(tmp.template)
	sub_effects.clear()
	for e in template.sub_effects:
		var tmp = effects_pool.e_createfromtemplate(e)
		tmp.calculate_args()
		sub_effects.push_back(effects_pool.add_effect(tmp))
		applied_obj.apply_effect(tmp)
	pass

