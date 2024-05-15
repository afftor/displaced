extends Node

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

var mode = 1

var mainmenu = "res://files/scenes/MainScreen.gd"

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
#	goto_scene(globals.scenedict.menu)

func goto_scene(path): # game requests to switch to this scene
	mode = 1
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		#show_error()
		return
	#print(true)
	set_process(true)
	#current_scene.queue_free() # get rid of the old scene

	# start your "loading..." animation
	get_node("animation").play("loading")

	wait_frames = 1

func _process(delta):
	if loader == null and mode != 2:
		# no need to process anymore
		set_process(false)
		return
	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
		# poll your loader
		if mode == 1:
			var err = loader.poll()
			if err == ERR_FILE_EOF: # load finished
				var resource = loader.get_resource()
				mode = 2
				loader = null
				set_new_scene(resource)
				break
			elif err == OK:
				update_progress()
			else: # error during loading
				#show_error()
				loader = null
				break
		if mode == 2:
			if resources.is_busy(): # load not finished
				update_progress_res()
			else:
				set_new_scene_finish()
				break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# update your progress bar?
	get_node("progress").value = progress*100

	# or update a progress animation?
	var length = get_node("animation").get_current_animation_length()

	# call this on a paused animation. use "true" as the second parameter to force the animation to update
	get_node("animation").seek(progress * length, true)


func update_progress_res():
	var tmp = resources.max_loaded
	var progress = 1.0
	if tmp > 0 and tmp > resources.current_loaded:
		progress = float(resources.current_loaded) / tmp
	# update your progress bar?
	get_node("progress").value = progress * 100

	# or update a progress animation?
	var length = get_node("animation").get_current_animation_length()

	# call this on a paused animation. use "true" as the second parameter to force the animation to update
	get_node("animation").seek(progress * length, true)


func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	globals.CurrentScene = current_scene
	get_node("/root").add_child(current_scene)
	self.raise()

func set_new_scene_finish():
	globals.emit_signal("scene_changed")
	get_node("/root").remove_child(self)
	self.queue_free()
