class_name ItemSourceSpawner
extends Node2D

@export var item_source_scene: PackedScene
@export var circle_radius = 5.0
@export var materials: Array[ItemData]

var current_blocks_pos: Array[Vector2i]

func create_sources():
    current_blocks_pos = []
    for child in get_children():
        child.queue_free()

    for x in circle_radius * 2.0:
        for y in circle_radius * 2.0:
            var pos = Vector2(x - circle_radius, y - circle_radius)
            if pos.length() > circle_radius:
                continue
            if pos.length() > randf_range(circle_radius / 2.0, circle_radius):
                continue
            var new_source: ItemSource = item_source_scene.instantiate()
            new_source.position = Vector2(pos) * 128.0

            add_child(new_source)
            new_source.item_data = materials.pick_random()
            new_source.update_texture()
