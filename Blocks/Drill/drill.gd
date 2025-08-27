extends MechanicalComponent

var top_hidden = false
var speed = 0.0:
    set(value):
        speed = value
        $DrillPart.speed_scale = abs(speed)
var target_source: ItemSource

func _physics_process(_delta: float) -> void:
    if not active:
        return
    $BreakParticles.emitting = target_source != null and speed != 0.0


func _ready():
    super()
    await get_tree().physics_frame
    if not active:
        return
    await get_tree().physics_frame

    $Connector.rotated.connect(func(): speed = $Connector.speed)
    if $Area.has_overlapping_areas():
        target_source = $Area.get_overlapping_areas()[0].get_parent()
        print(target_source.item_data.name)

    update_visuals()

func update_visuals():
    $DrillPart.material.set_shader_parameter(&"clipped", target_source != null)
    if target_source:
        $BreakParticles.texture = target_source.item_data.texture
