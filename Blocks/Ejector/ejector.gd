extends ItemTransport

var is_ready = true

func _ready() -> void:
    super()
    $Area.body_entered.connect(_on_area_item_entered)
    $Sprites.scale.x = (1.0 if target_pos.x <= tile_pos.x else -1.0)


func _physics_process(delta: float) -> void:
    if held_item:
        var distance_to_center = held_item.global_position.x - global_position.x
        var centered = abs(distance_to_center) < 1.0
        if !centered:
            held_item.velocity.y = 0.0
            held_item.velocity.x = 0
            held_item.global_position.x = lerp(
                held_item.global_position.x, global_position.x, delta * 5.0
            )
            held_item.position.y = global_position.y - 80.0
        elif is_ready:
            is_ready = false
            var difference = target_pos - tile_pos
            # I PULLED THESE NUMBERS OUT OF MY ASS
            held_item.velocity.y = (difference.y * 64.0) - 1000.0
            held_item.velocity.x = difference.x * 64.0
            held_item.flying = true
            held_item.fly_destination = Vector2(target_pos * 128) + Vector2(64, 64)
            held_item = null
            $Anim.play(&"launch")

    super(delta)


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name == &"launch":
        is_ready = true
