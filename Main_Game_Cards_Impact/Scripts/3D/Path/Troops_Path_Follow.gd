extends PathFollow3D

@onready var node_3d: Tropas = $Node3D

func _ready() -> void:
	var node_3d: Tropas = $Node3D
	
func _process(delta: float) -> void:
	progress_ratio += node_3d.Velocidade * delta
