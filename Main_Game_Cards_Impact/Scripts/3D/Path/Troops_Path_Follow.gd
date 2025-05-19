extends PathFollow3D
@onready var tropas: Moving_Units = $Tropas

func _process(delta: float) -> void:
	
	if tropas.Vida < 0:
		queue_free()
	else:
		progress_ratio += tropas.Velocidade * delta
