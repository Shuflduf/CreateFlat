@tool
class_name Shaft
extends AnimatedSprite2D

@export var top_shown = true
@export var bottom_shown = true
@export_tool_button("Update") var update_halves_action = update_halves

func update_halves():
    var mat: ShaderMaterial = material
    mat.set_shader_parameter(&"top_shown", top_shown)
    mat.set_shader_parameter(&"bottom_shown", bottom_shown)
