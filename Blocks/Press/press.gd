class_name MechanicalPress
extends MechanicalComponent

var running = false
var target_transport: ItemTransport
var target_item: Item

func start(item: Item):
    if not running:
        target_item = item
        running = true
        item.z_index = -1
        print(item)
        $Anim.play(&"press")


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name == &"press":
        running = false
        target_item.z_index = 0
        if target_transport:
            target_transport.item_processed = true


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
            target_transport = target
            target.press = self
            #finished.connect(func(): target.item_processed = true)
