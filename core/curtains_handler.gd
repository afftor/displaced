extends Control

var curtain_nodes = {};
signal anim_finished #the signal is currently unused

func _ready():
	var curtains = [
		{	"node" : $battle,
			"id" : variables.CURTAIN_BATTLE},
		{	"node" : $scene,
			"id" : variables.CURTAIN_SCENE}
	]
	
	for curtain in curtains:
		curtain_nodes[curtain.id] = curtain.node
		input_handler.GetTweenNode(curtain.node).connect(
			"tween_all_completed", self, 
			"emit_signal", ["anim_finished", curtain.id])

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
