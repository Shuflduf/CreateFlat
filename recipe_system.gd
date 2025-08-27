extends Node

enum RecipeType {
	MIXING,
	MILLING,
	PRESSING,
	PACKING,
}

const ITEMS_LIST_PATH = "res://Items/List"
const RECIPES_DATA = "res://Items/recipes.json"

var all_item_data: Array[ItemData]

# Dictionary[RecipeType, Array[ItemRecipe]]
var recipes: Dictionary[RecipeType, Array] = {
	RecipeType.MIXING: [],
	RecipeType.MILLING: [],
	RecipeType.PRESSING: [],
	RecipeType.PACKING: [],
}


func _ready() -> void:
	var dir = DirAccess.open(ITEMS_LIST_PATH)
	for file in dir.get_files():
		var data: ItemData = ResourceLoader.load(ITEMS_LIST_PATH + "/" + file)
		all_item_data.append(data)

	var raw_recipe_str = FileAccess.get_file_as_string(RECIPES_DATA)
	var raw_recipe_data = JSON.parse_string(raw_recipe_str)
	for type in raw_recipe_data.keys():
		var raw_type: RecipeType
		match type:
			"mixing": raw_type = RecipeType.MIXING
			"milling": raw_type = RecipeType.MILLING
			"pressing": raw_type = RecipeType.PRESSING
			"packing": raw_type = RecipeType.PACKING
		var type_recipes = raw_recipe_data[type]
		for recipe in type_recipes:
			var new_recipe = ItemRecipe.new()
			for ingredient in recipe["ingredients"]:
				new_recipe.ingredients[ingredient] = int(recipe["ingredients"][ingredient])
			for result in recipe["results"]:
				new_recipe.results[result] = int(recipe["results"][result])
			recipes[raw_type].append(new_recipe)
	
	print(recipes)
