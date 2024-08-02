extends Control

var curtain_nodes :Dictionary
signal anim_finished #the signal is currently unused
var tween_finish_signal :String

func _ready():
	curtain_nodes = {
		variables.CURTAIN_BATTLE : $battle,
		variables.CURTAIN_SCENE : $scene
	}
	tween_finish_signal = input_handler.get_tween_finish_signal()

#the thing is, Tween can now be recreated, so we have to connect to it's current incarnation
func connect_to_cur_tween(id):
	var cur_tween = input_handler.GetTweenNode(curtain_nodes[id])
	if cur_tween.is_connected(tween_finish_signal, self, "on_anim_completed"):
		return
	cur_tween.connect(tween_finish_signal, self,
		"on_anim_completed", [id])

func on_anim_completed(curtain_id):
	var curtain = curtain_nodes[curtain_id]
	if curtain.modulate.a < 0.01:
		curtain.hide()
	emit_signal("anim_finished", curtain_id)

func show_anim(curtain_type :int, duration :float = 0.5):
	input_handler.UnfadeAnimation(curtain_nodes[curtain_type], duration)
	connect_to_cur_tween(curtain_type)

func show_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.force_end_tweens(curtain)
	curtain.modulate.a = 1
	curtain.show()

func hide_anim(curtain_type :int, duration :float = 0.5):
	input_handler.FadeAnimation(curtain_nodes[curtain_type], duration)
	connect_to_cur_tween(curtain_type)

func hide_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.force_end_tweens(curtain)
	curtain.hide()
