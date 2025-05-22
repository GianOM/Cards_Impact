class_name Torre
extends Node3D

var Tower_Index: int
var Tower_Range : float#Indicador do Range. Nao e o Range Real
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

@onready var Projectile_Index: int = 0
var Tower_Projectiles:Array[Projetil]

const PROJECTILE = preload("res://Scenes/3D/Projectile/Projectile.tscn")

func Troca_Pra_Torre_Pelo_Indice(idx:int):
	Tower_Index = idx #Usada para acessar e setar a malha do projetil
	main_tower.seleciona_mesh_pelo_indice(idx)
	
func Zerar_o_Tower_Range():
		tower_range.scale = Vector3(0.01,
									0.01,
									0.01)
	
	
func Show_Tower_Range_When_Hovered():
	var Novo_Raio = collision_shape_3d.shape.get_radius()

	tower_range.scale = Vector3(0.1*Novo_Raio,
								0.1*Novo_Raio,
								0.1*Novo_Raio)

func _process(delta: float) -> void:
	if Possible_Targets.size() > 0:
		for n in range (Possible_Targets.size()):
				if Possible_Targets[n] != null:
					tower_aim.global_position = Possible_Targets[n].global_position
					tower_aim.rotation.y += 1.25 * delta
					break
		tower_aim.global_position.y += 3

	else:
		tower_aim.global_position = main_tower.global_position
	
	if Tower_Projectiles.size() > 32:
		Tower_Projectiles = Tower_Projectiles.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null


func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.append(body)

func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.remove_at(0)

func _on_bullet_spawner_timeout() -> void:
	if Possible_Targets.size() > 0 and is_Tower_Place_on_Grid == true:
			var temp_projectile : Projetil = PROJECTILE.instantiate()#Precisamos desta varial...PQ???
			get_tree().root.add_child(temp_projectile)
			temp_projectile.global_position = projectile_generation_point.global_position
			temp_projectile.seleciona_mesh_pelo_indice(Tower_Index)
			
			for n in range (Possible_Targets.size()):
				if Possible_Targets[n] != null:
					temp_projectile.set_projectile_target(Possible_Targets[n])
					break
			
			temp_projectile.is_Projectile_Flying = true
			Tower_Projectiles.append(temp_projectile)
