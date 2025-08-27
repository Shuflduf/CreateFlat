extends Node2D


func _on_spawn_timer_timeout() -> void:
    #var new_item = preload("res://item.tscn").instantiate()
    #add_child(new_item)
    #new_item.global_position = global_position
    return


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed(&"debug"):
        RecipeSystem.recipe_test()
        var new_item = Item.from_id("iron")
        new_item.position = position
        add_child(new_item)
        #var new_item = preload("res://Items/item.tscn").instantiate()
        #add_child(new_item)
        #new_item.global_position = global_position
        ## how the fuck does waiting two physics frames fix all my problems
        #await get_tree().physics_frame
        #await get_tree().physics_frame
        #new_item.is_ready = true
