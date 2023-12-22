extends Control

onready var grid_node :CanvasItem = $GridContainer
onready var resists :Dictionary = {
	'damage' : $GridContainer/damage,
	'slash' : $GridContainer/slash,
	'pierce' : $GridContainer/pierce,
	'bludgeon' : $GridContainer/bludgeon,
	'light' : $GridContainer/light,
	'dark' : $GridContainer/dark,
	'air' : $GridContainer/air,
	'water' : $GridContainer/water,
	'earth' : $GridContainer/earth,
	'fire' : $GridContainer/fire,
	'burn' : $GridContainer/burn,
	'stun' : $GridContainer/stun,
	'chill' : $GridContainer/chill,
	'negative' : $GridContainer/negative,
	'poison' : $GridContainer/poison,
	'bleed' : $GridContainer/bleed
}

func _ready():
	for resist_type in variables.resistlist:
		assert(resists.has(resist_type), "%s is not introduced in ResistToolTip!" % resist_type)
		assert(resists[resist_type].get_resist_type() == resist_type, "ResistIcon %s is incorrect!" % resist_type)
	grid_node.connect("item_rect_changed", self, "on_grid_rect_changed")

func on_grid_rect_changed() ->void:
	rect_min_size = grid_node.rect_size + grid_node.rect_position * 2


func show_up(char_id: String) ->void:
	var chara = state.heroes[char_id]
	var data :Dictionary = chara.get_resists().duplicate()#in fact get_resists() return unique dict for now, but it's better to duplicate it once more in case of future changes
	data.merge(chara.get_s_resists())
	var show_me :bool = false
	for resist_type in resists:
		if !data.has(resist_type) or data[resist_type] == 0:
			resists[resist_type].hide()
		else:
			resists[resist_type].update_value(
				String(data[resist_type]),
				data[resist_type] > 0)
			resists[resist_type].show()
			show_me = true
	if show_me:
		show()


