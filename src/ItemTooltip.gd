extends PopupPanel

var parentnode
var shutoff = false
var prevnode
onready var iconnode = $Image
onready var textnode = $RichTextLabel


func _process(delta):
	if parentnode != null && ( parentnode.is_visible_in_tree() == false || !parentnode.get_global_rect().has_point(get_global_mouse_position())):
		set_process(false)
		hide()

func _init():
	set_process(false)
	connect("popup_hide", self, 'cooldown')

func showup(node, item):
	parentnode = node
	if shutoff == true && prevnode == parentnode:
		return
	var type
	
	if typeof(item) == TYPE_DICTIONARY:
		type = 'material'
	
	type = item.itemtype
	
	if type != 'material':
		var text = item.tooltiptext()
#		if type in ['armor','weapon']:
#			text += item.tooltipeffects()
		textnode.bbcode_text = globals.TextEncoder(text)
		input_handler.itemshadeimage(iconnode, item)
	
	prevnode = parentnode
	
	popup()
	
	var pos = node.get_global_rect()
	pos = Vector2(pos.position.x, pos.end.y + 10)
	self.set_global_position(pos)
	
	set_process(true)

func cooldown():
	shutoff = true
	yield(get_tree().create_timer(0.2), 'timeout')
	shutoff = false

func hide():
	parentnode = null
	set_process(false)
	.hide()