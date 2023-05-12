extends Control

var curtain_nodes = {};
signal anim_finished

func _ready():
	var curtain = $battle
	curtain_nodes[variables.CURTAIN_BATTLE] = curtain
	input_handler.GetTweenNode(curtain).connect(
		"tween_all_completed", self, 
		"emit_signal", ["anim_finished", variables.CURTAIN_BATTLE])
	
	curtain = $scene
	curtain_nodes[variables.CURTAIN_SCENE] = curtain
	input_handler.GetTweenNode(curtain).connect(
		"tween_all_completed", self, 
		"emit_signal", ["anim_finished", variables.CURTAIN_SCENE])

func show_anim(curtain_type :int, duration :float = 0.5):
	input_handler.UnfadeAnimation(curtain_nodes[curtain_type], duration)

func show_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.GetTweenNode(curtain).stop_all()
	curtain.modulate.a = 1
	curtain.show()

func hide_anim(curtain_type :int, duration :float = 0.5):
	input_handler.FadeAnimation(curtain_nodes[curtain_type], duration)

func hide_inst(curtain_type :int):
	var curtain = curtain_nodes[curtain_type]
	input_handler.GetTweenNode(curtain).stop_all()
	curtain.hide()
