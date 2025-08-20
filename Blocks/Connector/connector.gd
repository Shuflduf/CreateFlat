class_name MechanicalConnector
extends Node2D

@onready var sprites: AnimatedSprite2D = $Sprites

var stress_units = 0.0
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
    connected_to.stress_units = stress_units
    connected_to.speed = speed
    connected_to.sprites.frame = sprites.frame
    connected_to.transfer_rotation()
