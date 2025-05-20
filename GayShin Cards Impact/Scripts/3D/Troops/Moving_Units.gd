class_name Moving_Units
extends CharacterBody3D

var Vida: float = 15.0
@export var Velocidade: float = .25


func _process(_delta: float) -> void:
	pass
	
func Take_Damage(Dano: float) -> void:
	Vida -= Dano
