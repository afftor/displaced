extends Node

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

const LOAD_TRIES = 16

signal _loaded
signal done_work
onready var mutex = Mutex.new()

var res_pool = {
}

var queue = []

var busy = 0

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

func preload_res(path: String) -> void:
	var psplit = path.split("/")
	if psplit.size() < 2:
		print("wrong preload res path %s" % path)
		return
	var category = psplit[0]
	var label = path.replace(category + "/", "")
	
	if res_pool.has(category) && res_pool[category].has(label):
		return
	if path in queue:
		return
	var thread = Thread.new()
	busy += 1
	queue.append(path)
	thread.start(self, "_thread_load", [category, label, thread])
	yield(self, "_loaded")
	var j = res_pool.size()
	for i in range(LOAD_TRIES):
		if res_pool.size() != j:
			break
		yield(get_tree(), "idle_frame")
	busy -= 1
	if busy == 0:
		emit_signal("done_work")
