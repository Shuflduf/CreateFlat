class_name Belt
extends ItemTransport

const BELT_SPEED = 200.0

var speed = 0.0:
    set(value):
        speed = value
        for part in $Parts.get_children():
            part.material.set_shader_parameter(&"speed", value)


func _ready() -> void:
    super()
    $LeftConn.rotated.connect(
        func():
            speed = -$LeftConn.speed
            $RightConn.speed = -$LeftConn.speed
            $RightConn.transfer_rotation()
    )
    $RightConn.rotated.connect(
        func():
            speed = $RightConn.speed
            $LeftConn.speed = -$RightConn.speed
            $LeftConn.transfer_rotation()
    )
    $Area.body_entered.connect(_on_area_item_entered)


func _physics_process(_delta: float) -> void:
    if held_item:
        var on_belt = (
            abs(global_position.x - held_item.global_position.x) < 64.0
        )
        var target_transfer = right_connection if speed > 0 else left_connection
        if on_belt:
            held_item.velocity.y = 0.0
            held_item.velocity.x = BELT_SPEED * speed
            held_item.position.y = global_position.y - 80.0
        elif target_transfer:
            if target_transfer.held_item:
                held_item.velocity.y = 0.0
                held_item.velocity.x = 0.0
                held_item.position.y = global_position.y - 80.0
            else:
                target_transfer.held_item = held_item
                held_item = null
        else:
            held_item.velocity.x = BELT_SPEED * speed
            #held_item.temp_disable()
            held_item = null

    super(_delta)


func _post_update_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    super(component_pos, all_components)
    for dir in [Dir.LEFT, Dir.RIGHT]:
        var test_pos = component_pos + DIR_MAPPINGS[dir]
        if all_components.has(test_pos):
            var target = all_components[test_pos]
            if target is Belt:
                update_visuals()
                target.update_visuals()


func _post_disconnect_neighbors(
    _component_pos: Vector2i,
    _all_components: Dictionary[Vector2i, MechanicalComponent]
):
    super(_component_pos, _all_components)
    if left_connection and left_connection is Belt:
        left_connection.update_visuals()
    if right_connection and right_connection is Belt:
        right_connection.update_visuals()


func update_visuals():
    %SideLeft.visible = left_connection is not Belt
    %SideRight.visible = right_connection is not Belt
