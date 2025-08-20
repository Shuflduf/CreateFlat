class_name Shaft
extends MechanicalComponent

func _ready() -> void:
    $Bottom.connected_to = $Top
