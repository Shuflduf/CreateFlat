@tool
extends Node2D

enum BeltType {
    Start,
    Full,
    End,
}
@export var type: BeltType = BeltType.Start
@export_tool_button("Update") var update_type_action = update_type

@onready var section_mappings = {
    BeltType.Start: [%BottomStart, %SideStart, %TopStart],
    BeltType.Full: [%BottomFull, %TopFull],
    BeltType.End: [%BottomEnd, %SideEnd, %TopEnd],
}

func _ready() -> void:
    update_type()

func update_type():
    for c in $Parts.get_children():
        c.hide()
    for p in section_mappings[type]:
        p.show()
    #var mat: ShaderMaterial = material
    #mat.set_shader_parameter(&"top_shown", top_shown)
    #mat.set_shader_parameter(&"bottom_shown", bottom_shown)
