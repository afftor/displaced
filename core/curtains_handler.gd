extends Control

var curtain_nodes = {};
signal show_anim_finished
signal hide_anim_finished

func _ready():
	curtain_nodes[variables.CURTAIN_BATTLE] = $battle
	curtain_nodes[variables.CURTAIN_SCENE] = $scene

func show_anim(curtain_type :int, duration :float = 0.5):
	var curtain = curtain_nodes[curtain_type]
	input_handler.UnfadeAnimation(curtain, duration)
	input_handler.GetTweenNode(curtain).connect(
		"tween_all_completed", self, 
		"show_anim_signal", [curtain_type], 
		CONNECT_ONESHOT)

func show_anim_signal(curtain_type :int) ->void:
	emit_signal("show_anim_finished", curtain_type)

func show_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.GetTweenNode(curtain).stop_all()
	curtain.modulate.a = 1
	curtain.show()

func hide_anim(curtain_type :int, duration :float = 0.5):
	var curtain = curtain_nodes[curtain_type]
	input_handler.FadeAnimation(curtain, duration)
	input_handler.GetTweenNode(curtain).connect(
		"tween_all_completed", self, 
		"hide_anim_signal", [curtain_type], 
		CONNECT_ONESHOT)

func hide_anim_signal(curtain_type :int) ->void:
	emit_signal("hide_anim_finished", curtain_type)

func hide_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.GetTweenNode(curtain).stop_all()
	curtain.hide()
