shader_type canvas_item;
render_mode blend_mix;

void fragment(){
    vec4 color = texture(TEXTURE, UV);
	vec3 buf = color.rgb;
	vec3 mask = vec3(0.3, 0.59, 0.11);
	float l = dot(buf, mask);
	color.x = l;
	color.y = l;
	color.z = l;
	COLOR = color;
}