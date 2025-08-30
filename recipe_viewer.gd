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
