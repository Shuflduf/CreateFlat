@tool
class_name Shaft
extends MechanicalComponent

@export var top_shown = true
@export var bottom_shown = true
@export_tool_button("Update") var update_halves_action = update_halves

var stress_units = 0.0
var speed = 0.0:
    set(val):
        speed = val
        $Sprites.speed_scale = val

func restart():
    $Sprites.frame = 0

func _ready() -> void:
    update_halves()

func update_halves():
    var mat: ShaderMaterial = $Sprites.material
    mat.set_shader_parameter(&"top_shown", top_shown)
    mat.set_shader_parameter(&"bottom_shown", bottom_shown)

func accept_rotation(su: float, new_speed: float):
    stress_units = su
    speed = new_speed

func _physics_process(_delta: float) -> void:
    if neighbors[Dir.Up]:
        transfer_rotation(neighbors[Dir.Up])

func transfer_rotation(component: MechanicalComponent):
    component.accept_rotation(stress_units, speed)
