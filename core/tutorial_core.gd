extends Node

var tutorials_data = {
	test1 = {
		trigger = ['combat_start'],
		reqs = [],
		force_action = 'combat_select_skill',
		action_args = ['fencing'],
		message = "select fencing skill"
	},
}

var cur_tut = null

func check_action(action, args = null):
	if cur_tut == null: return true
	if !tutorials_data.has(cur_tut): return true
	var data = tutorials_data[cur_tut]
	if !data.has('force_action'): 
		return true
	if data.force_action != action : 
		show_message()
		return false
	if args == null or !data.has('action_args'): 
		finish_tut()
		return true
	for arg in data.action_args:
		if !args.has(arg):
			show_message()
			return false
	finish_tut()
	return true


func check_event(event, args = null):
	if cur_tut != null: 
		return
	if !globals.globalsettings.tuts_enabled : 
		return
	for tut in tutorials_data:
		if globals.globalsettings.seen_tuts.has(tut): continue
		var tutdata = tutorials_data[tut]
		if !tutdata.trigger.has(event): continue
		if args == null or (tutdata.has('trigger_args') and tutdata.trigger_args.has(args)):
			if state.valuecheck(tutdata.reqs):
				start_tut(tut)
				break


func start_tut(id):
	cur_tut = id
	show_message()
	# TODO


func finish_tut():
	globals.globalsettings.seen_tuts.push_back(cur_tut)
	cur_tut = null
	# TODO


func show_message():
	var tutdata = tutorials_data[cur_tut]
	if tutdata.has('message'):
		print(tutdata.message) #temp
		input_handler.SystemMessage(tutdata.message) #not working now
