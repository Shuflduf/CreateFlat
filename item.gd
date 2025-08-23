class_name Item
extends CharacterBody2D

const CATCH_RADIUS = 64.0
const CATCH_RADIUS_SQUARED = CATCH_RADIUS * CATCH_RADIUS

@onready var default_collision = collision_layer

var is_ready = false
var flying = false
var fly_destination: Vector2

func _physics_process(delta: float) -> void:
    velocity.y += get_gravity().y * delta
    move_and_slide()
    if flying:
        if fly_destination.distance_squared_to(position) > CATCH_RADIUS_SQUARED:
            collision_layer = 0
        else:
            flying = false
            collision_layer = default_collision


func temp_disable():
    collision_layer = 0
    await get_tree().create_timer(0.5).timeout
    collision_layer = default_collision
