class_name MechanicalConnector
extends Node2D

var stress_units = 0.0
var speed = 0.0:
    set(value):
        speed = value
        $Sprites.speed_scale = value

var connected_to: MechanicalConnector

func transfer_rotation():
    if not connected_to:
        return
    connected_to.stress_units = stress_units
    connected_to.speed = speed
    connected_to.transfer_rotation()
