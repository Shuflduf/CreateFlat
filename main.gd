extends Node2D

const TILE_SIZE = 128.0
const HALF_TILE = TILE_SIZE / 2.0

func _physics_process(_delta: float) -> void:
    var mouse_pos = get_global_mouse_position() - Vector2(HALF_TILE, HALF_TILE)
    var tile_pos = mouse_pos.snapped(Vector2(TILE_SIZE, TILE_SIZE))
    $CursorSelection.position = tile_pos

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            var new_component = preload("res://shaft.tscn").instantiate()
            $Components.add_child(new_component)
            new_component.position = $CursorSelection.position
