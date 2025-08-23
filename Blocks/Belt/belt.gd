class_name Belt
extends MechanicalComponent

var left_belt: Belt
var right_belt: Belt

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
    %SideStart.visible = left_belt == null
    %SideEnd.visible = right_belt == null
