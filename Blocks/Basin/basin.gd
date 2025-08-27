class_name Basin
extends ItemTransport


func _physics_process(_delta: float) -> void:
    if held_items.size() > 0:
        if press:
            press.start_pack()
        elif mixer:
            mixer.start_mix()

    for item in held_items:
        item.global_position = global_position
        item.velocity = Vector2.ZERO

    debug_data = held_items.size()


func _ready() -> void:
    super()
    # wow i dont have to wait two whole physics frames
    await get_tree().physics_frame
    if active:
        z_index = 10


func _on_area_body_entered(body: Node2D) -> void:
    if body is Item and active:
        held_items.append(body)


func _post_update_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    super(component_pos, all_components)
    #var mixer_target_pos = component_pos - Vector2i(0, 2)
    #if all_components.has(mixer_target_pos):
    #var target = all_components[mixer_target_pos]
    #if target is MechanicalMixer:
    #print("PRES")
    #press = target
    #press.target_transport = self
