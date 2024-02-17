shader_type canvas_item;

//works only with mipmaping (import option of TEXTURE)
uniform float lod: hint_range(1., 5.) = 5.0;

void fragment(){
	COLOR = texture(TEXTURE, UV, lod);
}