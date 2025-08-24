extends ItemTransport


func _ready() -> void:
    super()
    $Area.body_entered.connect(_on_area_item_entered)


func _physics_process(delta: float) -> void:
    if held_item:
        var distance_to_center = held_item.global_position.x - global_position.x
        var centered = abs(distance_to_center) < 1.0
        
        if (not centered) or (press and not item_processed):
            held_item.velocity.y = 0.0
            held_item.velocity.x = 0
            held_item.global_position.x = lerp(
                held_item.global_position.x, global_position.x, delta * 5.0
            )
            held_item.position.y = global_position.y - 80.0
            
        if press and not item_processed:
            press.start(held_item)
        
        if (press and item_processed) or (not press):
            held_item.temp_disable()
            held_item = null
            item_processed = false

    super(delta)
