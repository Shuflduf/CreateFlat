class_name Item
extends CharacterBody2D

const CATCH_RADIUS = 64.0
const CATCH_RADIUS_SQUARED = CATCH_RADIUS * CATCH_RADIUS
const BASE_Z_INDEX = 1

var flying = false
var fly_destination: Vector2
var data: ItemData
var temp_disabled = false

@onready var default_collision = collision_layer


func _ready() -> void:
    z_index = BASE_Z_INDEX
    collision_layer = 0
    await get_tree().physics_frame
    await get_tree().physics_frame
    if not temp_disabled:
        collision_layer = default_collision


func _physics_process(delta: float) -> void:
    modulate.v = remap(collision_layer, 0, 1, 0.5, 1.0)
    velocity.y += get_gravity().y * delta
    move_and_slide()
    if flying:
        if fly_destination.distance_squared_to(position) > CATCH_RADIUS_SQUARED:
            collision_layer = 0
        else:
            flying = false
            collision_layer = default_collision

    if position.y > MoreConsts.MAP_SIZE * 128.0:
        queue_free()


func temp_disable(time: float = 0.5):
    temp_disabled = true
    collision_layer = 0
    await get_tree().create_timer(time).timeout
    collision_layer = default_collision
    temp_disabled = false


static func from_id(id: String) -> Item:
    var new_item = preload("res://Items/item.tscn").instantiate()
    new_item.data = RecipeSystem.all_item_data.filter(func(i: ItemData): return i.id == id)[0]
    new_item.update_sprite()
    RecipeSystem.add_child(new_item)
    return new_item


func update_sprite():
    $Sprite.texture = data.texture
