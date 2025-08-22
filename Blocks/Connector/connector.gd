class_name MechanicalConnector
extends Node2D

signal rotated

@export var shaft_bottom = false

var speed = 0.0:
    set(value):
        speed = value
        sprites.speed_scale = -value if shaft_bottom else value

var connected_to: MechanicalConnector
var global_dir: MechanicalComponent.Dir
var parent: MechanicalComponent

@onready var sprites: AnimatedSprite2D = $Sprites
@onready var debug: Sprite2D = $Debug


func _ready() -> void:
    if shaft_bottom:
        sprites.material.set_shader_parameter(&"bottom_shown", true)
        sprites.material.set_shader_parameter(&"top_shown", false)

#func _physics_process(_delta: float) -> void:
    #$Sprites.modulate.h = 0.5 + (speed / 3.0)


#speed = 0.0
#print(modulate.h)


func transfer_rotation():
    if not connected_to:
        return


    connected_to.speed = -speed
    connected_to.sprites.frame = sprites.frame
    connected_to.rotated.emit()
