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
	var tween = input_handler.GetTweenNode(self)
	var time
	if RndDelay:
		time = globals.rng.randf_range(MinDelay, MaxDelay)
	else:
		time = MinDelay
	tween.interpolate_callback(self, time, 'play', "default")
	tween.start()


#func play(anim = "", backwards = false):
#	print("+")
#	.play(anim, backwards)
