shader_type canvas_item;

uniform int blur_size = 10;
//size of a box around pixel to average it
//10 means from (-5,-5) to (4,4) = 100 operations
uniform int sampling = 2;
//thins out pixel sampling, 2 means sampling only one of every 2*2 box of pixels
//for box of 10 = 25 operations instead of 100

void fragment() {
	vec3 tmp = vec3(0.0);
	float indent = floor(float(blur_size) * 0.5);//float(blur_size/2)
	vec2 pix_size = TEXTURE_PIXEL_SIZE;
	vec2 pix_step = pix_size * float(sampling);
	float x = UV.x - indent * pix_size.x;
	int repeat = blur_size / sampling;
	for (int i = 0; i < repeat; i++) {
		float y = UV.y - indent * pix_size.y;
		for (int j = 0; j < repeat; j++){
			tmp += texture(TEXTURE, vec2(x,y)).rgb;
			y += pix_step.y;
		}
		x += pix_step.x;
	}
	tmp = tmp / (float(repeat * repeat));
	COLOR.rgb = tmp;
}