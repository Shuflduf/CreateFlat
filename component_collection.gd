extends VBoxContainer

signal item_selected(scene: PackedScene)
signal item_hovered(infographic: Texture2D)

@onready var label: Label = $Label


func add_item(info: ComponentInfo):
    var new_item = %Base.duplicate()
    %Base.get_parent().add_child(new_item)
    new_item.show()
    new_item.get_child(0).texture = info.thumbnail
    new_item.gui_input.connect(_on_item_input.bind(info))


func _on_item_input(event: InputEvent, info: ComponentInfo):
    if event is InputEventMouseMotion:
        item_hovered.emit(info.infographic)
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            item_selected.emit(info.scene)
