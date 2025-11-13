shader_type spatial;
render_mode unshaded;

uniform sampler2D OFFSET_TEX;
uniform sampler2D OPACITY_TEX;
uniform sampler2D TEX;
uniform sampler2D SCREEN_TEX: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(SCREEN_TEX, SCREEN_UV + (texture(OFFSET_TEX, UV).xy - .5) * .1).rgb;
	float opacity = texture(OPACITY_TEX, UV).x;
	ALBEDO = texture(TEX, UV).xyz * opacity + ALBEDO * (1. - opacity);
	//ALBEDO = ALBEDO + texture(TEX, UV).rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
