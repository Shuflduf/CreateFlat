class_name MechanicalComponent
extends Node2D

enum Dir {
    UP,
    RIGHT,
    DOWN,
    LEFT,
}
const DIR_MAPPINGS: Dictionary[Dir, Vector2i] = {
    Dir.UP: Vector2i(0, -1),
    Dir.RIGHT: Vector2i(1, 0),
    Dir.DOWN: Vector2i(0, 1),
    Dir.LEFT: Vector2i(-1, 0),
}
#const OPPOSITE_DIRS: Dictionary[Dir, Dir] = {
#Dir.Up: Dir.Down,
#Dir.Right: Dir.Left,
#Dir.Down: Dir.Up,
#Dir.Left: Dir.Right,
#}

@export var connections: Dictionary[Dir, MechanicalConnector] = {}
@export var flipped_dirs: Array[Dir]
@export var max_rotations = 4
#func force_update():
#return

var rotation_index = 0


func _ready() -> void:
    await get_tree().physics_frame
    for dir in connections:
        connections[dir].global_dir = (dir + rotation_index) % 4 as Dir
        connections[dir].parent = self


func _post_update_neighbors(
    _component_pos: Vector2i,
    _all_components: Dictionary[Vector2i, MechanicalComponent]
):
    return


func connect_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    for test_dir in connections:
        var connector: MechanicalConnector = connections[test_dir]
        var offset = MechanicalComponent.DIR_MAPPINGS[
            (test_dir + rotation_index) % 4
        ]
        var test_pos = component_pos + offset
        if all_components.has(test_pos):
            var neighbor = all_components[test_pos]
            var opposite_dir = (
                (test_dir + rotation_index + 2 - neighbor.rotation_index) % 4
            )
            if neighbor.connections.has(opposite_dir):
                var neighbor_connector: MechanicalConnector = (
                    neighbor.connections[opposite_dir]
                )
                var random_hue = randf()
                connector.debug.modulate.h = random_hue
                connector.connected_to = neighbor_connector
                neighbor_connector.connected_to = connector
                neighbor_connector.debug.modulate.h = random_hue
                neighbor_connector.sprites.frame = connector.sprites.frame
    _post_update_neighbors(component_pos, all_components)


func disconnect_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    var target = all_components[component_pos]
    for dir in target.connections:
        var conn: MechanicalConnector = target.connections[dir]
        if conn.connected_to:
            print(conn.connected_to)
            conn.connected_to.connected_to = null
            conn.connected_to.speed = 0.0
            conn.connected_to.rotated.emit()
