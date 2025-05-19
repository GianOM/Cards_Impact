class_name Torre
extends Node3D

var Tower_Range : float
var Tower_Damage : float
var Possible_Targets:Array[Moving_Units]

@onready var main_tower: MeshInstance3D = $Main_Tower
@onready var tower_aim: MeshInstance3D = $Main_Tower/Tower_Aim

func Troca_Pra_Torre_Pelo_Indice(idx:int):
	main_tower.seleciona_mesh_pelo_indice(idx)

func _process(delta: float) -> void:
	if Possible_Targets.size() > 0:
		tower_aim.global_position = Possible_Targets[0].global_position
		tower_aim.global_position.y += 8
		tower_aim.scale = Vector3(0.25,0.25,0.25)
		
		
		Possible_Targets[0].Vida -= 10 * delta
		print(Possible_Targets[0].Vida)
	else:
		tower_aim.global_position = main_tower.global_position
		tower_aim.scale = Vector3(0.025,0.025,0.025)

func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.append(body)

func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.erase(body)
