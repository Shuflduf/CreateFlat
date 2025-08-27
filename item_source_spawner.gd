@tool
class_name ItemSourceSpawner
extends Node2D

@export_tool_button("Spawn") var create_sources_action = create_sources
@export var noise_tex: NoiseTexture2D
@export var item_source_scene: PackedScene
@export var max_range = 10
@export var block_count = 40
@export var output_image: ImageTexture

var current_blocks_pos: Array[Vector2i]

func create_sources():
    var flat_noise = noise_tex.noise.get_image(32, 32, false, false, true)
    for x in flat_noise.get_width():
        for y in flat_noise.get_height():
            var col = flat_noise.get_pixel(x, y)
            var value = col.v
            col.v = snapped(value, 0.2)
            flat_noise.set_pixel(x, y, col)
    output_image = ImageTexture.create_from_image(flat_noise)
    print("A")
