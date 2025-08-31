extends Camera2D

const MAX_ZOOM_IN = 2.0
const MAX_ZOOM_OUT = 0.1
const WASD_MOVE_SPEED = 1000.0

var moving_cam = false


func _physics_process(delta: float) -> void:
    var move_dir = Input.get_vector(&"left", &"right", &"up", &"down")
    position += move_dir * delta * WASD_MOVE_SPEED * (1 / zoom.x)


func _ready() -> void:
    limit_left = -MoreConsts.MAP_SIZE * 128
    limit_top = limit_left
    limit_right = -limit_left
    limit_bottom = limit_right


#func _physics_process(delta: float) -> void:
#position = position.clamp(Vector2(limit_right, limit_bottom), Vector2(limit_left, limit_top))


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_MIDDLE:
            moving_cam = event.is_pressed()
        elif (
            event.button_index == MOUSE_BUTTON_WHEEL_DOWN
            or event.button_index == MOUSE_BUTTON_WHEEL_UP
        ):
            var zoom_factor = (
                1.2 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1 / 1.2
            )
            var mouse_pos = -get_local_mouse_position()

            zoom *= zoom_factor
            if zoom.x < MAX_ZOOM_IN and zoom.x > MAX_ZOOM_OUT:
                global_position += mouse_pos * (1 - zoom_factor)
            zoom = clamp(
                zoom,
                Vector2(MAX_ZOOM_OUT, MAX_ZOOM_OUT),
                Vector2(MAX_ZOOM_IN, MAX_ZOOM_IN)
            )
    elif event is InputEventMouseMotion and moving_cam:
        global_position -= event.relative / zoom
