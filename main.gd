extends Node2D

const TILE_SIZE = 128.0
const HALF_TILE = TILE_SIZE / 2.0

@onready var all_components: Dictionary[Vector2i, MechanicalComponent] = {
    Vector2i(0, 0): $Components/Motor
}

func _physics_process(_delta: float) -> void:
    var mouse_pos = get_global_mouse_position() - Vector2(HALF_TILE, HALF_TILE)
    var tile_pos = mouse_pos.snapped(Vector2(TILE_SIZE, TILE_SIZE))
    $CursorSelection.position = tile_pos

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            var new_component = preload("res://Blocks/Shaft/shaft.tscn").instantiate()
            $Components.add_child(new_component)
            new_component.position = $CursorSelection.position
            var grid_pos = Vector2i($CursorSelection.position / 128.0) 
            print(grid_pos)
            all_components[grid_pos] = new_component
            
            for test_dir in MechanicalComponent.DIR_MAPPINGS:
                var offset = MechanicalComponent.DIR_MAPPINGS[test_dir]
                var test_pos = grid_pos + offset
                if all_components.has(test_pos):
                    new_component.neighbors[test_dir] = all_components[test_pos]
                    all_components[test_pos].neighbors[MechanicalComponent.OPPOSITE_DIRS[test_dir]] = new_component
                
            print(new_component.neighbors)
