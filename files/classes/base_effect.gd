extends Reference
class_name base_effect

var parent = null
var template
var args : = []
var self_args := []
var sub_effects := []

func _init(caller):
	parent = caller

func apply():
	pass



func createfromtemplate(buff_t):
	if typeof(buff_t) == TYPE_STRING:
		template = Effectdata.effect_table[buff_t]
	else:
		template = buff_t.duplicate()
	for e in template.sub_effects:
		
		pass


func calculate_args():
	args.clear()
	if template.has('args'):
		for arg in template.args:
			match arg.obj:
				'self':
					args.push_back(self_args[arg.param])
					pass
				'parent':
					args.push_back(parent.get(arg.param))
					pass
				'template':
					args.push_back(template[arg.param])
				'parent_args':
					args.push_back(parent.self_args[arg.param])
		pass

func set_args(arg, value):
	self_args[arg] = value

func serialize():
	var tmp := {}
	tmp['template'] = template
	tmp['args'] = self_args
	tmp['sub_effects'] = sub_effects
	tmp['type'] = 'base'
	return tmp

func deserialize(tmp):
	template = tmp['template'].duplicate()
	self_args = tmp['args'].duplicate()
	sub_effects = tmp['sub_effects'].duplicate()