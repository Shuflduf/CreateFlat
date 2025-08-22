class_name Shaft
extends MechanicalComponent


func _ready() -> void:
    super()
    #$Bottom.sprites.material.set_shader_parameter(&"bottom_shown", true)
    #$Bottom.sprites.material.set_shader_parameter(&"top_shown", false)
    $Bottom.rotated.connect(
        func():
            $Top.speed = -$Bottom.speed
            #$Top.flipped = $Bottom.flipped
            $Top.sprites.frame = $Bottom.sprites.frame
            $Top.transfer_rotation()
            #$Bottom.flipped = $Top.flipped
            #$Bottom.sprites.frame = $Top.sprites.frame
    )
    $Top.rotated.connect(
        func():
            $Bottom.speed = -$Top.speed
            #$Bottom.flipped = $Top.flipped
            $Bottom.sprites.frame = $Top.sprites.frame
            $Bottom.transfer_rotation()
    )
