extends Node

@export var item_source_factory: ItemSourceFactory
@export var world: GameWorld
@export var inventory: Inventory


var components_list: Array[ComponentInfo]
@onready var components_parent: Node2D = $"../Components"

func load_example():
    var save_str = FileAccess.get_file_as_string("res://save.json")
    var save = JSON.parse_string(save_str)
    item_source_factory.gen_seed = int(save["seed"])
    for block in save["blocks"]:
        var target_block_name = block["name"]
        var component_info = find_component_by_name(target_block_name)
        var tile_pos = parse_vec2i(block["position"])
        var new_component: MechanicalComponent = component_info.scene.instantiate()

        new_component.position = Vector2(tile_pos) * 128.0
        components_parent.add_child(new_component)
        world.all_components[tile_pos] = new_component
    print(world.all_components)
    # assert(save["blocks"][0]["position"] == Vector2i(0, 2))


func load_component_data():
    for category in inventory.components:
        var components = inventory.components[category]
        components_list.append_array(components)
        print(components_list)


func find_component_by_name(target_name: String) -> ComponentInfo:
    return components_list.filter(func(c: ComponentInfo): return c.name == target_name)[0]


func _ready():
    load_component_data()
    load_example()
    print(find_component_by_name("Motor"))
    print(parse_vec2i("(0, 2)"))


func parse_vec2i(vec_string: String) -> Vector2i:
    var no_brackets = vec_string.substr(1, vec_string.length() - 2)
    var numbers = no_brackets.split(", ")
    return Vector2i(
        int(numbers[0]),
        int(numbers[1]),
    )
