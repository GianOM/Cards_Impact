class_name Torre
extends Node3D

var Tower_Index: int
var Tower_Damage : float
var Tower_Shooting_Cooldown : float
var Possible_Targets:Array[Moving_Units]

#----KILLER WAS HERE-----
var turn_in_which_tower_was_placed: int

const TOWER_RANGE_VISUAL_SCALE_FACTOR:float = 0.1
const TOWER_RANGE_ZEROED_SCALE: Vector3 = Vector3(0.002,0.002,0.002)

@onready var main_tower: MeshInstance3D = $Main_Tower
@onready var tower_aim: MeshInstance3D = $Main_Tower/Tower_Aim
@onready var collision_shape_3d: CollisionShape3D = $Enemy_Detection_3D/CollisionShape3D
@onready var tower_range: MeshInstance3D = $Main_Tower/Tower_Range
@onready var projectile_generation_point: Projectile_Generator = $"Projectile Generation Point"

var Tower_Projectiles:Array[Projetil]
var Tower_Database: Array[Tower_Data] = []


func _ready() -> void:
	Load_Tower_Resource_Database("res://Scripts/3D/Tower/Data/")

			

func Load_Tower_Resource_Database(path:String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				var file_path = path.path_join(file_name)
				var resource = load(file_path)
				#print("Found file: " + file_name)
				Tower_Database.append(resource)
			file_name = dir.get_next()
			
	else:
		print("Failed to load resource: " + path)
	


func Inicializa_Torre_Pelo_Indice(idx:int, Team_Index: int):
	Tower_Index = idx #Usada para acessar e setar a malha do projetil
	if Tower_Index > 1 :
		projectile_generation_point.Tower_Index = 1
	else:
		projectile_generation_point.Tower_Index = idx
	
	var Tower_Data_Resource: Tower_Data = Tower_Database[idx]
	
	var Tower_Scene = load(Tower_Data_Resource.Tower_scene_path)#Carrega a PackedScene contendo a malha 3D
	var Correct_Tower_InstanceMesh3D = Tower_Scene.instantiate()#Ja que a Packed Scene so contem uma InstanceMesh3D, instancia-la carrega para uma variavel
	
	$Main_Tower.mesh = Correct_Tower_InstanceMesh3D.mesh
	
	#Troca a cor, dependendo do time
	if Team_Index == 1:
		$Main_Tower.get_active_material(0).set_albedo(Color(1,0,0,1))
	else:
		$Main_Tower.get_active_material(0).set_albedo(Color(0,0,1,1))
	print("PLS")
	
	Tower_Damage = Tower_Data_Resource.Tower_Damage
	projectile_generation_point.Tower_Damage = Tower_Damage#A inicializacao do projetil esta dentro deste objeto
	
	$Enemy_Detection_3D/CollisionShape3D.shape.set_radius(Tower_Data_Resource.Tower_Range)#O COLLISION SHAPE É O REAL RAIO DA TORRE
	#O TOWER_RANGE É O VISUALIZADOR DO RANGE
	$Main_Tower/Tower_Range.scale = Vector3(0.1*Tower_Data_Resource.Tower_Range,
											0.1*Tower_Data_Resource.Tower_Range,
											0.1*Tower_Data_Resource.Tower_Range)
	
	projectile_generation_point.set_cooldown_timer(Tower_Data_Resource.Tower_Attack_Cooldown)
	
func Zerar_o_Tower_Range():
		tower_range.scale = TOWER_RANGE_ZEROED_SCALE
	
func Show_Tower_Range_When_Hovered():
	var Novo_Raio = collision_shape_3d.shape.get_radius()

	tower_range.scale = Vector3(TOWER_RANGE_VISUAL_SCALE_FACTOR*Novo_Raio,
								TOWER_RANGE_VISUAL_SCALE_FACTOR*Novo_Raio,
								TOWER_RANGE_VISUAL_SCALE_FACTOR*Novo_Raio)

func _process(delta: float) -> void:
	if Possible_Targets.size() > 0:
		projectile_generation_point.can_I_shoot = true
		projectile_generation_point.Array_of_Targets = Possible_Targets
		for Target in Possible_Targets:
				if Target:
					tower_aim.global_position = Target.global_position
					tower_aim.rotation.y += 1.25 * delta
					break
		tower_aim.global_position.y += 3

	else:
		projectile_generation_point.can_I_shoot = false
		tower_aim.global_position = main_tower.global_position
	
	if projectile_generation_point.List_of_Projectiles.size() > 32:
		projectile_generation_point.Clean_Up_Projectile_Array()

func _on_enemy_detection_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.append(body)

func _on_enemy_detection_3d_body_exited(body: Node3D) -> void:
	if body is Moving_Units:
		Possible_Targets.remove_at(0)
