class_name Torre
extends Node3D

var Tower_Index: int
var Tower_Range : float#Indicador do Range
var Tower_Damage : float
var Tower_Shooting_Cooldown : float
var Possible_Targets:Array[Moving_Units]

var is_Tower_Place_on_Grid : bool = false

@onready var main_tower: MeshInstance3D = $Main_Tower
@onready var tower_aim: MeshInstance3D = $Main_Tower/Tower_Aim
@onready var collision_shape_3d: CollisionShape3D = $Enemy_Detection_3D/CollisionShape3D
@onready var tower_range: MeshInstance3D = $Main_Tower/Tower_Range
@onready var projectile_generation_point: Marker3D = $"Projectile Generation Point"



var is_Timer_Running:bool = false
@onready var bullet_spawner: Timer = $"Bullet Spawner"


@onready var Projectile: Projetil = $ProjectilBody3D

var Projectile_Index: int = 0
var Tower_Projectiles:Array[Projetil]

const PROJECTILE = preload("res://Scenes/3D/Projectile/Projectile.tscn")

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

func _process(_delta: float) -> void:
	if Possible_Targets.size() > 0:
		tower_aim.global_position = Possible_Targets[0].global_position
		tower_aim.global_position.y += 8
		tower_aim.scale = Vector3(0.25,0.25,0.25)#Podemos melhorar
		
		if is_Tower_Place_on_Grid == true:
			if Possible_Targets[0] != null and is_instance_valid(Possible_Targets[0]): # Ensure target is valid
				if not is_Timer_Running:
					bullet_spawner.start()
					is_Timer_Running = true
					
				for i in range(Tower_Projectiles.size()):
					if Tower_Projectiles[i] != null and is_instance_valid(Tower_Projectiles[i]):
						Tower_Projectiles[i].set_projectile_target(Possible_Targets[0])
						Tower_Projectiles[i].is_Projectile_Flying = true
				
				
	else:
		tower_aim.global_position = main_tower.global_position
		tower_aim.scale = Vector3(0.025,0.025,0.025)

func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.append(body)

func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.erase(body)


func _on_bullet_spawner_timeout() -> void:
	if Possible_Targets.size() > 0 and Possible_Targets[0] != null and is_instance_valid(Possible_Targets[0]):
			var temp_projectile : Projetil = PROJECTILE.instantiate()#Precisamos desta varial...PQ???
			Tower_Projectiles.append(temp_projectile)
			get_node("Projectiles Container").add_child(Tower_Projectiles[Projectile_Index])
			Projectile_Index += 1
			temp_projectile.global_position = projectile_generation_point.global_position
			is_Timer_Running = false
