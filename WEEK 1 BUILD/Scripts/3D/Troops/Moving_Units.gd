class_name Moving_Units
extends CharacterBody3D

@export var Vida: float
@export var Velocidade: float
@export var Dano_a_Bases: float

var Tower_Target: Tower_Base

func inicializar_Moving_Unit(Recurso:Moving_Units_Data, My_Mesh:MeshInstance3D):
	Vida = Recurso.Vida
	Velocidade = Recurso.Velocidade
	Dano_a_Bases = Recurso.Dano
	
	$Moving_Unit_MeshInstance3D.mesh = My_Mesh.mesh

func Take_Damage(Dano_Sofrido: float) -> void:
	Vida -= Dano_Sofrido
	if Vida < 0 :
		queue_free()
