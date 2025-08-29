extends PanelContainer

@export var arrow_texture: Texture2D

func populate(recipe: ItemRecipe):
    print(recipe)
    populate_item_set(recipe.ingredients)
    add_arrow()
    populate_item_set(recipe.results)


func populate_item_set(items: Dictionary[String, int]):
    for item in items:
        var count = items[item]
        var tex = RecipeSystem.all_item_data.filter(func(i: ItemData): return i.id == item)[0].texture
        for i in count:
            var new_icon = %BaseTexture.duplicate()
            %BaseTexture.get_parent().add_child(new_icon)
            new_icon.texture = tex
            new_icon.show()

func add_arrow():
    var arrow = %BaseTexture.duplicate()
    %BaseTexture.get_parent().add_child(arrow)
    arrow.texture = arrow_texture
    arrow.show()
