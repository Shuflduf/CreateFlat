class_name ItemSourceFactory
extends Node2D

const MIN_DISTANCE = 300.0
const MIN_DISTANCE_SQUARED = MIN_DISTANCE * MIN_DISTANCE
const FREQUENCY = 0.001

@export var item_source_spawner_scene: PackedScene

@export_dir var sources_path
var sources: Array[ItemData]
var gen_seed = randi()


func _ready() -> void:
    print(gen_seed)
    var dir = DirAccess.open(sources_path)
    for file in dir.get_files():
        var data: ItemData = ResourceLoader.load(sources_path + "/" + file)
        sources.append(data)

    seed(gen_seed)
    for x in MoreConsts.MAP_SIZE * 2:
        for y in MoreConsts.MAP_SIZE * 2:
            if randf() > FREQUENCY:
                continue
            var pos = (
                Vector2(x - MoreConsts.MAP_SIZE, y - MoreConsts.MAP_SIZE)
                * 128.0
            )
            pos += Vector2(64.0, 64.0)
            if pos.distance_squared_to(Vector2.ZERO) < MIN_DISTANCE_SQUARED:
                continue
            var new_source_spawner: ItemSourceSpawner = (
                item_source_spawner_scene.instantiate()
            )
            new_source_spawner.item_data = sources.pick_random()
            new_source_spawner.position = pos
            add_child(new_source_spawner)
            new_source_spawner.create_sources()
    #rand_from_seed()
