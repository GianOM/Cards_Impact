class_name Enemy_Spawner
extends MeshInstance3D

@onready var enemy_spawner_counter: Control = $SubViewport/EnemySpawnerCounter
@onready var path_area_3d: Area3D = $".."

var Troop_Spawner_Team: int

var Troop_Index:int

func _ready() -> void:
	$"Troop Warning Sign/AnimationPlayer".animation_finished.connect(_on_warning_animation_finished)
	

@rpc("any_peer","call_local","reliable")
func Adcionar_Tropa_Ao_Enemy_Spawner(INDEX: int):
	Troop_Index = INDEX
	$"Troop Warning Sign/AnimationPlayer".play("Action")
	
func _on_warning_animation_finished(Nome:StringName):
	path_area_3d.Adcionar_Tropa_Ao_Enemy_Spawner(Troop_Index)
