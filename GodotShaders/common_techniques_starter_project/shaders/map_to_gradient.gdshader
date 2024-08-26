shader_type canvas_item;

uniform sampler2D gradient_texture;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	float grayscale = (original_color.r + original_color.g + original_color.b) / 3.0;
	
	vec2 sample_coords = vec2(grayscale);
	vec4 gradient_color = texture(gradient_texture, sample_coords);
	
	//vec4 gradient_color = texture(gradient_texture, UV);
	
	COLOR = gradient_color;
	COLOR.a = original_color.a;
}