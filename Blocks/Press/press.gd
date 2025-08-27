class_name MechanicalPress
extends MechanicalComponent

var running = false
var target_transport: ItemTransport
var speed = 0.0:
    set(value):
        speed = value
        $Anim.speed_scale = abs(speed)


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


func press_recipe() -> ItemRecipe:
    var recipe = RecipeSystem.find_recipe(
        RecipeSystem.RecipeType.PRESSING,
        [target_transport.held_items[0].data.id]
    )
    return recipe


func _press_item():
    var recipe = press_recipe()
    if recipe != null:
        var new_item_pos = target_transport.held_items[0].position
        target_transport.follow_recipe(
            recipe,
            func(item: Item):
                item.position = new_item_pos
                item.z_index = -1
                target_transport.held_items.push_front(item)
                target_transport.items_processed += 1
        )


func start_press():
    var recipe = press_recipe()
    if recipe != null and speed != 0.0:
        running = true
        $Anim.play(&"press")
    elif recipe == null:
        target_transport.items_processed += 1


func pack_recipe() -> ItemRecipe:
    var ids: Array[String]
    target_transport.held_items.map(func(i: Item): ids.append(i.data.id))
    var recipe = RecipeSystem.find_recipe(RecipeSystem.RecipeType.PACKING, ids)
    return recipe


func _pack_items():
    var recipe = pack_recipe()
    if recipe != null:
        target_transport.follow_recipe(
            recipe,
            func(item: Item):
                item.position = target_transport.position
                item.position += Vector2(64.0, 96.0)
        )


func start_pack():
    if not running and speed != 0 and pack_recipe() != null:
        running = true
        $Anim.play(&"press_basin")


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name != &"reset":
        running = false


func _post_disconnect_neighbors(
    _component_pos: Vector2i,
    _all_components: Dictionary[Vector2i, MechanicalComponent]
):
    target_transport.press = null
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
            target_transport = target
            target.press = self
            #finished.connect(func(): target.item_processed = true)
