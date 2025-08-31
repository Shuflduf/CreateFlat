extends ItemTransport


func _ready() -> void:
    super()
    $Area.body_entered.connect(_on_area_item_entered)


func _physics_process(delta: float) -> void:
    if held_items.size() > 0:
        var main_item = held_items[0]
        var distance_to_center = main_item.global_position.x - global_position.x
        var centered = abs(distance_to_center) < 1.0

        if (not centered) or (press and items_processed <= 0):
            main_item.velocity.y = 0.0
            main_item.velocity.x = 0
            main_item.global_position.x = lerp(
                main_item.global_position.x, global_position.x, delta * 5.0
            )
            main_item.position.y = global_position.y - 80.0

        if press and items_processed <= 0:
            press.start_press()

        if (press and items_processed > 0) or (not press and centered):
            main_item.temp_disable(0.6)
            held_items.pop_front()
            if items_processed > 0:
                items_processed -= 1

    super(delta)
