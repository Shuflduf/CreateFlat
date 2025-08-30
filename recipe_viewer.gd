extends Control

const RECIPE_NAMES = {
    RecipeSystem.RecipeType.PRESSING: "Pressing",
    RecipeSystem.RecipeType.MILLING: "Milling",
    RecipeSystem.RecipeType.PACKING: "Packing",
    RecipeSystem.RecipeType.MIXING: "Mixing"
}
@export var single_recipe: PackedScene


func _ready():
    for recipe_type in RecipeSystem.recipes:
        var new_list = %ListBase.duplicate()
        %RecipeTypes.add_child(new_list)
        # print(new_list.get_children())
        new_list.show()
        new_list.name = RECIPE_NAMES[recipe_type]
        for recipe in RecipeSystem.recipes[recipe_type]:
            var new_recipe = single_recipe.instantiate()
            new_list.list.add_child(new_recipe)
            new_recipe.populate(recipe)


func _input(event: InputEvent) -> void:
    if event.is_action_pressed(&"recipes"):
        visible = not visible
    elif event.is_action_pressed(&"ui_cancel") or event.is_action_pressed(&"inventory"):
        visible = false


func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            hide()
