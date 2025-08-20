shader_type canvas_item;

uniform bool top_shown = true;
uniform bool bottom_shown = true;

void fragment() {
    if ((UV.y < 0.5 && !top_shown) || (UV.y > 0.5 && !bottom_shown)) {
        COLOR.a = 0.0;
    }
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
