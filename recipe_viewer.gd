extends Control

@export var single_recipe: PackedScene

func _ready():
    var new_recipe = single_recipe.instantiate()
    %RecipeList.add_child(new_recipe)
    new_recipe.populate(RecipeSystem.recipes[RecipeSystem.RecipeType.PRESSING][0])
