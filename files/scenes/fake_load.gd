extends Control

#it is not yet obvious, how bg should be chosen: per location or per mission
#that's why this dictionary is here
#for now it's per location
export var bg_village :Texture
export var bg_forest :Texture
export var bg_cave :Texture
export var bg_town :Texture
export var bg_castle :Texture
export var bg_mountains :Texture
export var bg_cult :Texture
export var bg_modern_city :Texture
onready var bg = {
	'village' : bg_village,
	'forest' : bg_forest,
	'cave' : bg_cave,
	'town' : bg_town,
	'castle' : bg_castle,
	'dragon_mountains' : bg_mountains,
	'cult' : bg_cult,
	'modern_city' : bg_modern_city
}

const min_load_time = 2.5
const max_load_time = 3.5

onready var progress_node = $progress
onready var press_key_node = $press_key

signal load_finished

func _ready():
	set_process_input(false)
	for loc in Explorationdata.locations:
		assert(bg.has(loc), "fake_load has no bg for location %s!" % loc)

func open(loc :String = 'forest'):
	assert(bg.has(loc), "fake_load has no such bg: %s!" % loc)
	$bg.texture = bg[loc]
	progress_node.value = 0.0
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
	press_key_node.show()
	set_process_input(true)

func _input(event):
	if (event is InputEventKey) or (event is InputEventMouseButton):
		set_process_input(false)
		emit_signal("load_finished")




