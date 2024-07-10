extends Node


const RES_ROOT = {
	"abg" : "res://assets",
	"bg" : "res://assets/images",
	"sprite" : "res://assets/images",
	"animated_sprite" : "res://assets/images",
	"portrait" : "res://assets/images",
	"combat" : "res://assets/images",
	"sound" : "res://assets",
	"music" : "res://assets",
	"Fight" : "res://assets/images",
	"enemies" : "res://assets/images",
	"scene_preview" : "res://assets/images"
}

#Mind the order! First to exist will be loaded
#priority: normal base (demo), normal, steam base (demo), steam
const RES_RELEASE_PRIOR = ["/r_nude", "/r_full/r_nude", "", "/r_full"]

var exist_release_dir = {}#filled automatically

const RES_EXT = {
	"abg" : "ogv",
	"bg" : "png",
	"sprite" : "png",
	"animated_sprite":"tscn",
	"portrait" : "png",
	"combat" : "png",
	"sound" : "wav",
	"music" : "ogg",
	"Fight" : ["png", "tres"],
	"enemies" : "png",
	"scene_preview" : "png"
}

signal done_work
onready var mutex = Mutex.new()

var res_pool = {
}

var current_loaded = 0
var max_loaded = 0

var queue = {}
var path_to_delete = []

var busy = 0


func _ready() -> void:
	var dir_checker = Directory.new()
	for category in RES_ROOT:
		exist_release_dir[category] = []
		for release in RES_RELEASE_PRIOR:
			var release_dir = "%s%s" % [category, release]
			var dir = "%s/%s" % [RES_ROOT[category], release_dir]
			if dir_checker.dir_exists(dir):
				exist_release_dir[category].append(release_dir)
#	var path = resources.RES_ROOT.bg + '/bg'
#	var dir = globals.dir_contents(path)
#	if dir != null:
#		for fl in dir:
#			if fl.ends_with('.import'): continue
#			resources.preload_res(fl.trim_prefix(resources.RES_ROOT.bg + '/').trim_suffix('.' + resources.RES_EXT.bg))
#	yield(resources, "done_work")
#	print('debug')

func split_path(path: String):
	var psplit = path.split("/", true, 1)
	if psplit.size() < 2:
		print("wrong get res path %s" % path)
		return
	return psplit

func get_res(path: String) -> Resource:
	var psplit = split_path(path)
	if !psplit:
		return null
	var category = psplit[0]
	var label = psplit[1]
	if (res_pool.has(category) && res_pool[category].has(label)):
		return res_pool[category][label]
	else:
#		print("GET_RES NOT FOUND: %s" % path)
		return null


func has_res(path: String) -> bool:
	var psplit = split_path(path)
	if !psplit:
		return false
	var category = psplit[0]
	var label = psplit[1]
	return res_pool.has(category) and res_pool[category].has(label)


func _loaded(category: String, label: String, path: String, thread: Thread) -> void:
	var res = thread.wait_to_finish()
	if res:
		if !res_pool.has(category):
			res_pool[category] = {}
		res_pool[category][label] = res
	elif !(globals.is_steam_type() or globals.is_demo_type()):
		#print that only in normal mode (not best idea, but suffice for now)
		print("NOT FOUND: %s/%s" % [category, label])
	queue[category].erase(label)
	busy -= 1
	if busy == 0:
		emit_signal("done_work")


func _thread_load(args: Array) -> Resource:
	mutex.lock()
	var category = args[0]
	var label = args[1]
	var thread = args[2]
	var extensions = []
	if RES_EXT[category] is Array:
		extensions = RES_EXT[category]
	else:
		extensions.append(RES_EXT[category])
	var res = null
	var path
	var has_res = false
	for release_dir in exist_release_dir[category]:
		for ext in extensions:
			path = "%s/%s/%s.%s" % [
				RES_ROOT[category], release_dir, label, ext]
			has_res = ResourceLoader.exists(path)
			if has_res: break
		if has_res: break
	if has_res:
		res = ResourceLoader.load(path)
		if res is AnimatedTexAutofill:
			res.fill_frames()
	call_deferred("_loaded", category, label, path, thread)
	mutex.unlock()
	return res


func preload_res(path: String) -> void:
	var psplit = split_path(path)
	if !psplit:
		return
	var category = psplit[0]
	var label = psplit[1]

	if res_pool.has(category) and res_pool[category].has(label):
		return
	if !queue.has(category):
		queue[category] = []
	if queue[category].has(label):
		return

	var thread = Thread.new()
	busy += 1
	queue[category].append(label)
	thread.start(self, "_thread_load", [category, label, thread])

func is_busy() -> bool:
	return busy != 0
