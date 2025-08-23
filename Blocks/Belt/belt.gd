class_name Belt
extends MechanicalComponent

var left_belt: Belt
var right_belt: Belt

var speed = 0.0:
    set(value):
        print(value)
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
                    update_type()
                    target.update_type()
                elif dir == Dir.RIGHT:
                    right_belt = target
                    target.left_belt = self
                    update_type()
                    target.update_type()


func update_type():
    #for c in $Parts.get_children():
        #c.hide()
    
    %SideStart.visible = left_belt == null
    %SideEnd.visible = right_belt == null
    
    #if left_belt and right_belt:
        #type = BeltType.FULL
    #elif left_belt:
        #type = BeltType.END
    #else:
        #type = BeltType.START
    
    #for p in section_mappings[type]:
        #p.show()
