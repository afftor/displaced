extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	$FileDialog.popup();
	pass # replace with function body


func _on_FileDialog_file_selected(path):
	var nm = path.get_file().get_basename();
	globals.StartEventScene(nm, true);
	pass # replace with function body
