extends Button

export var index = 0;
signal i_pressed(i);

func press():
	emit_signal('i_pressed',index);
	pass

func _ready():
	connect('pressed', self, 'press');
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
