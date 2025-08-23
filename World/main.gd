extends Node2D

const TILE_SIZE = 128.0
const HALF_TILE = TILE_SIZE / 2.0
const HALF_PI = 1.5708

@export var selected_component: PackedScene

var rotation_index = 0

@onready var all_components: Dictionary[Vector2i, MechanicalComponent] = {
    Vector2i(0, 0): $Components/Motor
}


func _physics_process(_delta: float) -> void:
    DebugDraw2D.set_text("FPS", Engine.get_frames_per_second())
    var mouse_pos = get_global_mouse_position() - Vector2(HALF_TILE, HALF_TILE)
    var tile_pos = mouse_pos.snapped(Vector2(TILE_SIZE, TILE_SIZE))
    $CursorSelection.position = tile_pos
    var grid_pos = Vector2i(tile_pos / 128.0)
    if all_components.has(grid_pos):
        var target = all_components[grid_pos]
        DebugDraw2D.set_text("Component", target.connections)
        DebugDraw2D.set_text(
            "Connections",
            target.connections.values().map(func(c): return c.connected_to)
        )
        DebugDraw2D.set_text(
            "Speeds", target.connections.values().map(func(c): return c.speed)
        )
    DebugDraw2D.set_text("Position", grid_pos)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        var grid_pos = Vector2i($CursorSelection.position / 128.0)
        if event.button_index == MOUSE_BUTTON_LEFT:
            if all_components.has(grid_pos):
                remove_at(grid_pos)

            var new_component: MechanicalComponent = (
                selected_component.instantiate()
            )
            $Components.add_child(new_component)
            new_component.position = $CursorSelection.position
            new_component.rotation = (
                HALF_PI * (rotation_index % new_component.max_rotations)
            )
            new_component.rotation_index = (
                rotation_index % new_component.max_rotations
            )

            all_components[grid_pos] = new_component
            new_component.connect_neighbors(grid_pos, all_components)

        elif event.button_index == MOUSE_BUTTON_RIGHT:
            remove_at(grid_pos)
            # fuck if i know
            await get_tree().physics_frame
            await get_tree().physics_frame
            _on_refresh_pressed()

    elif event.is_action_pressed(&"rotate"):
        rotation_index = (rotation_index + 1) % 4
        %Preview.rotation = HALF_PI * rotation_index


func remove_at(pos: Vector2i):
    if all_components.has(pos):
        all_components[pos].disconnect_neighbors(pos, all_components)
        all_components[pos].queue_free()
        all_components.erase(pos)


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
        #target.disconnect_neighbors(pos, all_components)
        for dir in target.connections:
            var conn: MechanicalConnector = target.connections[dir]
            conn.speed = 0.0
            conn.transfer_rotation()
            #conn.sprites.frame = 0
            conn.connected_to = null

    #await get_tree().physics_frame
    for pos in all_components:
        var target = all_components[pos]
        target.connect_neighbors(pos, all_components)
