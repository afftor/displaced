extends Control

onready var label_node :Label = $label
onready var immun_node :TextureRect = $immun
onready var sprite_node :TextureRect = $sprite
export var resist_type :String = 'damage'
export var positive_color :Color = Color('#ff0000')
export var negative_color :Color = Color('#00ff0a')
export var neutral_color :Color = Color('#e0e0e0')

func _ready():
	label_node.connect("item_rect_changed", self, "on_label_rect_changed")
	set_resist_type(resist_type)


func on_label_rect_changed() ->void:
	if !label_node.visible : return
	rect_min_size.x = label_node.get_rect().end.x

func on_immun_show() ->void:
	if !immun_node.visible : return
	rect_min_size.x = immun_node.get_rect().end.x

func set_resist_type(new_type :String) ->void:
	var resist_data = variables.get_resist_data(new_type)
	resist_type = new_type
	sprite_node.texture = resist_data.icon

func update_value(value :int, format :String = "%d") ->void:
	if format == "+" and value >= 100:
		label_node.hide()
		immun_node.show()
		on_immun_show()
		return
	
	immun_node.hide()
	label_node.show()
	on_label_rect_changed()
	var value_str :String
	if format == "+":
		if value > 50:
			value_str = "--"
		elif value > 0:
			value_str = "-"
		elif value == 0:
			value_str = "0"
		elif value >= -50:
			value_str = "+"
		else:
			value_str = "++"
	else:
		value_str = format % value
	label_node.text = value_str
	var label_color :Color
	if value > 0:
		label_color = positive_color
	elif value < 0:
		label_color = negative_color
	else:
		label_color = neutral_color
	label_node.add_color_override('font_color', label_color)

func set_resistance(new_type :String, value :int, format :String = "%d") ->void:
	set_resist_type(new_type)
	update_value(value, format)

func get_resist_type() ->String:
	return resist_type




