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
    var grid_pos = Vector2i(tile_pos / 128.0)
    if all_components.has(grid_pos):
        var target = all_components[grid_pos]
        DebugDraw2D.set_text("Component", target.connections)
    DebugDraw2D.set_text("Position", grid_pos)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            var grid_pos = Vector2i($CursorSelection.position / 128.0) 
            if not all_components.has(grid_pos):
                var new_component = preload("res://Blocks/Shaft/shaft.tscn").instantiate()
                $Components.add_child(new_component)
                new_component.position = $CursorSelection.position
                
                all_components[grid_pos] = new_component
            connect_neighbors(grid_pos)
    
func connect_neighbors(new_component_pos: Vector2i):
    var new_component = all_components[new_component_pos]
    print(new_component.connections)
    for test_dir in new_component.connections:
        var connector: MechanicalConnector = new_component.connections[test_dir]
        var offset = MechanicalComponent.DIR_MAPPINGS[test_dir]
        var test_pos = new_component_pos + offset
        if all_components.has(test_pos):
            var neighbor = all_components[test_pos]
            var opposite_dir = MechanicalComponent.OPPOSITE_DIRS[test_dir]
            if neighbor.connections.has(opposite_dir):
                var neighbor_connector: MechanicalConnector = neighbor.connections[opposite_dir]
                connector.connected_to = neighbor_connector
                neighbor_connector.connected_to = connector
                neighbor_connector.sprites.frame = connector.sprites.frame
        
