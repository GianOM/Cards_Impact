extends PathFollow3D

@onready var Unidades: Moving_Units = $Moving_Unit_CharacterBody3D

var has_Damaged_Tower: bool = false


func _process(delta: float) -> void:
	if is_instance_valid(Unidades):
		progress_ratio += Unidades.Velocidade * delta
		
	Dano_na_Base()
		

func Dano_na_Base():
	if progress_ratio > 0.99: 
		#Se a tropa completa 99% do caminho, ela acessa a vida da Base, que foi setada assim que a tropa entrou no Raio da Base
		#Substrai o dano a ser dano na torre, que esta guardado na classe Movin Units
		#TODO: Trocar o nome de Tower Target para Base Target
		Unidades.Tower_Target.rpc("Take_Damage",Unidades.Dano_a_Bases)
		#Unidades.Tower_Target.Take_Damage(Unidades.Dano_a_Bases)
		#Mata a tropa assim que ela da dano
		queue_free()
	
