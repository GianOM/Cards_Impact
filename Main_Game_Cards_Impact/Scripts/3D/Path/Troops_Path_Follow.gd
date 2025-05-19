extends PathFollow3D
@onready var tropas: Moving_Units = $Tropas

func _process(delta: float) -> void:
	progress_ratio += tropas.Velocidade * delta
