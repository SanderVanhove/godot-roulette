shader_type canvas_item;

uniform float alpha_amount: hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.a *= smoothstep(1.0 - alpha_amount, 1.0 - alpha_amount + 0.3, color.r);
	//color.a *= smoothstep(color.a, alpha_amount, alpha_amount);
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
