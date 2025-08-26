class_name MechanicalMixer
extends MechanicalComponent

var running = false
var target_transport: ItemTransport
var target_items: Array[Item]
var process_targets: Array[Item]
var speed = 0.0:
    set(value):
        speed = value
        $Anim.speed_scale = abs(speed)


func start_mix(items: Array[Item]) -> Array[Item]:
    const MIX_THRESHOLD = 2
    if not running and speed != 0 and items.size() >= MIX_THRESHOLD:
        process_targets = []
        for i in MIX_THRESHOLD:
            process_targets.append(items.pop_front())
        running = true
        print(process_targets)
        $Anim.play(&"mix")

    return items


func _physics_process(_delta: float) -> void:
    #debug_data = process_targets
    if target_transport:
        for item in process_targets:
            item.global_position = target_transport.global_position
            item.velocity.y = 0.0


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

    if anim_name == &"mix" and target_transport:
        for item in process_targets:
            item.queue_free()
        process_targets = []
        var new_item = Item.from_id("")
        new_item.position = target_transport.position
        new_item.position += Vector2(64.0, 64.0)
        new_item.position.y += 32.0
        get_parent().add_child(new_item)
        #await get_tree().physics_frame

        #new_item.temp_disable(0.01)
        print(new_item.global_position)
        #target_transport.


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
