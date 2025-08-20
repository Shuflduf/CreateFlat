extends Node2D

func _physics_process(_delta: float) -> void:
    $Shaft.stress_units = 1000000.0
    $Shaft.speed = 1.0
