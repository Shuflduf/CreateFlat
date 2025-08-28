extends Control


func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"inventory"):
        show()


func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            hide()
