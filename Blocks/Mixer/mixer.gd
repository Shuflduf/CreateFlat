class_name MechanicalMixer
extends MechanicalComponent

var running = false
var target_transport: ItemTransport
var target_items: Array[Item]
var speed = 0.0:
    set(value):
        speed = value
        $Anim.speed_scale = abs(speed)


func mix_recipe() -> ItemRecipe:
    var ids: Array[String]
    target_transport.held_items.map(func(i: Item): ids.append(i.data.id))
    var recipe = RecipeSystem.find_recipe(RecipeSystem.RecipeType.MIXING, ids)
    return recipe


func start_mix():
    if not running and speed != 0 and mix_recipe() != null:
        $Anim.play(&"mix")
        running = true


func _mix_items():
    var recipe = mix_recipe()
    if recipe != null:
        target_transport.follow_recipe(
            recipe,
            func(item: Item):
                item.position += Vector2(64.0, 64.0)
                item.position.y += 32.0
        )


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


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name != &"reset":
        running = false


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
            print("MIX but from press")
            target_transport = target
            target.mixer = self
            #finished.connect(func(): target.item_processed = true)
