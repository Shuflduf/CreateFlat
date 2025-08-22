class_name Shaft
extends MechanicalComponent

func _ready() -> void:
    super()
    $Bottom.rotated.connect(func():
        $Top.speed = $Bottom.speed
        #$Top.sprites.frame = $Bottom.sprites.frame
        $Top.transfer_rotation()
    )
    $Top.rotated.connect(func():
        $Bottom.speed = $Top.speed
        #$Bottom.sprites.frame = $Top.sprites.frame
        $Bottom.transfer_rotation()
    )
