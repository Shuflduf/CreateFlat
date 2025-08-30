extends ItemTransport

var is_ready = true
var speed = 0.0:
    set(value):
        speed = value
        $Anim.speed_scale = abs(speed)


func _ready() -> void:
    super()
    $Area.body_entered.connect(_on_area_item_entered)
    $Sprites.scale.x = (1.0 if target_pos.x <= tile_pos.x else -1.0)
    $Connector.rotated.connect(func(): speed = $Connector.speed)


func _physics_process(delta: float) -> void:
    debug_data = target_pos
    if held_items.size() > 0:
        var main_item = held_items[0]
        main_item.velocity.y = 0.0
        main_item.velocity.x = 0
        main_item.global_position.x = lerp(
            main_item.global_position.x, global_position.x, delta * 5.0
        )
        main_item.position.y = global_position.y - 80.0

        if is_ready and speed != 0.0:
            is_ready = false
            var difference = target_pos - tile_pos
            # I PULLED THESE NUMBERS OUT OF MY ASS
            main_item.global_position.x = global_position.x

            main_item.velocity.y = (difference.y * 64.0) - 970.0
            main_item.velocity.x = difference.x * 64.0
            main_item.flying = true
            main_item.fly_destination = (
                Vector2(target_pos * 128) + Vector2(64, 64)
            )
            held_items.pop_front()
            $Anim.play(&"launch")

    super(delta)


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name == &"launch":
        is_ready = true
