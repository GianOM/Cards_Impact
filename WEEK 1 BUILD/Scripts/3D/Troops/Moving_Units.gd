class_name Moving_Units
extends CharacterBody3D

@export var Vida: float
@export var Velocidade: float


func _process(_delta: float) -> void:
	pass
	
func Take_Damage(Dano: float) -> void:
	Vida -= Dano
