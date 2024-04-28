extends Control

var curtain_nodes :Dictionary
signal anim_finished #the signal is currently unused

func _ready():
	curtain_nodes = {
		variables.CURTAIN_BATTLE : $battle,
		variables.CURTAIN_SCENE : $scene
	}
	for id in curtain_nodes:
		input_handler.GetTweenNode(curtain_nodes[id]).connect(
			input_handler.get_tween_finish_signal(), self,
			"on_anim_completed", [id])

func on_anim_completed(curtain_id):
	var curtain = curtain_nodes[curtain_id]
	if curtain.modulate.a < 0.01:
		curtain.hide()
	emit_signal("anim_finished", curtain_id)

func show_anim(curtain_type :int, duration :float = 0.5):
	input_handler.UnfadeAnimation(curtain_nodes[curtain_type], duration)

func show_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.force_end_tweens(curtain)
	curtain.modulate.a = 1
	curtain.show()

func hide_anim(curtain_type :int, duration :float = 0.5):
	input_handler.FadeAnimation(curtain_nodes[curtain_type], duration)

func hide_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.force_end_tweens(curtain)
	curtain.hide()
