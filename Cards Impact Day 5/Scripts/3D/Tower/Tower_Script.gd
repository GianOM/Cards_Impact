class_name Torre
extends Node3D

var Tower_Index: int
var Tower_Range : float#Indicador do Range
var Tower_Damage : float
var Possible_Targets:Array[Moving_Units]

var is_Tower_Place_on_Grid : bool = false

@onready var main_tower: MeshInstance3D = $Main_Tower
@onready var tower_aim: MeshInstance3D = $Main_Tower/Tower_Aim
@onready var collision_shape_3d: CollisionShape3D = $Enemy_Detection_3D/CollisionShape3D
@onready var tower_range: MeshInstance3D = $Main_Tower/Tower_Range


@onready var Projectile: Projetil = $ProjectilBody3D


func Troca_Pra_Torre_Pelo_Indice(idx:int):
	main_tower.seleciona_mesh_pelo_indice(idx)
	
func Zerar_o_Tower_Range():
		tower_range.scale = Vector3(2*0.01,
									2*0.01,
									2*0.01)
	
	
func Show_Tower_Range_When_Hovered():
	var Novo_Raio = collision_shape_3d.shape.get_radius()

	tower_range.scale = Vector3(2*Novo_Raio,
								2*Novo_Raio,
								2*Novo_Raio)

func _process(delta: float) -> void:
	if Possible_Targets.size() > 0:
		tower_aim.global_position = Possible_Targets[0].global_position
		tower_aim.global_position.y += 8
		tower_aim.scale = Vector3(0.25,0.25,0.25)
		
		Projectile.velocity = Projectile.global_position.direction_to(Possible_Targets[0].global_position) * Projectile.Projectile_Speed#Bullet Speed
		var Look_Direction = Possible_Targets[0].global_position - Projectile.global_position
		Projectile.look_at(Possible_Targets[0].global_position)
		Projectile.move_and_slide()
		
		if is_Tower_Place_on_Grid == true:
			#Possible_Targets[0].Vida -= 10 * delta
			print("Ola molieres")
			#print(Possible_Targets[0].Vida)
	else:
		tower_aim.global_position = main_tower.global_position
		tower_aim.scale = Vector3(0.025,0.025,0.025)

func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.append(body)

func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.erase(body)
