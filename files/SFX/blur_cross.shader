shader_type canvas_item;

uniform int blur_amount : hint_range(1,10) = 10;

void fragment() {
	vec4 sum = vec4(0.0);
	sum += texture(SCREEN_TEXTURE, SCREEN_UV);
	for(int i = 0; i < blur_amount; i++){
		sum += texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * vec2(float(i), 0.));
		sum += texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * vec2(0., float(i)));
		sum += texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * vec2(-float(i), 0.));
		sum += texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * vec2(0., -float(i)));
	}
	COLOR = sum / (float(blur_amount) * 4. + 1.);
}