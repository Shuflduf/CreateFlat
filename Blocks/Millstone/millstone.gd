extends ItemTransport

var running = false
var speed = 0.0:
    set(value):
        speed = value
        $GearPart.speed_scale = -abs(speed)


func _physics_process(_delta: float) -> void:
    #var all
    for item in held_items:
        item.global_position = global_position
        item.velocity = Vector2.ZERO

    start_mill()
    debug_data = held_items.size()


func start_mill():
    if not running and speed != 0.0 and mill_recipe() != null:
        $MillTimer.start()
        running = true


func mill_recipe() -> ItemRecipe:
    var ids: Array[String]
    held_items.map(func(i: Item): ids.append(i.data.id))
    var recipe = RecipeSystem.find_recipe(RecipeSystem.RecipeType.MILLING, ids)
    return recipe


func _mill_items():
    running = false
    var recipe = mill_recipe()
    if recipe != null:
        var ingredients_needed = recipe.ingredients.duplicate()
        var items_to_remove = []
        for item in held_items:
            if (
                ingredients_needed.has(item.data.id)
                and ingredients_needed[item.data.id] > 0
            ):
                ingredients_needed[item.data.id] -= 1
                items_to_remove.append(item)
        for item in items_to_remove:
            held_items.erase(item)
            item.queue_free()

        for result in recipe.results:
            var amount = recipe.results[result]
            for i in amount:
                var new_item = Item.from_id(result)
                new_item.position = position
                new_item.position += Vector2(64.0, 32.0)
                new_item.velocity.y = -1000.0
                new_item.z_index = -1


func _ready() -> void:
    super()
    $Connector.rotated.connect(func(): speed = $Connector.speed)
    $MillTimer.timeout.connect(_mill_items)

    await get_tree().physics_frame
    if active:
        z_index = 10


func _on_area_body_entered(body: Node2D) -> void:
    if body is Item and active:
        # and body not in held_items
        held_items.append(body)
