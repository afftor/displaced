extends NinePatchRect

var parentnode
var shutoff = false
var prevnode
onready var iconnode = $Image
onready var textnode = $RichTextLabel


func _process(delta):
	var fixed_global_rect = parentnode.get_global_rect()
	fixed_global_rect.size = fixed_global_rect.size * parentnode.get_global_transform().get_scale()
	if parentnode != null && ( parentnode.is_visible_in_tree() == false || !fixed_global_rect.has_point(get_global_mouse_position())):
		set_process(false)
		hide()

func _init():
	set_process(false)
	#connect("popup_hide", self, 'cooldown')

#legacy code
#func showup_usable(node, item):
#	var text = ''
#	text = item.tooltiptext()
#	textnode.bbcode_text = globals.TextEncoder(text)
#	input_handler.itemshadeimage(iconnode, item)
#	$Cost/Label.text = str(item.calculateprice())
#	showup(node)

func showup_material(node, item):
	var text = ''
	text = '[center]' + tr(item.name) + '[/center]\n' + tr(item.description)
	if state.materials[item.code] > 0:
		text += '\n\n' + tr("INPOSESSION") + ": " + str(state.materials[item.code])
	textnode.bbcode_text = text
	iconnode.texture = item.icon
	iconnode.material = null
#	$Cost/Label.text = str(Items.Items[item.code].price)
	$Cost/Label.text = str(item.price)
	showup(node)

#legacy code
#func showup_gear(node, item):
#	var text = ''
#	text = '[center]' + item.name + '[/center]\n' + item.description
#	textnode.bbcode_text = globals.TextEncoder(text)
#	input_handler.itemshadeimage(iconnode, item)
#	iconnode.material = null
#	showup(node)

func showup(node):
	parentnode = node
	
	var screen = get_viewport().get_visible_rect()
	if shutoff == true && prevnode == parentnode:
		return
	
	prevnode = parentnode
	
	input_handler.GetTweenNode(self).stop_all()
	self.modulate.a = 1
	
	show()
	
	var node_rect = node.get_global_rect()
	self.set_global_position(Vector2(
		node_rect.position.x + node_rect.size.x * 0.5 - rect_size.x * 0.5,
		node_rect.end.y + 5))
	
	if rect_global_position.x < 0:
		rect_global_position.x = 0
	if get_global_rect().end.x > screen.size.x:
		rect_global_position.x -= get_rect().end.x - screen.size.x
	if get_global_rect().end.y > screen.size.y:
		rect_global_position.y = node_rect.position.y - rect_size.y - 5
	
	set_process(true)

#func cooldown():
#	shutoff = true
#	yield(get_tree().create_timer(0.2), 'timeout')
#	shutoff = false

func hide():
	parentnode = null
	set_process(false)
	input_handler.FadeAnimation(self, 0.2)
