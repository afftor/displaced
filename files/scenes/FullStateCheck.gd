extends Button

export var checked = false setget set_state

var state1 = load("res://assets/themes/check_pressed.tres")
var state2 = load("res://assets/themes/check_unpressed.tres")


func _ready():
	set_state(false)
	connect("pressed", self, 'set_state', [])


func set_state(value = null):
	if value == null: value = !checked
	checked = value
	if checked:
		theme = state1
	else:
		theme = state2
	update()
