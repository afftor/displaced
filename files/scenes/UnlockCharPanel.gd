extends Control

var queue = []
var cur_char = -1
onready var unlock_panel = $UnlockPanel

func _ready():
	$panel/close_btn.connect('pressed', self, 'show_next')
	hide()

func open(char_id :String, join :bool = true):
	queue.append([char_id, join])
	if !visible:
		show_next()

func show_next():
	cur_char += 1
	unlock_panel.hide()
	if cur_char >= queue.size():
		queue.clear()
		cur_char = -1
		hide()
		return
	
	var join :bool = queue[cur_char][1]
	var character = state.heroes[queue[cur_char][0]]
	$panel/TextureJoin.visible = join
	$panel/TextureLeave.visible = !join
	$panel/icon_border/icon.texture = character.portrait()
	$panel/icon_border/name.text = character.name
	if join:
		$panel/info.text = tr("UNLOCKCHARJOIN")
		var new_resists :Array = character.unlock_resists()
		for new_resist in new_resists:
			unlock_panel.show_resist(new_resist)
#		print("unlock char!!!!")
#		print(new_resists)
	else:
		$panel/info.text = tr("UNLOCKCHARLEAVE")
	if !visible:
		show()


