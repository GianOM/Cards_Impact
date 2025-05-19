class_name Torre
extends Node3D

var Tower_Range : float
var Possible_Targets:Array[Tropas]


@onready var main_tower: MeshInstance3D = $Main_Tower
@onready var tower_aim: MeshInstance3D = $Tower_Aim



func Trocar_para_Torre_1():
	main_tower.set_tier_1_Mesh()
	
func Trocar_para_Torre_2():
	main_tower.set_tier_2_Mesh()

func _process(_delta: float) -> void:
	if Possible_Targets.size() > 0:
		tower_aim.global_position = Possible_Targets[0].global_position
		tower_aim.scale = Vector3(0.25,0.25,0.25)
	else:
		tower_aim.global_position = main_tower.global_position
		tower_aim.scale = Vector3(0.025,0.025,0.025)

func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
		if body is Tropas:
			Possible_Targets.append(body)

func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Tropas:
		Possible_Targets.erase(body)
