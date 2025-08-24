class_name MechanicalPress
extends MechanicalComponent

signal finished

var running = false

func start(item: Item):
    if not running:
        running = true
        print(item)
        $Anim.play(&"press")


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name == &"press":
        finished.emit()
        running = false

func _post_update_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    super(component_pos, all_components)
        
    var transport_target_pos = component_pos + Vector2i(0, 2)
    if all_components.has(transport_target_pos):
        var target = all_components[transport_target_pos]
        if target is ItemTransport:
            #print("PRES")
            target.press = self
            finished.connect(func():
                target.item_processed = true
            )
