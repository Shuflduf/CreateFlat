extends MechanicalComponent

func _physics_process(_delta: float) -> void:
    $Shaft.stress_units = 1000000.0
    $Shaft.speed = 1.0
    
    if neighbors[Dir.Up]:
        transfer_rotation(neighbors[Dir.Up])

func transfer_rotation(component: MechanicalComponent):
    component.accept_rotation(10000.0, 1.0)
