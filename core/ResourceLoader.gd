extends Node

var release = variables.R_NUDE
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

#Here comes a complicated part:
#The very "base" release is BORING_DEMO - it uses no subfolder, and every other
# release uses it's files.
#BORING has files for endgame (r_full folder), but no nudes.
#NUDE_DEMO and CENSORED_DEMO have no endgame, but have nudes.
#NUDE and CENSORED are most completed releases: they have endgame folder, endgame nudes
# and demo nudes.
#For all nude releases there are two folder for nudes:
# one that need to be censored (r_cens or r_uncen), and one with no such need (r_nude)
# thus used in both "censored" and "nude" releases.
#Complete folder list:
#r_uncen - uncensored endgame nudes
#r_cens - censored endgame nudes
#r_nude - endgame nudes used in both censored and uncensored releases
#r_uncen_d - uncensored demo nudes used also in full release
#r_cens_d - censored demo nudes used also in full release
#r_nude_d - nudes used in all censored and uncensored, demo and full releases
#r_full - non-nude endgame content
#Content outside of any folders used in all releases
#Mind the order! First to exist will be loaded
onready var RES_RELEASE_PRIOR = {
	variables.R_NUDE_DEMO : ["/r_uncen_d", "/r_nude_d", ""],
	variables.R_NUDE : ["/r_uncen", "/r_nude", "/r_uncen_d", "/r_nude_d", "/r_full", ""],
	variables.R_BORING_DEMO : [""],
	variables.R_BORING : ["/r_full", ""],
	variables.R_CENSORED_DEMO : ["/r_cens_d", "/r_nude_d", ""],
	variables.R_CENSORED : ["/r_cens", "/r_nude", "/r_cens_d", "/r_nude_d", "/r_full", ""],
}
#HINT on export templates: list of exclusions for certain release is list of all folders,
# excluding corresponding list from RES_RELEASE_PRIOR

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
var nude_patch_loaded = false

func _ready() -> void:
	try_load_nude_patch()
	determine_release_type()
	var dir_checker = Directory.new()
	for category in RES_ROOT:
		exist_release_dir[category] = []
		for release in RES_RELEASE_PRIOR[globals.get_release_type()]:
			var release_dir = "%s%s" % [category, release]
			var dir = "%s/%s" % [RES_ROOT[category], release_dir]
			if dir_checker.dir_exists(dir):
				exist_release_dir[category].append(release_dir)
#	print("determine_release_dirs: ", exist_release_dir)
#	var path = resources.RES_ROOT.bg + '/bg'
#	var dir = globals.dir_contents(path)
#	if dir != null:
#		for fl in dir:
#			if fl.ends_with('.import'): continue
#			resources.preload_res(fl.trim_prefix(resources.RES_ROOT.bg + '/').trim_suffix('.' + resources.RES_EXT.bg))
#	yield(resources, "done_work")
#	print('debug')

func try_load_nude_patch():
	if OS.has_feature(variables.feat_nude) or OS.has_feature(variables.feat_nude_demo):
		return
	var patch_path = "res://nude_patch.pck"
	if globals.is_demo_by_feature():
		patch_path = "res://nude_patch_demo.pck"
	nude_patch_loaded = ProjectSettings.load_resource_pack(patch_path)

func determine_release_type():
	if release != variables.R_NUDE:
		print("Warning! Project is not in NORMAL release type! No determination.")
		return
	if has_nude_patch():
		if (OS.has_feature(variables.feat_boring_demo)
			or OS.has_feature(variables.feat_cens_demo)
		):
			release = variables.R_NUDE_DEMO
		elif (OS.has_feature(variables.feat_boring)
			or OS.has_feature(variables.feat_cens)
		):
			release = variables.R_NUDE
	elif OS.has_feature(variables.feat_nude_demo):
		release = variables.R_NUDE_DEMO
	elif OS.has_feature(variables.feat_boring_demo):
		release = variables.R_BORING_DEMO
	elif OS.has_feature(variables.feat_boring):
		release = variables.R_BORING
	elif OS.has_feature(variables.feat_cens_demo):
		release = variables.R_CENSORED_DEMO
	elif OS.has_feature(variables.feat_cens):
		release = variables.R_CENSORED

func has_nude_patch() ->bool:
	return nude_patch_loaded

func split_path(path: String):
	var psplit = path.split("/", true, 1)
	if psplit.size() < 2:
		print("wrong get res path %s" % path)
		return
	return psplit

func get_res(path: String) -> Resource:
	var psplit = split_path(path)
	if !psplit:
		print("GET_RES CANT SPLIT: %s" % path)
		return null
	var category = psplit[0]
	var label = psplit[1]
	if (res_pool.has(category) && res_pool[category].has(label)):
		return res_pool[category][label]
	else:
		print("GET_RES NOT FOUND: %s" % path)
		return null


func has_res(path: String) -> bool:
	var psplit = split_path(path)
	if !psplit:
		return false
	var category = psplit[0]
	var label = psplit[1]
	return res_pool.has(category) and res_pool[category].has(label)


func _loaded(category: String, label: String, thread: Thread) -> void:
	var res = thread.wait_to_finish()
	if res:
		if !res_pool.has(category):
			res_pool[category] = {}
		res_pool[category][label] = res
	elif globals.is_normal_type():
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
	call_deferred("_loaded", category, label, thread)
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
