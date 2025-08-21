class_name Shaft
extends MechanicalComponent

func _ready() -> void:
    super()
    $Bottom.rotated.connect(func():
        $Top.speed = $Bottom.speed
        $Top.transfer_rotation()
    )
    $Top.rotated.connect(func():
        $Bottom.speed = $Top.speed
        $Bottom.transfer_rotation()
    )
