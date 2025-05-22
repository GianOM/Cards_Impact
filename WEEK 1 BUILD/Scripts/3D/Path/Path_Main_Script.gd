extends Area3D

const TROOPS = preload("res://Scenes/3D/Troops/Troops.tscn")

@export var Number_of_Troops_to_Spawn: int = 0

@onready var path_3d: Path3D = $Path3D
@onready var spawn_timer_cooldown: Timer = $"Spawn Timer Cooldown"

func Adcionar_Tropa_Ao_Enemy_Spawner():
	Number_of_Troops_to_Spawn += 1

func _on_spawn_timer_cooldown_timeout() -> void:
	print(ReadyButton.I_AM_READY)
	#ReadyButton.I_AM_READY é uma variavel global que indica que o player esta ready
	if Number_of_Troops_to_Spawn > 0 and ReadyButton.I_AM_READY == true:
		var temp_enemy = TROOPS.instantiate()
		path_3d.add_child(temp_enemy)
		Number_of_Troops_to_Spawn -= 1
