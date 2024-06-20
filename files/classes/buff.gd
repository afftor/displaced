extends Reference
class_name Buff

var icon:String setget ,get_icon
var description:String = "" setget ,get_tooltip
var parent
var template
var args: = []
var self_args := []
var template_name
var name setget ,get_name
var amount = 1
var group = variables.BG_NO

func _init(caller):
	parent = caller


func createfromtemplate(buff_t):
	if typeof(buff_t) == TYPE_STRING:
		template = Effectdata.buffs[buff_t]
	else:
		template = buff_t.duplicate()
	description = tr(template.description)
	icon = template.icon
	template_name = template.t_name
	if template.has('name'): name = template.name
	else: name = template_name
	if template.has('group'):
		group = template.group

func get_tooltip():
	calculate_args()
	if args.empty():
		return description
	return description % args

#for optimisation cause expected to be used after get_tooltip() (getter to description), for any other cases decomment calculate_args()
func get_calc_arg(num :int):
	#calculate_args()
	assert(args.size() > num, "get_calc_arg() trys to get unexistant arg")
	return args[num]

func get_icon():
	if icon.begins_with("res:"):
		return load(icon)
	else:
		return resources.get_res(icon)

func get_name():
	return tr(name)

func calculate_args():
	args.clear()
	if template.has('args'):
		for arg in template.args:
			match arg.obj:
				'self':
					args.push_back(self_args[arg.param])
				'parent':
					var par = effects_pool.get_effect_by_id(parent)
					args.push_back(par.get(arg.param))
				'template':
					args.push_back(template[arg.param])
				'parent_args':
					var par
					par = effects_pool.get_effect_by_id(parent)
					args.push_back(par.get_arg(int(arg.param)))
			if arg.has("translate") and arg.translate:
				var num = args.size()-1
				args[num] = tr(args[num])

func get_duration():
	var par = effects_pool.get_effect_by_id(parent)
	return par.get('remains')

func set_args(arg, value):
	self_args[arg] = value

func serialize():
	var tmp:= {}
	tmp['template'] = template
	tmp['args'] = self_args
	return tmp

func deserialize(tmp):
	template = tmp['template'].duplicate()
	self_args = tmp['args'].duplicate()
	description = tr(template.description)
	icon = template.icon
	template_name = template.t_name
	if template.has('name'): name = template.name
	else: name = template_name

func set_limit(val):
	template.limit = val
