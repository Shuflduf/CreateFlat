class_name ItemTransport
extends MechanicalComponent

var left_connection: ItemTransport
var right_connection: ItemTransport

var held_item: Item
var queue: Array[Item]
var item_processed = false

var press: MechanicalPress
var mixer: MechanicalMixer


func _physics_process(_delta: float) -> void:
    if not held_item and queue.size() >= 1:
        held_item = queue.pop_front()
        held_item.global_position.x = global_position.x

    for i in queue.size():
        var item = queue[i]
        item.velocity.y = 0.0
        item.velocity.x = 0.0
        item.global_position.y = global_position.y - 92.0 - (32.0 * i)


func _on_area_item_entered(body: Node2D) -> void:
    if body is Item and active and body != held_item and body.is_ready:
        #body.flying = false
        #body.collision_layer = 0
        if held_item:
            body.global_position.x = (
                global_position.x + randf_range(-16.0, 16.0)
            )
            queue.append(body)
        else:
            held_item = body


func _post_update_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    for dir in [Dir.LEFT, Dir.RIGHT]:
        var test_pos = component_pos + DIR_MAPPINGS[dir]
        if all_components.has(test_pos):
            var target = all_components[test_pos]
            if target is ItemTransport:
                if dir == Dir.LEFT:
                    left_connection = target
                    target.right_connection = self
                elif dir == Dir.RIGHT:
                    right_connection = target
                    target.left_connection = self

    var press_target_pos = component_pos - Vector2i(0, 2)
    if all_components.has(press_target_pos):
        var target = all_components[press_target_pos]
        if target is MechanicalPress:
            print("PRES but from transport")
            press = target
            press.target_transport = self
        elif target is MechanicalMixer:
            print("MIX from transport")
            mixer = target
            mixer.target_transport = self


func _post_disconnect_neighbors(
    _component_pos: Vector2i,
    _all_components: Dictionary[Vector2i, MechanicalComponent]
):
    if left_connection:
        left_connection.right_connection = null
    if right_connection:
        right_connection.left_connection = null
