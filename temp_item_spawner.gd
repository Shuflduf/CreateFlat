extends Node2D


func _on_spawn_timer_timeout() -> void:
    #var new_item = preload("res://item.tscn").instantiate()
    #add_child(new_item)
    #new_item.global_position = global_position
    return


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed(&"debug"):
        var new_item = preload("res://item.tscn").instantiate()
        add_child(new_item)
        new_item.global_position = global_position
