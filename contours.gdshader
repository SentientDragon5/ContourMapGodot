shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float contour_levels : hint_range(1.0, 25.0) = 8.0;
uniform float line_thickness : hint_range(0.0, 10.0) = 2.0;

void fragment() {
	float current_level = floor(texture(TEXTURE, UV).r * contour_levels);

	vec2 pixel_size = TEXTURE_PIXEL_SIZE * line_thickness;

	float p0 = floor(texture(TEXTURE, UV + vec2(-1.0, -1.0) * pixel_size).r * contour_levels);
	float p1 = floor(texture(TEXTURE, UV + vec2( 0.0, -1.0) * pixel_size).r * contour_levels);
	float p2 = floor(texture(TEXTURE, UV + vec2( 1.0, -1.0) * pixel_size).r * contour_levels);
	float p3 = floor(texture(TEXTURE, UV + vec2(-1.0,  0.0) * pixel_size).r * contour_levels);
	float p4 = floor(texture(TEXTURE, UV + vec2( 1.0,  0.0) * pixel_size).r * contour_levels);
	float p5 = floor(texture(TEXTURE, UV + vec2(-1.0,  1.0) * pixel_size).r * contour_levels);
	float p6 = floor(texture(TEXTURE, UV + vec2( 0.0,  1.0) * pixel_size).r * contour_levels);
	float p7 = floor(texture(TEXTURE, UV + vec2( 1.0,  1.0) * pixel_size).r * contour_levels);

	float gx = (p2 + 2.0 * p4 + p7) - (p0 + 2.0 * p3 + p5);
	float gy = (p5 + 2.0 * p6 + p7) - (p0 + 2.0 * p1 + p2);
	float edge_magnitude = length(vec2(gx, gy));

	float line = step(0.1, edge_magnitude);

	vec4 color = 0.0 * texture(TEXTURE, UV);

	COLOR = mix(color, line_color, line);
	COLOR.a = color.a + line_color.a * line;
}