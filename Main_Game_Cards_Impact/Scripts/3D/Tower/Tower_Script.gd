class_name Torre
extends Node3D

var Tower_Range : float

var Possible_Targets:Array[Tropas]
@onready var main_tower: MeshInstance3D = $Main_Tower


func Trocar_para_Torre_1():
	main_tower.set_tier_1_Mesh()
	
func Trocar_para_Torre_2():
	main_tower.set_tier_2_Mesh()



func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
			print(body)


func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Tropas:
		#Possible_Targets.erase(body)
		print("Enemy OUT")
