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

func transfer_rotation():
    if not connected_to:
        return
    
    sprites.frame = connected_to.sprites.frame
    connected_to.speed = -speed
    connected_to.rotated.emit()
    #connected_to.transfer_rotation()
