extends PathFollow3D

@onready var Unidades: Moving_Units = $CharacterBody3D

func _process(delta: float) -> void:
	if Unidades.Vida < 0:
		queue_free()
	else:
		progress_ratio += Unidades.Velocidade * delta
