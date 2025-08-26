extends ItemTransport


var running = false
var process_targets: Array[Item]
var held_items: Array[Item]
var speed = 0.0:
    set(value):
        speed = value
        $GearPart.speed_scale = -abs(speed)


func _physics_process(_delta: float) -> void:
    #var all 
    for item in held_items:
        item.global_position = global_position
        item.velocity = Vector2.ZERO
    for item in process_targets:
        item.global_position = global_position
        item.velocity = Vector2.ZERO
    
    if held_item:
        held_item = null
    
    held_items = start_mill(held_items)
    #print(held_items)
    debug_data = held_items
    


func start_mill(items: Array[Item]) -> Array[Item]:
    if not running and speed != 0.0:
        const MILL_THRESHOLD = 4
        if items.size() >= MILL_THRESHOLD:
            process_targets = []
            for i in MILL_THRESHOLD:
                process_targets.append(items.pop_front())
            $MillTimer.start()
            running = true
    return items


func _ready() -> void:
    super()
    $Connector.rotated.connect(func(): speed = $Connector.speed)

    await get_tree().physics_frame
    if active:
        z_index = 10


func _on_area_body_entered(body: Node2D) -> void:
    if (
        body is Item
        and active
        and body not in held_items
        and body not in process_targets
    ):
        held_items.append(body)


func _on_mill_timer_timeout() -> void:
    running = false
    for item in process_targets:
        item.queue_free()
    process_targets = []
    var new_item = Item.from_id("")
    new_item.position = position
    new_item.position += Vector2(64.0, 0.0)
    new_item.velocity.y = -1000.0
    get_parent().add_child(new_item)
    #new_item.temp_disable()
