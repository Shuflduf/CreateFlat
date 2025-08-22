extends MechanicalComponent

@onready var connectors = [
    $Up,
    $Right,
    $Down,
    $Left,
]

func _ready() -> void:
    super()
    for conn in connectors:
        conn.rotated.connect(_on_dir_rotated.bind(conn))


func _on_dir_rotated(connector: MechanicalConnector):
    
    for i in connectors.size():
        var current = connectors[i]
        if current == connector:
            continue
        current.speed = connector.speed if (i + connector.facing_dir) % 2 == 0 else -connector.speed
        current.transfer_rotation()
    #connector.speed = -connector.speed
        
    #pass
