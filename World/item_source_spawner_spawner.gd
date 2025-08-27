extends Node2D

const MAP_SIZE = 100
const MIN_DISTANCE = 1000.0
const MIN_DISTANCE_SQUARED = MIN_DISTANCE * MIN_DISTANCE
const FREQUENCY = 0.001

@export var item_source_spawner_scene: PackedScene


func _ready() -> void:
    seed(3)
    for x in MAP_SIZE * 2:
        for y in MAP_SIZE * 2:
            if randf() > FREQUENCY:
                continue
            var pos = Vector2(x - MAP_SIZE, y - MAP_SIZE) * 128.0
            if pos.distance_squared_to(Vector2.ZERO) < MIN_DISTANCE_SQUARED:
                continue
            var new_source_spawner: ItemSourceSpawner = (
                item_source_spawner_scene.instantiate()
            )
            new_source_spawner.position = pos
            add_child(new_source_spawner)
            new_source_spawner.create_sources()
    #rand_from_seed()
