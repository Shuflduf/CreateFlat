extends Node2D

const TILE_SIZE = 128.0
const HALF_TILE = TILE_SIZE / 2.0

func _physics_process(delta: float) -> void:
    var mouse_pos = get_global_mouse_position() - Vector2(HALF_TILE, HALF_TILE)
    var tile_pos = mouse_pos.snapped(Vector2(TILE_SIZE, TILE_SIZE))
    $CursorSelection.position = tile_pos
