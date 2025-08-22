class_name MechanicalComponent
extends Node2D

enum Dir {
    Up,
    Right,
    Down,
    Left,
}
const DIR_MAPPINGS: Dictionary[Dir, Vector2i] = {
    Dir.Up: Vector2i(0, -1),
    Dir.Right: Vector2i(1, 0),
    Dir.Down: Vector2i(0, 1),
    Dir.Left: Vector2i(-1, 0),
}
#const OPPOSITE_DIRS: Dictionary[Dir, Dir] = {
    #Dir.Up: Dir.Down,
    #Dir.Right: Dir.Left,
    #Dir.Down: Dir.Up,
    #Dir.Left: Dir.Right,
#}

@export var connections: Dictionary[Dir, MechanicalConnector] = {}
@export var max_rotations = 4
#func force_update():
    #return

var rotation_index = 0

func _ready() -> void:
    await get_tree().physics_frame
    for dir in connections:
        connections[dir].facing_dir = dir
        connections[dir].parent = self

func connect_neighbors(new_component_pos: Vector2i, all_components: Dictionary[Vector2i, MechanicalComponent]):
    for test_dir in connections:
        var connector: MechanicalConnector = connections[test_dir]
        var offset = MechanicalComponent.DIR_MAPPINGS[(test_dir + rotation_index) % 4]
        var test_pos = new_component_pos + offset
        if all_components.has(test_pos):
            var neighbor = all_components[test_pos]
            var opposite_dir = (test_dir + 2 + neighbor.rotation_index + rotation_index) % 4
            if neighbor.connections.has(opposite_dir):
                var neighbor_connector: MechanicalConnector = neighbor.connections[opposite_dir]
                connector.connected_to = neighbor_connector
                neighbor_connector.connected_to = connector
                neighbor_connector.sprites.frame = connector.sprites.frame
