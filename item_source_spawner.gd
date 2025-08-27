@tool
class_name ItemSourceSpawner
extends Node2D

@export_tool_button("Spawn") var create_sources_action = create_sources
@export var item_source_scene: PackedScene
@export var circle_radius = 5
@export var max_offset_radius = 10

var current_blocks_pos: Array[Vector2i]

func create_sources():
    current_blocks_pos = []
    for child in get_children():
        child.queue_free()

    var center_offset = Vector2i(
        randi_range(-max_offset_radius, max_offset_radius),
        randi_range(-max_offset_radius, max_offset_radius),
    )
    var top_left_offset = center_offset + Vector2i(circle_radius, circle_radius)
    for x in circle_radius * 2:
        for y in circle_radius * 2:
            var pos = Vector2i(x, y) + center_offset
            print(pos)
            var new_source = item_source_scene.instantiate()
            new_source.position = Vector2(pos) * 128.0
            add_child(new_source)



    print("A")
