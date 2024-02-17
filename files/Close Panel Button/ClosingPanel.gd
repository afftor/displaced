extends Control

var closebuttonoffset = [14,5]
var closebutton
#var open_sound = 'sound/menu_open'
#var close_sound = 'sound/menu_close'
var visible_ready = false
var use_ready = false

func _ready():

#open_sound and close_sound are switch off. Delete in time, if noone would like to bring it back
#	for i in [open_sound, close_sound]:
#		resources.preload_res(i)

#	if resources.is_busy(): yield(resources, "done_work")

	rect_pivot_offset = Vector2(rect_size.x/2, rect_size.y/2)
	
	if has_node("CloseButton"):
		closebutton = $CloseButton
	else:
		closebutton = load("res://files/Close Panel Button/CloseButton.tscn").instance()
		add_child(closebutton)
#		move_child(closebutton, 0)
		closebutton.raise()
	closebutton.connect("pressed", self, 'hide')
	RepositionCloseButton()
	visible_ready = is_visible_in_tree()

func RepositionCloseButton():
	var rect = get_global_rect()
	var pos = Vector2(rect.end.x - closebutton.rect_size.x - closebuttonoffset[0], rect.position.y + closebuttonoffset[1])
	closebutton.rect_global_position = pos

func show():
	if resources.is_busy(): yield(resources, "done_work")
	if !is_visible_in_tree():
#		input_handler.PlaySound(open_sound)
		input_handler.Open(self)
	#globals.call_deferred("EventCheck");

func on_open_finished():
	visible_ready = true
	use_ready = true

func hide():
	if resources.is_busy(): yield(resources, "done_work")
	if is_visible_in_tree() && visible_ready:
#		input_handler.PlaySound(close_sound)
		use_ready = false
		input_handler.Close(self)

func on_close_finished():
	visible_ready = false

func is_ready_to_use() ->bool:
	return visible_ready
