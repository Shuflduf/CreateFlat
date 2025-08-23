class_name Item
extends CharacterBody2D

var is_ready = false

func _physics_process(delta: float) -> void:
    velocity.y += get_gravity().y * delta
    move_and_slide()


func temp_disable():
    var current_col = collision_layer
    collision_layer = 0
    await get_tree().create_timer(0.5).timeout
    collision_layer = current_col
