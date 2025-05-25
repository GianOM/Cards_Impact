extends MeshInstance3D

const TOWERS_DATABASE = preload("res://Scenes/3D/Towers/Towers_Database.tscn")


@onready var collision_shape_3d: CollisionShape3D = $"../Enemy_Detection_3D/CollisionShape3D"
@onready var tower_range: MeshInstance3D = $Tower_Range

@export var Tower_Database: Array[Tower_Data] = []

@onready var bullet_spawner: Timer = $"../Bullet Spawner"

#0.5 Radius esta para 1.0 Scale do Tower_Range Mesh Instance
func seleciona_mesh_pelo_indice(index:int):
	
	var Tower_Data_Resource: Tower_Data = Tower_Database[index]
	
	
	var Tower_Scene = load(Tower_Data_Resource.Tower_scene_path)#Carrega a PackedScene contendo a malha 3D
	var Correct_Tower_InstanceMesh3D = Tower_Scene.instantiate()#Ja que a Packed Scene so contem uma InstanceMesh3D, instancia-la carrega para uma variavel
	
	mesh = Correct_Tower_InstanceMesh3D.mesh
	
	
	collision_shape_3d.shape.set_radius(Tower_Data_Resource.Tower_Range)#O COLLISION SHAPE É O REAL RAIO DA TORRE
	#O TOWER_RANGE É O VISUALIZADOR DO RANGE
	tower_range.scale = Vector3(0.1*Tower_Data_Resource.Tower_Range,
								0.1*Tower_Data_Resource.Tower_Range,
								0.1*Tower_Data_Resource.Tower_Range)
	
	
	
	bullet_spawner.set_wait_time(Tower_Data_Resource.Tower_Attack_Cooldown)
	
	
