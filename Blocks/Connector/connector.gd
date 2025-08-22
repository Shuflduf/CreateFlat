class_name MechanicalConnector
extends Node2D

signal rotated

@onready var sprites: AnimatedSprite2D = $Sprites

var speed = 0.0:
    set(value):
        speed = value
        sprites.speed_scale = value if not flipped else -value

#@export var internal_connector: MechanicalConnector
#var external_connector: MechanicalConnector
var connected_to: MechanicalConnector
var facing_dir = MechanicalComponent.Dir
var flipped = false
var parent: MechanicalComponent

func _physics_process(delta: float) -> void:
    modulate.h = 0.5 + (sprites.speed_scale / 3.0)
    #print(modulate.h)
    
func transfer_rotation():
    if not connected_to:
        return
    
    connected_to.flipped = parent.rotation_index in [MechanicalComponent.Dir.Down, MechanicalComponent.Dir.Right]
    #if connected_to.facing_dir == facing_dir:
        #connected_to.speed = -speed
    #else:
    connected_to.speed = speed

    #sprites.frame = connected_to.sprites.frame
    connected_to.rotated.emit()
    #connected_to.transfer_rotation()
