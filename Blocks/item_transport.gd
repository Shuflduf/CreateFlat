class_name ItemTransport
extends MechanicalComponent

var left_connection: ItemTransport
var right_connection: ItemTransport

var held_item: Item
var queue: Array[Item]

func _physics_process(_delta: float) -> void:
    if not held_item and queue.size() >= 1:
        held_item = queue.pop_front()

    for i in queue.size():
        var item = queue[i]
        item.velocity.y = 0.0
        item.velocity.x = 0.0
        item.global_position.y = global_position.y - 92.0 - (32.0 * i)


func _on_area_item_entered(body: Node2D) -> void:
    if body is Item and active and body != held_item:
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
                print(target)
                var is_belt = target is Belt
                if dir == Dir.LEFT:
                    left_connection = target
                    target.right_connection = self
                elif dir == Dir.RIGHT:
                    right_connection = target
                    target.left_connection = self

                #if is_belt:
                    #update_visuals()
                    #target.update_visuals()

func _post_disconnect_neighbors(
    _component_pos: Vector2i,
    _all_components: Dictionary[Vector2i, MechanicalComponent]
):
    if left_connection:
        left_connection.right_connection = null
        left_connection.update_visuals()
    if right_connection:
        right_connection.left_connection = null
        right_connection.update_visuals()
