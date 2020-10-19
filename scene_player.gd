extends Control

func _on_Button_pressed():
	$FileDialog.popup();


func _on_FileDialog_file_selected(path):
	globals.events_path = path.get_base_dir()
	var nm = path.get_file().get_basename();
	
	globals.StartEventScene(nm, true);
