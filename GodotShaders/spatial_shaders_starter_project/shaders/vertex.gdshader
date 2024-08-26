shader_type spatial;

void vertex() {
	//VERTEX += vec3(sin(TIME), cos(TIME), tan(TIME));
	//VERTEX *= (sin(TIME * 10.0) + 1.0) * 0.5;
	VERTEX.x += sin(TIME * 10.0 + VERTEX.y * 10.0) * 0.02;
	
}