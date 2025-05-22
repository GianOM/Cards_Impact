extends PathFollow3D

@onready var Unidades: Moving_Units = $CharacterBody3D

var has_Damaged_Tower: bool = false

func _process(delta: float) -> void:
	if Unidades.Vida < 0:
		queue_free()
	else:
		progress_ratio += Unidades.Velocidade * delta
	
	if progress_ratio > 0.99: 
		Unidades.Tower_Target.Base_Health_Points -= 250
		
		Unidades.Tower_Target.get_node("SubViewport/ProgressBar").get_node("Base_Progress_Bar").Update_Base_Health(Unidades.Tower_Target.Base_Health_Points)
		queue_free()
