extends Node2D

const TILE_SIZE = 128.0
const HALF_TILE = TILE_SIZE / 2.0
const HALF_PI = 1.5708

@onready var all_components: Dictionary[Vector2i, MechanicalComponent] = {
    Vector2i(0, 0): $Components/Motor
}

@export var selected_component: PackedScene

var rotation_index = 0

func _physics_process(_delta: float) -> void:
    var mouse_pos = get_global_mouse_position() - Vector2(HALF_TILE, HALF_TILE)
    var tile_pos = mouse_pos.snapped(Vector2(TILE_SIZE, TILE_SIZE))
    $CursorSelection.position = tile_pos
    var grid_pos = Vector2i(tile_pos / 128.0)
    if all_components.has(grid_pos):
        var target = all_components[grid_pos]
        DebugDraw2D.set_text("Component", target.connections)
        DebugDraw2D.set_text("Connections", target.connections.values().map(func(c): return c.connected_to))
        DebugDraw2D.set_text("Speeds", target.connections.values().map(func(c): return c.speed))
    DebugDraw2D.set_text("Position", grid_pos)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        var grid_pos = Vector2i($CursorSelection.position / 128.0) 
        if event.button_index == MOUSE_BUTTON_LEFT:
            if all_components.has(grid_pos):
                all_components[grid_pos].queue_free()
                
            var new_component: MechanicalComponent = selected_component.instantiate()
            #var new_component = %Preview.get_child(0).duplicate()
            $Components.add_child(new_component)
            new_component.position = $CursorSelection.position
            new_component.rotation = HALF_PI * (rotation_index % new_component.max_rotations)
            new_component.rotation_index = (rotation_index % new_component.max_rotations) as MechanicalComponent.Dir
            
            all_components[grid_pos] = new_component
            #_on_refresh_pressed()
            new_component.connect_neighbors(grid_pos, all_components)
        elif event.button_index == MOUSE_BUTTON_RIGHT:
            remove_at(grid_pos)
                
    elif event.is_action_pressed(&"rotate"):
        rotation_index = (rotation_index + 1) % 4
        #%Preview.getchi
        %Preview.rotation = HALF_PI * rotation_index

func remove_at(pos: Vector2i):
    if all_components.has(pos):
        var target = all_components[pos]
        target.queue_free()
        all_components.erase(pos)
        _on_refresh_pressed()
        
#func connect_neighbors(new_component_pos: Vector2i):
    #var new_component = all_components[new_component_pos]
    #print(new_component.connections)
    #for test_dir in new_component.connections:
        #var connector: MechanicalConnector = new_component.connections[test_dir]
        #var offset = MechanicalComponent.DIR_MAPPINGS[test_dir]
        #var test_pos = new_component_pos + offset
        #if all_components.has(test_pos):
            #var neighbor = all_components[test_pos]
            #var opposite_dir = (test_dir + 2) % 4
            #if neighbor.connections.has(opposite_dir):
                #var neighbor_connector: MechanicalConnector = neighbor.connections[opposite_dir]
                #connector.connected_to = neighbor_connector
                #neighbor_connector.connected_to = connector
                #neighbor_connector.sprites.frame = connector.sprites.frame
        


func _on_sidebar_item_selected(scene: PackedScene) -> void:
    selected_component = scene
    #rot
    for c in %Preview.get_children():
        c.queue_free()
    var new_preview = scene.instantiate()
    %Preview.add_child(new_preview)


func _on_refresh_pressed() -> void:
    for pos in all_components:
        var target = all_components[pos]
        for dir in target.connections:
            var conn: MechanicalConnector = target.connections[dir]
            conn.connected_to = null
            conn.speed = 0.0
            #conn.sprites.frame = 0
            
    await get_tree().physics_frame
    for pos in all_components:
        var target = all_components[pos]
        target.connect_neighbors(pos, all_components)
