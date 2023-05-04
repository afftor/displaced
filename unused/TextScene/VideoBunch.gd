extends Control

var current_queue = []
onready var current_plrs = [$"0", $"1"]

func Change(first: VideoStreamTheora, sec: VideoStreamTheora = null) -> void:
	current_queue.append(first)
	if sec: current_queue.append(sec)
	if current_plrs[0].stream == null:
		current_plrs[0].stream = current_queue.pop_front()
		current_plrs[0].play()
		current_plrs[0].show()
		current_plrs[1].hide()

func force_show(first: VideoStreamTheora, sec: VideoStreamTheora = null) -> void:
	current_queue.clear()
	if current_plrs[0].stream == null:
		current_plrs[0].show()
		current_plrs[1].hide()
	if sec:
		current_plrs[0].stream = sec
	else:
		current_plrs[0].stream = first
	current_plrs[0].play()

func _ready() -> void:
	$"0".connect("finished", self, "vid_finish", [false])
	$"1".connect("finished", self, "vid_finish", [true])

func vid_finish(c: bool) -> void:
	if current_queue.size() == 0:
		get_node(str(int(c))).play()
	else:
		current_plrs[1].stream = current_queue.pop_front()
		current_plrs[1].play()
		while true:
			if current_plrs[1].stream_position > 0:
				break
			yield(get_tree(), "idle_frame")
		current_plrs.invert()
		current_plrs[1].hide()
		current_plrs[1].stop()
		current_plrs[0].show()
