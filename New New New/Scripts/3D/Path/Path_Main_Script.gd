extends Area3D

const TROOPS = preload("res://Scenes/3D/Troops/Troops.tscn")

@export var Number_of_Troops_to_Spawn: int = 0

@onready var path_3d: Path3D = $Path3D
@onready var spawn_timer_cooldown: Timer = $"Spawn Timer Cooldown"

func Adcionar_Tropa_Ao_Enemy_Spawner():
	print("Nova Tropa")
	Number_of_Troops_to_Spawn += 1
	spawn_timer_cooldown.set_paused(false)

func _on_spawn_timer_cooldown_timeout() -> void:
	if Number_of_Troops_to_Spawn > 0:
		var temp_enemy = TROOPS.instantiate()
		path_3d.add_child(temp_enemy)
		Number_of_Troops_to_Spawn -= 1

	elif Number_of_Troops_to_Spawn == 0:
		spawn_timer_cooldown.set_paused(true)
