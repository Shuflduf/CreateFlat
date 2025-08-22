class_name MechanicalConnector
extends Node2D

signal rotated

var speed = 0.0:
    set(value):
        speed = value
        sprites.speed_scale = value

var connected_to: MechanicalConnector
var facing_dir = MechanicalComponent.Dir
var parent: MechanicalComponent
@onready var sprites: AnimatedSprite2D = $Sprites


func _physics_process(_delta: float) -> void:
    modulate.h = 0.5 + (speed / 3.0)


#speed = 0.0
#print(modulate.h)


func transfer_rotation():
    if not connected_to:
        return

    #sprites.frame = connected_to.sprites.frame

    #connected_to.transfer_rotation()
    var should_flip = facing_dir in parent.flipped_dirs
    #should_flip = false
    connected_to.speed = -speed if should_flip else speed

    #sprites.frame = connected_to.sprites.frame
    connected_to.rotated.emit()
#connected_to.transfer_rotation()
