extends PopupPanel

var parentnode
var shutoff = false
var prevnode

func _process(delta):
	if parentnode != null && ( parentnode.is_visible_in_tree() == false || !parentnode.get_global_rect().has_point(get_global_mouse_position())):
		set_process(false)
		hide()

func _init():
	set_process(false)
	connect("popup_hide", self, 'cooldown')

func showup(node, text):
	parentnode = node
	if shutoff == true && prevnode == parentnode:
		return
	popup()
	set_process(true)
	$RichTextLabel.bbcode_text = text
	prevnode = parentnode

func cooldown():
	shutoff = true
	yield(get_tree().create_timer(0.2), 'timeout')
	shutoff = false