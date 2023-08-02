extends Control

onready var label_node :Label = $label
onready var sprite_node :TextureRect = $sprite
export var resist_type :String = 'damage'
export(Texture) var damage
export(Texture) var slash
export(Texture) var pierce
export(Texture) var bludgeon
export(Texture) var light
export(Texture) var dark
export(Texture) var air
export(Texture) var water
export(Texture) var earth
export(Texture) var fire
export var positive_color :Color = Color('#00ff0a')
export var negative_color :Color = Color('#ff0000')

func _ready():
	label_node.connect("item_rect_changed", self, "on_label_rect_changed")
	set_resist_type(resist_type)

func on_label_rect_changed() ->void:
	rect_min_size.x = label_node.get_rect().end.x


func set_resist_type(new_type :String) ->void:
	var tex = get(new_type)
	assert(tex != null, "Impossible to set an unexistent resist type %s!" % new_type)
	resist_type = new_type
	sprite_node.texture = tex

func update_value(value :String, positive :bool = true) ->void:
	label_node.show()
	label_node.text = value
	var label_color :Color
	if positive:
		label_color = positive_color
	else:
		label_color = negative_color
	label_node.add_color_override('font_color', label_color)

func hide_value() ->void:
	label_node.hide()
	rect_min_size.x = sprite_node.rect_size.x

func set_resistance(new_type :String, value :String, positive :bool = true) ->void:
	set_resist_type(new_type)
	update_value(value, positive)

func get_resist_type() ->String:
	return resist_type




