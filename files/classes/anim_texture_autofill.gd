extends AnimatedTexture
class_name AnimatedTexAutofill

export var prefix: String

func fill_frames():
	fps = 24
	var  loc = resource_path
	if loc.is_abs_path():
		loc = loc.get_base_dir()
	for i in range(frames):
		var path = "%s/%s_%02d.png" % [loc, prefix, i]
		if ResourceLoader.exists(path):
			set_frame_texture(i, load(path))
		else:
			print("ERROR can't find %d frame for animated texture %s" % [i, prefix])
			return


func get_size():
	return get_frame_texture(0).get_size()

