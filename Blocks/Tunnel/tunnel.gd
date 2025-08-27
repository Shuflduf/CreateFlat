extends MechanicalComponent

#@onready var item_connections = {
    #$Left: [$Right, $Bottom]
#}
# Dictionary[Area2D, Array[Area2D]]
var queued_items: Array[Item]
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


func _ready() -> void:
    print(item_connections)
    await get_tree().physics_frame
    if active:
        z_index = 10
        for area in item_connections:
            area.body_entered.connect(_on_item_entered.bind(area))
        
func _on_item_entered(body: Node2D, area: Area2D):
    print(body, area)
    var item = body as Item
    if item not in queued_items:
        queued_items.append(item)
    else:
        return
    # item.velocity = Vector2.ZERO
    var out_area = item_connections[area][current_out[area]]
    item.global_position = out_area.global_position
    await get_tree().create_timer(0.1).timeout
    var strength = max(item.velocity.length(), 100.0)
    if out_area == $Bottom:
        item.global_position = out_area.global_position
        item.velocity.x = 0.0
        item.velocity.y = item.velocity.length()
        # item.velocity = item.velocity.rotated(90)
    current_out[area] += 1
    current_out[area] %= 2
