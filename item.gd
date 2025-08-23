class_name Item
extends CharacterBody2D

@onready var default_collision = collision_layer

var is_ready = false
var flying = false
var fly_destination: Vector2

func _physics_process(delta: float) -> void:
    velocity.y += get_gravity().y * delta
    move_and_slide()
    if flying:
        if fly_destination.distance_squared_to(position) > 4096.0:
            collision_layer = 0
        else:
            flying = false
            collision_layer = default_collision


func temp_disable():
    collision_layer = 0
    await get_tree().create_timer(0.5).timeout
    collision_layer = default_collision
