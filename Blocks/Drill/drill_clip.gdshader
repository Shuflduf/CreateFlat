shader_type canvas_item;

uniform bool clipped = false;

void fragment() {
	if (UV.y < 0.46 && clipped) {
        discard;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
