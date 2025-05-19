extends PathFollow3D

@onready var troops: Tropas = $Troops

func _ready() -> void:
	var troops: Tropas = $Troops
	

func _process(delta: float) -> void:
	progress_ratio += troops.Velocidade * delta
