shader_type canvas_item;

group_uniforms FirstGroup;
uniform float my_float: hint_range(0.0, 10.0, 0.1) = 5;
uniform vec4 my_color: source_color;
group_uniforms;

group_uniforms FirstGroup.TestGroup;
uniform int test_int: hint_range(0, 100, 1) = 25;
uniform bool test_bool;
group_uniforms;

void vertex() {
	float shear_factor = 30.0;
	float speed = 3.0;
	
	if (VERTEX.y < 0.0 && VERTEX.x > 0.0) {
		// top-right vertex
		VERTEX += vec2(sin(TIME * my_float) * shear_factor, sin(TIME * my_float) * shear_factor);
	}
	
	if (VERTEX.y > 0.0 && VERTEX.x < 0.0) {
	// bottom-left vertex
		VERTEX += vec2(sin(TIME * my_float) * shear_factor, sin(TIME * my_float) * shear_factor);
	}
	
	if (VERTEX.y < 0.0 && VERTEX.x < 0.0) {
	// top-left vertex
		VERTEX += vec2(cos(TIME * my_float) * shear_factor, sin(TIME * my_float) * shear_factor);
	}
	
	if (VERTEX.y > 0.0 && VERTEX.x > 0.0) {
	// bottom-right vertex
		VERTEX += vec2(cos(TIME * my_float) * shear_factor, sin(TIME * my_float) * shear_factor);
	}

}

void fragment() {
	vec4 color1 = vec4(1.,0.,0.,1.);
	vec4 color2 = vec4(0.,1.,0.,1.);

	vec4 mixed_color = mix(color1, color2, (sin(TIME*3.) + 1.) * 0.5);
	
	// sampling the color of the current pixel of the texture
	//COLOR = texture(TEXTURE, UV);
	
	//COLOR = vec4(UV.x, UV.y, abs(cos(TIME)), 1.0);
	COLOR = texture(TEXTURE, UV) * my_color;
}

