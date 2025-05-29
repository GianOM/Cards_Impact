class_name Torre
extends Node3D

var Tower_Index: int
var Tower_Range : float#Indicador do Range. Nao e o Range Real
var Tower_Damage : float
var Tower_Shooting_Cooldown : float
var Possible_Targets:Array[Moving_Units]

var My_Gaslight_Token_Cost:int
var My_Gatekeep_Token_Cost:int

var is_Tower_Place_on_Grid : bool = false

@onready var main_tower: MeshInstance3D = $Main_Tower
@onready var tower_aim: MeshInstance3D = $Main_Tower/Tower_Aim
@onready var collision_shape_3d: CollisionShape3D = $Enemy_Detection_3D/CollisionShape3D
@onready var tower_range: MeshInstance3D = $Main_Tower/Tower_Range

@onready var bullet_spawner: Timer = $"Bullet Spawner"

var Tower_Projectiles:Array[Projetil]

@onready var projectile_generation_point: Projectile_Generator = $"Projectile Generation Point"


@export var Tower_Database: Array[Tower_Data] = []

#
#func _ready() -> void:
	#


func Troca_Pra_Torre_Pelo_Indice(idx:int):
	Tower_Index = idx #Usada para acessar e setar a malha do projetil
	projectile_generation_point.Tower_Index = idx
	
	var Tower_Data_Resource: Tower_Data = Tower_Database[idx]
	
	var Tower_Scene = load(Tower_Data_Resource.Tower_scene_path)#Carrega a PackedScene contendo a malha 3D
	var Correct_Tower_InstanceMesh3D = Tower_Scene.instantiate()#Ja que a Packed Scene so contem uma InstanceMesh3D, instancia-la carrega para uma variavel
	
	$Main_Tower.mesh = Correct_Tower_InstanceMesh3D.mesh
	
	My_Gaslight_Token_Cost = Tower_Data_Resource.Gaslight_Token_Cost
	My_Gatekeep_Token_Cost = Tower_Data_Resource.Gatekeep_Token_Cost
	
	Tower_Damage = Tower_Data_Resource.Tower_Damage
	projectile_generation_point.Tower_Damage = Tower_Damage#A inicializacao do projetil esta dentro deste objeto
	
	$Enemy_Detection_3D/CollisionShape3D.shape.set_radius(Tower_Data_Resource.Tower_Range)#O COLLISION SHAPE É O REAL RAIO DA TORRE
	#O TOWER_RANGE É O VISUALIZADOR DO RANGE
	$Main_Tower/Tower_Range.scale = Vector3(0.1*Tower_Data_Resource.Tower_Range,
								0.1*Tower_Data_Resource.Tower_Range,
								0.1*Tower_Data_Resource.Tower_Range)
	
	$"Bullet Spawner".set_wait_time(Tower_Data_Resource.Tower_Attack_Cooldown)
	#main_tower.Inicializa_Torre(idx)
	
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
	
	if projectile_generation_point.List_of_Projectiles.size() > 32:
		projectile_generation_point.Clean_Up_Projectile_Array()

func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.append(body)

func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.remove_at(0)

func _on_bullet_spawner_timeout() -> void:
	if Possible_Targets.size() > 0 and is_Tower_Place_on_Grid == true:
		projectile_generation_point.Spawn_a_Prjectile(Possible_Targets)
