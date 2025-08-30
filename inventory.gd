extends Control

signal item_selected(scene: PackedScene)

# Dictionary[String, Array[ComponentInfo]]
@export var components: Dictionary[String, Array]
@export var component_collection_scene: PackedScene


func show_extra_info(info: ComponentInfo):
    var tex: AtlasTexture = %Infographic.texture
    tex.region.position.x = info.infographic_index * 100.0
    %Description.text = "[center]%s" % info.description
    %NameLabel.text = info.name


func _ready():
    for type in [
        "Rotation Handling",
        "Item Transportation",
        "Item Processing",
        "Miscellaneous"
    ]:
        var new_collection = component_collection_scene.instantiate()
        %Collections.add_child(new_collection)
        new_collection.label.text = type
        new_collection.item_selected.connect(
            func(s: PackedScene):
                hide()
                item_selected.emit(s)
        )
        new_collection.item_hovered.connect(show_extra_info)
        var components_of_type = components[type]
        for component: ComponentInfo in components_of_type:
            new_collection.add_item(component)


func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"inventory"):
        visible = not visible
    elif event.is_action_pressed(&"ui_cancel"):
        visible = false


func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            hide()
