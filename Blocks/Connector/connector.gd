class_name MechanicalConnector
extends Node2D

signal rotated

@onready var sprites: AnimatedSprite2D = $Sprites

var speed = 0.0:
    set(value):
        speed = value
        sprites.speed_scale = value

#@export var internal_connector: MechanicalConnector
#var external_connector: MechanicalConnector
var connected_to: MechanicalConnector
var facing_dir = MechanicalComponent.Dir
var parent: MechanicalComponent

func _physics_process(_delta: float) -> void:
    modulate.h = 0.5 + (speed / 3.0)
    #print(modulate.h)
    
func transfer_rotation():
    if not connected_to:
        return

    var should_flip = (parent.rotation_index in connected_to.parent.flipped_dirs) and speed > 0.0
    #connected_to.flipped = 
    #if connected_to.facing_dir == facing_dir:
        #connected_to.speed = -speed
    #else:
    connected_to.speed = -speed if should_flip else speed
    #connected_to.speed = -speed

    #sprites.frame = connected_to.sprites.frame
    connected_to.rotated.emit()
    #connected_to.transfer_rotation()
