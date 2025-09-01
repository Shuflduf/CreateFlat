extends Node

@export var item_source_factory: ItemSourceFactory
@export var world: GameWorld
@export var inventory: Inventory

var components_list: Array[ComponentInfo]
@onready var components_parent: Node2D = $"../Components"


func load_from_file(path: String):
    var save_str = FileAccess.get_file_as_string(path)
    var save = JSON.parse_string(save_str)
    item_source_factory.gen_seed = int(save["seed"])
    for block in save["blocks"]:
        var target_block_name = block["name"]
        var component_info = find_component_by_name(target_block_name)
        var tile_pos = parse_vec2i(block["position"])
        var rotation_index = int(block["rotation"])
        var new_component: MechanicalComponent = (
            component_info.scene.instantiate()
        )
        new_component.position = Vector2(tile_pos) * 128.0
        new_component.tile_pos = tile_pos
        new_component.rotation_index = rotation_index
        new_component.rotation = (
            MoreConsts.HALF_PI * (rotation_index % new_component.max_rotations)
        )
        if block.has("extra") and target_block_name == "Ejector":
            print(block["extra"])
            new_component.target_pos = parse_vec2i(block["extra"])
        components_parent.add_child(new_component)
        world.all_components[tile_pos] = new_component

    world.refresh()


func load_example():
    load_from_file("res://example.json")
    # assert(save["blocks"][0]["position"] == Vector2i(0, 2))


func save_data():
    var new_save_data = {"seed": item_source_factory.gen_seed, "blocks": []}
    for pos in world.all_components:
        var component = world.all_components[pos]
        var new_component_data = {
            "position": pos,
            "name": find_name_by_component(component),
            "rotation": component.rotation_index
        }

        if component is WeightedEjector:
            new_component_data["extra"] = component.target_pos

        new_save_data["blocks"].append(new_component_data)
    var file = FileAccess.open("%s.json" % random_string(), FileAccess.WRITE)
    file.store_string(JSON.stringify(new_save_data))


func random_string() -> String:
    const CHARACTERS = "abcdefghijklmnopqrstuvwxyz"
    var word = ""
    for i in range(8):
        word += CHARACTERS[randi() % CHARACTERS.length()]
    return word


func load_component_data():
    for category in inventory.components:
        var components = inventory.components[category]
        components_list.append_array(components)


func find_component_by_name(target_name: String) -> ComponentInfo:
    return components_list.filter(func(c: ComponentInfo): return c.name == target_name)[0]


func find_name_by_component(target_component: MechanicalComponent) -> String:
    var component_scene: PackedScene = load(target_component.scene_file_path)
    return (
        components_list
        . filter(func(c: ComponentInfo): return c.scene == component_scene)[0]
        . name
    )


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed(&"save"):
        save_data()


func _ready():
    load_component_data()
    match Global.transition_data["load"]:
        "example":
            load_example()
        "new":
            pass
        _:
            load_from_file(Global.transition_data["load"])
    # if Global.transition_data["load"] == "example":
    #     load_example()
    # elif Global.transition_data["load"] != "new":


func parse_vec2i(vec_string: String) -> Vector2i:
    var no_brackets = vec_string.substr(1, vec_string.length() - 2)
    var numbers = no_brackets.split(", ")
    return Vector2i(
        int(numbers[0]),
        int(numbers[1]),
    )
