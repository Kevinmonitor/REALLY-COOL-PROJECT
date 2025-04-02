shader_type canvas_item;

uniform bool whiten = false;
uniform float mix_weight = 1.0;

uniform vec3 color_a:source_color = vec3(0.7, 0.7, 0.7);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (whiten) {
		vec3 whitened_texture_rgb = mix(texture_color.rgb, color_a, mix_weight);
		COLOR = vec4(whitened_texture_rgb, COLOR.a);
	} 
	else {
		
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
