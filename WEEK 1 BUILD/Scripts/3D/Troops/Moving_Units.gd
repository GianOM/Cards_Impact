class_name Moving_Units
extends CharacterBody3D

@export var Vida: float
@export var Velocidade: float
@export var Dano: float

var Tower_Target: Tower_Base

func _process(delta: float) -> void:
	pass

func Take_Damage(Dano: float) -> void:
	Vida -= Dano
