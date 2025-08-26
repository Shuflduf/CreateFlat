extends ItemTransport

var speed = 0.0:
    set(value):
        speed = value
        $GearPart.speed_scale = -abs(speed)


func _ready() -> void:
    super()
    $Connector.rotated.connect(func(): speed = $Connector.speed)
