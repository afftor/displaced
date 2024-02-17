shader_type canvas_item;

uniform int blurSize : hint_range(1,20) = 10;

//mind that "SCREEN_" type bluring do not work in cloned nodes for some reason
void fragment() {
	//COLOR.rgb = textureLod(SCREEN_TEXTURE,SCREEN_UV,amount).rgb;
	vec3 tmp = vec3(0.0);
	vec2 k = SCREEN_PIXEL_SIZE;
	float x = SCREEN_UV.x - float(blurSize)*k.x*0.5;
	for (int i = 0; i < blurSize; i++) {
		float y = SCREEN_UV.y - float(blurSize)*k.y*0.5;
		for (int j = 0; j < blurSize; j++){
			tmp += texture(SCREEN_TEXTURE, vec2(x,y)).rgb;
			y += k.y;
		}
		x += k.x;
	}
	tmp = tmp / (float(blurSize * blurSize));
	COLOR.rgb = tmp;
}