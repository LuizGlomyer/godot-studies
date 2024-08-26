shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float dissolve_percentage: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec4 final_color = original_color;
	vec4 noise = texture(noise_tex, UV);
	
	if(dissolve_percentage > noise.r){
		final_color.a = 0.0;
	}
	
	COLOR = final_color;
}