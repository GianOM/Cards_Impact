extends PathFollow3D

@onready var character_body_3d: Personagens = $CharacterBody3D

func _ready() -> void:
	var character_body_3d: Personagens = $CharacterBody3D
	
func _process(delta: float) -> void:
	progress_ratio += character_body_3d.Velocidade * delta
