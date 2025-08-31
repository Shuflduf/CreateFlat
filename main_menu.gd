extends Control


func _on_new_pressed() -> void:
    Global.transition_data = { "example": false }
    get_tree().change_scene_to_file("res://World/main.tscn")


func _on_load_pressed() -> void:
    Global.transition_data = { "example": true }
    get_tree().change_scene_to_file("res://World/main.tscn")
