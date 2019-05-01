extends Reference
class_name Buff

var icon
var tooltip:String = "" setget ,get_tooltip
var parent
var template
var args: = []
var self_args := []

func _init(caller):
	parent = caller


func createfromtemplate(buff_t):
	if typeof(buff_t) == TYPE_STRING:
		template = Effectdata.buffs[buff_t]
	else:
		template = buff_t.duplicate()
	tooltip = tr(template.description)
	icon = template.icon

func get_tooltip():
	calculate_args()
	return tooltip % args
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
		pass

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
	tooltip = tr(template.description)
	icon = template.icon