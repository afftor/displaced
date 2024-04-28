extends AnimatedSprite
class_name AnimatedSpriteDelay

export var MinDelay = 0.0
export var MaxDelay = 1.0
export var RndDelay = true

func _ready():
	connect("animation_finished", self, 'make_random_pause')
	playing = true


func make_random_pause():
	stop()
	var time
	if RndDelay:
		time = globals.rng.randf_range(MinDelay, MaxDelay)
	else:
		time = MinDelay
	input_handler.tween_callback(self, 'play', time, ["default"])


#func play(anim = "", backwards = false):
#	print("+")
#	.play(anim, backwards)
