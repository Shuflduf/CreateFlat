extends Control

@export var single_recipe: PackedScene

func _ready():
    for recipe in RecipeSystem.recipes[RecipeSystem.RecipeType.PRESSING]:
        var new_recipe = single_recipe.instantiate()
        %RecipeList.add_child(new_recipe)
        new_recipe.populate(recipe)
