class_name Belt
extends MechanicalComponent

const BELT_SPEED = 200.0

var left_belt: Belt
var right_belt: Belt

var speed = 0.0:
    set(value):
        speed = value
        for part in $Parts.get_children():
            part.material.set_shader_parameter(&"speed", value)

var held_item: Item
var queue: Array[Item]


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


func _physics_process(_delta: float) -> void:
    if held_item:
        var on_belt = (
            abs(global_position.x - held_item.global_position.x) < 64.0
        )
        if on_belt:
            held_item.velocity.y = 0.0
            held_item.velocity.x = BELT_SPEED
            held_item.position.y = global_position.y - 80.0
        elif right_belt:
            if right_belt.held_item:
                held_item.velocity.y = 0.0
                held_item.velocity.x = 0.0
                held_item.position.y = global_position.y - 80.0
            else:
                right_belt.held_item = held_item
                held_item = null
        else:
            held_item.velocity.x = BELT_SPEED
            held_item.temp_disable()
            held_item = null

        #else:
        #if ri

        print(on_belt)
        #held_item.velocity.x = 200.0

        #if held_item.global_position.x > global_position.x + 88.0:
        #held_item = null
        #if right_belt and not right_belt.held_item:
        #right_belt.held_item = held_item
        #held_item = null
        #else:

    if not held_item and queue.size() >= 1:
        held_item = queue.pop_front()

    for i in queue.size():
        print("A")
        var item = queue[i]
        item.velocity.y = 0.0
        item.global_position.y = global_position.y - 32 * (i + 1) - 74


func _post_update_neighbors(
    component_pos: Vector2i,
    all_components: Dictionary[Vector2i, MechanicalComponent]
):
    for dir in [Dir.LEFT, Dir.RIGHT]:
        var test_pos = component_pos + DIR_MAPPINGS[dir]
        if all_components.has(test_pos):
            var target = all_components[test_pos]
            if target is Belt:
                if dir == Dir.LEFT:
                    left_belt = target
                    target.right_belt = self
                    update_visuals()
                    target.update_visuals()
                elif dir == Dir.RIGHT:
                    right_belt = target
                    target.left_belt = self
                    update_visuals()
                    target.update_visuals()


func _post_disconnect_neighbors(
    _component_pos: Vector2i,
    _all_components: Dictionary[Vector2i, MechanicalComponent]
):
    if left_belt:
        left_belt.right_belt = null
        left_belt.update_visuals()
    if right_belt:
        right_belt.left_belt = null
        right_belt.update_visuals()


func update_visuals():
    %SideLeft.visible = left_belt == null
    %SideRight.visible = right_belt == null


func _on_area_body_entered(body: Node2D) -> void:
    if body is Item and active and body != held_item:
        if held_item:
            prints("queued", body)
            body.global_position.x = (
                global_position.x + randf_range(-16.0, 16.0)
            )
            queue.append(body)
            #body.velocity.y = 0
        else:
            held_item = body
        #body.velocity.y = 0.0
        #body.velocity.x = 5.0
