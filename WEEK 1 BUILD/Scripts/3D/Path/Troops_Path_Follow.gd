extends PathFollow3D

@onready var Unidades: Moving_Units = $CharacterBody3D

var has_Damaged_Tower: bool = false

func _process(delta: float) -> void:
	if Unidades.Vida < 0:
		queue_free()
	else:
		progress_ratio += Unidades.Velocidade * delta
	
	if progress_ratio > 0.99: 
		#Se a tropa completa 99% do caminho, ela acessa a vida da Base, que foi setada assim que a tropa entrou no Raio da Base
		#Substrai o dano a ser dano na torre, que esta guardado na classe Movin Units
		Unidades.Tower_Target.Base_Health_Points -= Unidades.Dano#Pega a vida da Base, subtrair certo dano e atualiza o valor
		#O codigo abaixo atualiza a UI de Vida
		Unidades.Tower_Target.get_node("SubViewport/ProgressBar").get_node("Base_Progress_Bar").Update_Base_Health(Unidades.Tower_Target.Base_Health_Points)
		
		#Mata a tropa assim que ela da dano
		queue_free()
