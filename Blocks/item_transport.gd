class_name ItemTransport
extends MechanicalComponent

var left_connection: ItemTransport
var right_connection: ItemTransport

var held_items: Array[Item]
var items_processed = 0

var press: MechanicalPress
var mixer: MechanicalMixer


func _physics_process(_delta: float) -> void:
    stack_queue()
    debug_data = items_processed


func follow_recipe(recipe: ItemRecipe, each_item: Callable):
    var ingredients_needed = recipe.ingredients.duplicate()
    var items_to_remove = []
    for item in held_items:
        if (
            ingredients_needed.has(item.data.id)
            and ingredients_needed[item.data.id] > 0
        ):
            ingredients_needed[item.data.id] -= 1
            items_to_remove.append(item)
    for item in items_to_remove:
        held_items.erase(item)
        item.queue_free()

    var new_items: Array[Item]
    for result in recipe.results:
        var amount = recipe.results[result]
        for i in amount:
            var new_item = Item.from_id(result)
            new_item.position = position
            # new_item.temp_disable(0.1)
            each_item.call(new_item)

    return new_items


func stack_queue():
    for i in held_items.size():
        if i == 0:
            continue
        var item = held_items[i]
        if item == null:
            held_items.remove_at(i)
            continue
        item.velocity.y = 0.0
        item.velocity.x = 0.0
        item.global_position.y = global_position.y - 92.0 - (32.0 * i)


func can_accept_item() -> bool:
    return held_items.size() <= 0


func _on_area_item_entered(body: Node2D) -> void:
    if body is Item and active:
        held_items.append(body)
        #body.flying = false
        #body.collision_layer = 0
        # if held_item:
        #     body.global_position.x = (
        #         global_position.x + randf_range(-16.0, 16.0)
        #     )
        #     queue.append(body)
        # else:
        #     held_item = body


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
            press = target
            press.target_transport = self
        elif target is MechanicalMixer:
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

    # press = null
    # mixer = null
