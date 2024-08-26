shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
	vec4 mask_color = texture(mask_texture, UV);
	vec4 original_color = texture(TEXTURE, UV);
	//COLOR = mask_color;
	
	if(original_color.a > 0.0) {
		COLOR.a = mask_color.r;
	}
}