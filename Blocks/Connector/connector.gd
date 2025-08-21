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
var rotation_index = 0

func transfer_rotation():
    if not connected_to:
        return
    
    if connected_to.rotation_index == rotation_index:
        connected_to.speed = speed
    else:
        connected_to.speed = -speed

    sprites.frame = connected_to.sprites.frame
    connected_to.rotated.emit()
    #connected_to.transfer_rotation()
