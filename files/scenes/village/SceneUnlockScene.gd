extends Control

signal show_pressed
signal unlocked_pressed

onready var button = $button
onready var unlock_btn = $unlock_btn
onready var image = $Image
onready var label = $Label
onready var lock = $lock
onready var reqs = $reqs


func _ready():
	button.connect('pressed', self, 'emit_signal', ["show_pressed"])
	unlock_btn.connect('pressed', self, 'emit_signal', ["unlocked_pressed"])

func set_unlocked(eventdata :Dictionary):
	if eventdata.has('icon'):
		image.texture = resources.get_res(eventdata.icon)
	label.text = "{name}\n{descript}".format(eventdata)
	lock.hide()
	reqs.hide()
	unlock_btn.hide()

func set_unlockable(eventdata :Dictionary):
	if eventdata.has('icon'):
		image.texture = resources.get_res(eventdata.icon)
	label.text = "Locked"
	var cost_con = reqs
	input_handler.ClearContainer(cost_con, ['line'])
	for ch in eventdata.unlock_price:
		var hero = state.heroes[ch]
		var line = input_handler.DuplicateContainerTemplate(cost_con, 'line')
		line.get_node('TextureRect').texture = hero.portrait()
		var line_label = line.get_node('Label')
		line_label.text = "%d/%d" % [eventdata.unlock_price[ch], hero.friend_points]
		if eventdata.unlock_price[ch] > hero.friend_points:
			line_label.set("custom_colors/font_color", variables.hexcolordict.red)
			unlock_btn.hide()
	button.hide()

func set_unknown():
	image.hide()
	label.text = "Unknown"
	reqs.hide()
	button.hide()
	unlock_btn.hide()
