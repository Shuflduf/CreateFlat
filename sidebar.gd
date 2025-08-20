extends Control

signal item_selected(scene: PackedScene)

@export var components: Array[ComponentInfo]

func _ready() -> void:
    for c in components:
        var new_item = %Base.duplicate()
        $Components.add_child(new_item)
        new_item.get_child(0).texture = c.thumbnail
        new_item.show()
        new_item.gui_input.connect(_on_item_input.bind(c.scene))
    #for c: Control in $Components.get_children():
        #c.gui_input.connect(_on_item_input.bind(c))
        
func _on_item_input(event: InputEvent, scene: PackedScene):
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            item_selected.emit(scene)
