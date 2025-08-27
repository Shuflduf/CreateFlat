class_name ItemSource
extends Node2D

var spawner: ItemSourceSpawner
var item_data: ItemData

func update_texture():
    $Sprite.texture = item_data.texture
#var connected_to: Array[MechanicalResource]
