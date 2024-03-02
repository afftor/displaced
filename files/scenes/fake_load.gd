extends Control

export var bg_forest :Texture
export var bg_cave :Texture
export var bg_mountains :Texture
export var bg_desert :Texture
export var bg_modern_city :Texture
#in all honesty, fully-fledged unlock system via gamestate.gd would be better, but, while I still
#not sure, how fake_load should work, I'll leave it to be local for now
onready var backgrounds = [
	{bg = bg_forest, unlock = false,
		reqs = [{type = 'seq_seen', value = 'intro_finish'}],
	},
	{bg = bg_cave, unlock = false,
		reqs = [{type = 'seq_seen', value = 'dimitrius_arrival'}],
	},
	{bg = bg_mountains, unlock = false,
		reqs = [{type = 'seq_seen', value = 'ember_arc_initiate'}],
	},
	{bg = bg_desert, unlock = true,
		reqs = [],
	},
	{bg = bg_modern_city, unlock = false,
		reqs = [{type = 'seq_seen', value = 'flak_modern_city'}],
	}
]

const min_load_time = 1.5
const max_load_time = 2.5

onready var progress_node = $progress
onready var press_key_node = $press_key

signal load_finished

func _ready():
	set_process_input(false)

func try_unlock_bg():
	for bg in backgrounds:
		if !bg.unlock:
			bg.unlock = state.checkreqs(bg.reqs)

func open():
	try_unlock_bg()
	var unlocked_bg = []
	for i in range(backgrounds.size()):
		if backgrounds[i].unlock:
			unlocked_bg.append(i)
	var chosen = unlocked_bg[randi() % unlocked_bg.size()]
	$bg.texture = backgrounds[chosen].bg
	progress_node.value = 0.0
	progress_node.show()
	press_key_node.hide()
	show()

func start_load():
	if !visible:
		open()
	
	var load_time = rand_range(min_load_time, max_load_time)
	var step_count = randi() % 6 + 4#4-9
	var steps = []
	var times = []
	for i in range(step_count):
		steps.append(rand_range(0.0, 100.0))
		times.append(rand_range(0.0, load_time))
	steps.sort()
	times.sort()
	step_count += 1
	steps.append(100.0)
	times.append(load_time)
	
	var cur_time = 0.0
	for i in range(step_count):
		yield(get_tree().create_timer(times[i] - cur_time), 'timeout')
		progress_node.value = steps[i]
		cur_time = times[i]
	yield(get_tree().create_timer(0.5), 'timeout')
	progress_node.hide()
	press_key_node.show()
	set_process_input(true)

func _input(event):
	if (event is InputEventKey) or (event is InputEventMouseButton):
		set_process_input(false)
		emit_signal("load_finished")




