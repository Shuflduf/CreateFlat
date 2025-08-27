class_name MechanicalPress
extends MechanicalComponent

var running = false
var target_transport: ItemTransport
# var target_items: Array[Item]
# var process_targets: Array[Item]
var speed = 0.0:
    set(value):
        speed = value
        $Anim.speed_scale = abs(speed)


func start_compact(items: Array[Item]) -> Array[Item]:
    const COMPACT_THRESHOLD = 9
    if not running and speed != 0 and items.size() >= COMPACT_THRESHOLD:
        $Anim.play(&"press_basin")

    return items


# func _physics_process(_delta: float) -> void:
#debug_data = process_targets
# if target_transport:
#     for item in process_targets:
#         item.global_position = target_transport.global_position
#         item.velocity.y = 0.0


# func start_press():
#     if not running and speed != 0.0:
#         running = true
#         $Anim.play(&"press")


func _ready() -> void:
    super()
    $Right.rotated.connect(
        func():
            speed = $Right.speed
            $Left.speed = -$Right.speed
            $Left.transfer_rotation()
    )
    $Left.rotated.connect(
        func():
            speed = $Left.speed
            $Right.speed = -$Left.speed
            $Right.transfer_rotation()
    )


func _press_item():
    var recipe = RecipeSystem.find_recipe(
        RecipeSystem.RecipeType.PRESSING, [target_transport.held_items[0].data.id]
    )
    if recipe != null:
        for result in recipe.results:
            var amount = recipe.results[result]
            for i in amount:
                var new_item = Item.from_id(result)
                new_item.position.x = target_transport.held_items[0].position.x
                new_item.z_index = -1
                new_item.modulate.s = 1.0
                new_item.modulate.h = (i * 0.2)
                target_transport.held_items.append(new_item)
                target_transport.items_processed += 1
        target_transport.held_items[0].queue_free()
        target_transport.held_items.pop_front()
        print(target_transport.held_items)
        print(target_transport.items_processed)
        # var new_items = recipe.results.


func start_press():
    var recipe = RecipeSystem.find_recipe(RecipeSystem.RecipeType.PRESSING, [target_transport.held_items[0].data.id])
    if recipe != null:
        running = true
        $Anim.play(&"press")
    # else:
    #     target_transport.item_processed = true


func _pack_items():
    var ids: Array[String]
    target_transport.held_items.map(func(i: Item): ids.append(i.data.id))
    var recipe = RecipeSystem.find_recipe(RecipeSystem.RecipeType.PACKING, ids)
    if recipe != null:
        for result in recipe.results:
            # var amount = recipe.results[ingredient]
            var new_item = Item.from_id(result)
            new_item.position = target_transport.position
            new_item.position += Vector2(64.0, 96.0)
            new_item.z_index = -1
        # target_transport.held_item.queue_free()
        # target_transport.held_item = last_item


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name != &"reset":
        running = false

    # if anim_name == &"press":
    #     if target_transport:
    #         target_transport.item_processed = true
    # elif anim_name == &"press_basin":
    #     if target_transport:
    #         # for item in process_targets:
    #         #     item.queue_free()
    #         # process_targets = []
    #         var new_item = Item.from_id("iron_block")
    #         new_item.position = target_transport.position
    #         new_item.position += Vector2(64.0, 64.0)
    #         new_item.position.y += 32.0
    #         #await get_tree().physics_frame
    #
    #         #new_item.temp_disable(0.01)
    #         print(new_item.global_position)
    #         #target_transport.
    #


func _post_disconnect_neighbors(
    _component_pos: Vector2i,
    _all_components: Dictionary[Vector2i, MechanicalComponent]
):
    target_transport = null


func _post_update_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    # this code is too fucking similar to item_transport.gd
    var transport_target_pos = component_pos + Vector2i(0, 2)
    if all_components.has(transport_target_pos):
        var target = all_components[transport_target_pos]
        if target is ItemTransport:
            print("PRES but from press")
            target_transport = target
            target.press = self
            #finished.connect(func(): target.item_processed = true)
