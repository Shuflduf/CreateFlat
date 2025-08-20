class_name MechanicalComponent
extends Node2D

enum Dir {
    Up,
    Down,
    Left,
    Right,
}
const DIR_MAPPINGS: Dictionary[Dir, Vector2i] = {
    Dir.Up: Vector2i(0, -1),
    Dir.Down: Vector2i(0, 1),
    Dir.Left: Vector2i(-1, 0),
    Dir.Right: Vector2i(1, 0),
}
const OPPOSITE_DIRS: Dictionary[Dir, Dir] = {
    Dir.Up: Dir.Down,
    Dir.Down: Dir.Up,
    Dir.Left: Dir.Right,
    Dir.Right: Dir.Left,
}

@export var connections: Dictionary[Dir, MechanicalConnector] = {}

#func force_update():
    #return

func accept_rotation(_su: float, _new_speed: float):
    return
