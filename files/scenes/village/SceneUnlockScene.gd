extends Control

signal show_pressed
signal unlocked_pressed

onready var watch_btn = $watch_btn
onready var unlock_btn = $unlock_btn
onready var image = $Image
onready var label = $Label
onready var lock = $lock
onready var reqs = $reqs
onready var panel = $panel

export(Material) var highlighted_material


func _ready():
	watch_btn.connect('pressed', self, 'emit_signal', ["show_pressed"])
	unlock_btn.connect('pressed', self, 'emit_signal', ["unlocked_pressed"])

func set_unlocked(eventdata :Dictionary):
	set_preview(eventdata)
	label.text = "%s\n%s" % [tr(eventdata.name), tr(eventdata.descript)]
	lock.hide()
	image.material = null#unblur for on-texture shader
	#bluring now by shader, but maybe it would be more efficient to generate
	#blurred image from original through get_pixel()/set_pixel() with same
	#shader's algorithm. Mind it in case of freezes in the scene with shaders
	reqs.hide()
	unlock_btn.hide()

func set_highlighted(toggle: bool):
	if toggle: panel.material = highlighted_material
	else: panel.material = null

func set_unlockable(eventdata :Dictionary):
	set_preview(eventdata)
	label.text = tr(eventdata.name)
	var cost_con = reqs.get_node("list")
	input_handler.ClearContainer(cost_con, ['line'])
	for ch in eventdata.unlock_price:
		if eventdata.unlock_price[ch] == 0: continue
		var hero = state.heroes[ch]
		var line = input_handler.DuplicateContainerTemplate(cost_con, 'line')
		line.get_node('TextureRect').texture = hero.portrait()
		var line_label = line.get_node('Label')
		line_label.text = "%d/%d" % [int(hero.friend_points), eventdata.unlock_price[ch]]
		if eventdata.unlock_price[ch] > hero.friend_points:
			line_label.set("custom_colors/font_color", variables.hexcolordict.red)
			unlock_btn.hide()
	watch_btn.hide()

func set_unknown():
	image.hide()
	label.text = tr("UNKNOWN")
	reqs.hide()
	watch_btn.hide()
	unlock_btn.hide()


func set_preview(eventdata :Dictionary):
	if eventdata.has('preview'):
		image.texture = resources.get_res("scene_preview/%s" % eventdata.preview)
