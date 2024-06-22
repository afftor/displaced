extends Control

var can_expand = false
var mouse_in_me = false
onready var expand_flag = $can_expand
onready var container = $container
#onready var marker_added = $added
onready var marker_removed = $removed
onready var base_y = rect_min_size.y

func _ready():
	container.get_node('Button').hide()
	marker_removed.modulate.a = 0.0

func _input(event):
	if !visible or !(event is InputEventMouseMotion):
		return
	
	if get_global_rect().has_point(event.position):
		if !mouse_in_me:
			mouse_in_me = true
			expand()
	else:
		if mouse_in_me:
			mouse_in_me = false
			collapse()

func expand():
	if !can_expand: return
	
	expand_flag.hide()
	input_handler.tween_property(self, 'rect_min_size',
		Vector2(50, base_y),
		Vector2(50, container.rect_size.y + container.rect_position.y),
		0.2)

func collapse():
	if rect_min_size.y <= base_y: return
	
	expand_flag.visible = can_expand
	input_handler.tween_property(self, 'rect_min_size',
		Vector2(50, rect_min_size.y),
		Vector2(50, base_y),
		0.2)

func make_buff() ->Node:
	var new_buff_btn = input_handler.DuplicateContainerTemplate(container)
	container.move_child(new_buff_btn, 0)
	validate()
	#no need with move_child() solution
#	if can_expand:
#		input_handler.tween_property(marker_added, 'modulate',
#		Color(1,1,1,1),
#		Color(1,1,1,0),
#		1)
	return new_buff_btn

func remove_buff(buff_btn :Node):
	var pos = buff_btn.get_index()
	buff_btn.hide()
	buff_btn.queue_free()
	validate()
	if !is_queued_for_deletion() and pos > 0:
		input_handler.tween_property(marker_removed, 'modulate',
			Color(1,1,1,1),
			Color(1,1,1,0),
			1)

func validate():
	var has_one_buff = false
	can_expand = false
	for buff_btn in container.get_children():
		if buff_btn.visible:#queued for deletion and template are hidden
			if has_one_buff:
				can_expand = true
				break
			else:
				has_one_buff = true
	if !has_one_buff:
		queue_free()
		return
	expand_flag.visible = can_expand
