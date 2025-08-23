@tool
extends Node2D

enum BeltType {
    START,
    FULL,
    END,
}

@export var type: BeltType = BeltType.START
@export_tool_button("Update") var update_type_action = update_type

@onready var section_mappings = {
    BeltType.START: [%BottomFull, %TopFull, %SideStart],
    BeltType.FULL: [%BottomFull, %TopFull],
    BeltType.END: [%BottomFull, %TopFull, %SideEnd],
}


func _ready() -> void:
    update_type()


func update_type():
    for c in $Parts.get_children():
        c.hide()

    #var mat: ShaderMaterial = material
    #mat.set_shader_parameter(&"top_shown", top_shown)
    #mat.set_shader_parameter(&"bottom_shown", bottom_shown)
    for p in section_mappings[type]:
        p.show()
#var mat: ShaderMaterial = material
#mat.set_shader_parameter(&"top_shown", top_shown)
#mat.set_shader_parameter(&"bottom_shown", bottom_shown)
