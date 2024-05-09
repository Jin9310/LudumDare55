shader_type canvas_item;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	float color_average = (input_color.r + input_color.g + input_color.b) / 3.0;
	vec4 output_color = vec4(color_average, color_average, color_average, input_color.a);
	if (output_color.r > 0.8 && output_color.g > 0.8 && output_color.b > 0.8) {
		output_color.a = 0.0;
	}
	COLOR = output_color;
}
