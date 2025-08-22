class_name MechanicalConnector
extends Node2D

signal rotated

var speed = 0.0:
    set(value):
        speed = value
        sprites.speed_scale = value

var connected_to: MechanicalConnector
var global_dir: MechanicalComponent.Dir
var parent: MechanicalComponent
@onready var sprites: AnimatedSprite2D = $Sprites
@onready var debug: Sprite2D = $Debug


func _physics_process(_delta: float) -> void:
    $Sprites.modulate.h = 0.5 + (speed / 3.0)


#speed = 0.0
#print(modulate.h)


func transfer_rotation():
    if not connected_to:
        return

    #sprites.frame = connected_to.sprites.frame

    #connected_to.transfer_rotation()
    #var should_flip = (
        #global_dir
        #in [MechanicalComponent.Dir.UP, MechanicalComponent.Dir.LEFT]
    #) and speed > 0.0
    
    #match global_dir:
        #MechanicalComponent.Dir.UP:
            #should_flip = true
        #MechanicalComponent.Dir.DOWN:
            #should_flip = true 
    #should_flip = true
    connected_to.speed = -speed

    #sprites.frame = connected_to.sprites.frame
    connected_to.rotated.emit()
#connected_to.transfer_rotation()
