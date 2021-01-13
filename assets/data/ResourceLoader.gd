extends Node

enum {
	SUCCESS,
	ALREADY_EXISTS,
}

const RES_ROOT = {
	"abg" : "res://assets",
	"bg" : "res://assets/images",
	"sprite" : "res://assets/images",
	"portrait" : "res://assets/images",
	"combat" : "res://assets/images",
	"sound" : "res://assets",
	"music" : "res://assets",
}

const RES_EXT = {
	"abg" : "ogv",
	"bg" : "png",
	"sprite" : "png",
	"portrait" : "png",
	"combat" : "png",
	"sound" : "wav",
	"music" : "ogg",
}

signal _loaded
signal done_work
signal resource_loaded
onready var mutex = Mutex.new()

var res_pool = {
}
var last_res = ""
var current_loaded = 0
var max_loaded = 0

var queue = []
var path_to_delete = []

var busy = 0

func resource_loaded() -> void:
	if last_res in path_to_delete:
		path_to_delete.erase(last_res)
		print(last_res, " (invalid) ", current_loaded, "/", max_loaded)
	else:
		print(last_res, " ", current_loaded, "/", max_loaded)

func _ready() -> void:
	connect("resource_loaded", self, "resource_loaded")
	
#	var path = resources.RES_ROOT.bg + '/bg'
#	var dir = globals.dir_contents(path)
#	if dir != null:
#		for fl in dir:
#			if fl.ends_with('.import'): continue
#			resources.preload_res(fl.trim_prefix(resources.RES_ROOT.bg + '/').trim_suffix('.' + resources.RES_EXT.bg))
#	yield(resources, "done_work")

func get_res(path: String) -> Resource:
	var psplit = path.split("/")
	if psplit.size() < 2:
		print("wrong get res path %s" % path)
		return null
	var category = psplit[0]
	var label = path.replace(category + "/", "")
	
	if (res_pool.has(category) && res_pool[category].has(label)):
		return res_pool[category][label]
	else:
		return null

func _loaded(category: String, label: String, path: String, thread: Thread) -> void:
	var res = thread.wait_to_finish()
	if res:
		if !res_pool.has(category):
			res_pool[category] = {}
		res_pool[category][label] = res
	else:
		print("%s not found!" % path)
		path_to_delete.append(category + "/" + label)
	emit_signal("_loaded")

func _thread_load(args: Array) -> Resource:
	mutex.lock()
	var category = args[0]
	var label = args[1]
	var thread = args[2]
	var path = "%s/%s/%s.%s" % [
		RES_ROOT[category], category, label, RES_EXT[category]]
	var res = null
	if ResourceLoader.exists(path):
		res = ResourceLoader.load(path)
	call_deferred("_loaded", category, label, path, thread)
	mutex.unlock()
	return res

func preload_res(path: String) -> int:
	var psplit = path.split("/")
	if psplit.size() < 2:
		print("wrong preload res path %s" % path)
		return
	var category = psplit[0]
	var label = path.replace(category + "/", "")

	if path in queue:
		return ALREADY_EXISTS
	var thread = Thread.new()
	busy += 1
	queue.append(path)
	max_loaded += 1
	thread.start(self, "_thread_load", [category, label, thread])
	yield(self, "_loaded")
	while true:
		if res_pool.has(category):
			if res_pool[category].has(label):
				break
		if path_to_delete.has(path):
			break
		yield(get_tree(), "idle_frame")
	current_loaded += 1
	last_res = path
	emit_signal("resource_loaded")
	busy -= 1
	if busy == 0:
		emit_signal("done_work")
		max_loaded = 0
		current_loaded = 0
	
	return SUCCESS
