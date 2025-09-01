extends Control


func _ready():
    get_window().files_dropped.connect(_on_files_dropped)


func _on_files_dropped(files: PackedStringArray):
    Global.transition_data = {"load": files[0]}
    go_to_world()


func _on_new_pressed() -> void:
    Global.transition_data = {"load": "new"}
    go_to_world()


func _on_load_pressed() -> void:
    Global.transition_data = {"load": "example"}
    go_to_world()


func go_to_world():
    get_tree().change_scene_to_file("res://World/main.tscn")
