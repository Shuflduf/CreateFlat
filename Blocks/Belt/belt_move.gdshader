shader_type canvas_item;

uniform bool flipped = false;
uniform bool small = false;
uniform float speed = 0.0;

const float SPEED_MULT = 1.8;

void fragment() {
    float offset = TIME * (flipped ? -1.0 : 1.0) * (small ? 1.5: 1.0) * speed * SPEED_MULT;
    vec2 target = mod(UV + vec2(offset, 0.0), 1.0);
	COLOR.rgb = texture(TEXTURE, target).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
