extends TextureButton

export var charname = "Null";
var next_scene = "";
var active = false;

var timer = 0.0;
var k = 1.0;

func _process(delta):
	timer += k*delta;
	if timer > 0.8:
		timer = 0.8;
		k = -1.0;
	if timer < 0.0:
		timer = 0.0;
		k = 1.0;
	if material == null: return;
	material.set_shader_param('opacity', timer);

func _ready():
	connect('pressed', self, '_onclick');
	add_to_group("char_sprite");
	set_active_val();
	regenerate_click_mask();

func regenerate_click_mask():
	var t = texture_normal.get_data();
	var ti = Image.new();
	ti.copy_from(t);
	var tti = Image.new();
	tti.create(rect_size.x, rect_size.y, false, 5);
	var k = min (tti.get_width()*1.0/ti.get_width(), tti.get_height()*1.0/ti.get_height());
	ti.resize(int(ti.get_width()*k), int(ti.get_height()*k));
	var offset = 0.5*(tti.get_size() - ti.get_size());
	tti.blend_rect(ti, Rect2(Vector2(0,0), ti.get_size()), offset);
	texture_click_mask = BitMap.new();
	texture_click_mask.create_from_image_alpha(tti);

func _onclick():
	if !active:return;
	active = false;
	material = null;
	set_process(false);
	.update();
	globals.StartEventScene(next_scene);

func set_active_val():
	if state.CurEvent != "": return;
	for e in events.characters[charname]:
		var res = globals.SimpleEventCheck(e);
		if res:
			active = true;
			next_scene = e;
			material = load("res://files/portret_shader.tres");
			set_process(true);
			.update();
			return
			pass
		pass
	active = false;
	material = null;
	next_scene = "";
	set_process(false);
	.update();