class_name Item
extends CharacterBody2D

const CATCH_RADIUS = 64.0
const CATCH_RADIUS_SQUARED = CATCH_RADIUS * CATCH_RADIUS
const BASE_Z_INDEX = 1

var is_ready = false
var flying = false
var fly_destination: Vector2
var data: ItemData

@onready var default_collision = collision_layer


func _ready() -> void:
    z_index = BASE_Z_INDEX
    await get_tree().physics_frame
    await get_tree().physics_frame
    is_ready = true


func _physics_process(delta: float) -> void:
    velocity.y += get_gravity().y * delta
    move_and_slide()
    if flying:
        if fly_destination.distance_squared_to(position) > CATCH_RADIUS_SQUARED:
            collision_layer = 0
        else:
            flying = false
            collision_layer = default_collision


func temp_disable(time: float = 0.5):
    collision_layer = 0
    await get_tree().create_timer(time).timeout
    collision_layer = default_collision


static func from_id(id: String) -> Item:
    var new_item = preload("res://Items/item.tscn").instantiate()
    new_item.data = RecipeSystem.all_item_data.filter(func(i: ItemData): return i.id == id)[0]
    new_item.update_sprite()
    RecipeSystem.add_child(new_item)
    return new_item


func update_sprite():
    $Sprite.texture = data.texture
