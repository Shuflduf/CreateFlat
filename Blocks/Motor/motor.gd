extends MechanicalComponent


func _physics_process(_delta: float) -> void:
    var conn = connections[Dir.UP]
    if conn.global_dir in flipped_dirs:
        $Connector.shaft_bottom = true
        $Connector.rotation = PI
    else:
        $Connector.shaft_bottom = false
        $Connector.rotation = 0.0
    conn.speed = 1.0    
    conn.transfer_rotation()

#$Shaft.stress_units = 1000000.0
#$Shaft.speed = 1.0
#
#if neighbors[Dir.Up]:
#transfer_rotation(neighbors[Dir.Up])

#func transfer_rotation(component: MechanicalComponent):
#component.accept_rotation(10000.0, 1.0)
