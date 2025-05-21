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
		
	else:
		tower_aim.global_position = main_tower.global_position
		tower_aim.scale = Vector3(0.025,0.025,0.025)
	
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
			get_node("Projectiles Container").add_child(temp_projectile)
			temp_projectile.global_position = projectile_generation_point.global_position
			temp_projectile.seleciona_mesh_pelo_indice(Tower_Index)
			temp_projectile.set_projectile_target(Possible_Targets[0])
			temp_projectile.is_Projectile_Flying = true
			
			Tower_Projectiles.append(temp_projectile)
			is_Timer_Running = false
