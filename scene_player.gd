extends Control


func _ready():

	pass


func _on_Button_pressed():
	$FileDialog.popup();
	pass # replace with function body


func _on_FileDialog_file_selected(path):
	var nm = path.get_file().get_basename();
	globals.StartEventScene(nm, true);
	pass # replace with function body
