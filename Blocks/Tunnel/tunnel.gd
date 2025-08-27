extends MechanicalComponent

#@onready var item_connections = {
#$Left: [$Right, $Bottom]
#}
# Dictionary[Area2D, Array[Area2D]]

@onready var item_connections: Dictionary[Area2D, Array] = {
    $Left: [$Right, $Bottom],
    $Right: [$Left, $Bottom],
    $Bottom: [$Left, $Right],
}
@onready var current_out: Dictionary[Area2D, int] = {
    $Left: 0,
    $Right: 0,
    $Bottom: 0,
}
var queued_items: Array[Item]


func _ready() -> void:
    await get_tree().physics_frame
    if active:
        z_index = 10
        for area in item_connections:
            area.body_entered.connect(_on_item_entered.bind(area))


func _physics_process(_delta: float) -> void:
    for item in queued_items:
        item.position = position + Vector2(64.0, 64.0)


func _on_item_entered(body: Node2D, area: Area2D):
    var item = body as Item
    if item not in queued_items:
        queued_items.append(item)
    else:
        return

    print(body, area)
    var out_area = item_connections[area][current_out[area]]
    current_out[area] += 1
    current_out[area] %= 2

    await get_tree().create_timer(0.1).timeout
    item.global_position = out_area.global_position
    var strength = max(item.velocity.length(), 200.0)
    if out_area == $Bottom:
        item.velocity = Vector2(0.0, strength)
    elif out_area == $Left:
        item.velocity = Vector2(-strength, 0)
    elif out_area == $Right:
        item.velocity = Vector2(strength, 0)

    item.velocity = item.velocity.rotated(rotation_index * 1.5708)
    #item.velocity.x = 0.0
    #item.velocity.y = item.velocity.length()
    # item.velocity = item.velocity.rotated(90)

    item.temp_disable(0.2)
    queued_items.erase(item)
