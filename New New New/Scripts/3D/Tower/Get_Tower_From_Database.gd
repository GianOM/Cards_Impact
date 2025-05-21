extends MeshInstance3D

const TOWERS_DATABASE = preload("res://Scenes/3D/Towers/Towers_Database.tscn")

@onready var Dados_da_Torre: Tower_Data = preload("res://Scripts/3D/Tower/Tower_Properties_Example.tres")

@onready var collision_shape_3d: CollisionShape3D = $"../Enemy_Detection_3D/CollisionShape3D"
@onready var tower_range: MeshInstance3D = $Tower_Range


@onready var bullet_spawner: Timer = $"../Bullet Spawner"

#0.5 Radius esta para 1.0 Scale do Tower_Range Mesh Instance

func seleciona_mesh_pelo_indice(index:int):
	Dados_da_Torre.Set_Mesh_Based_on_ID(index)
	
	collision_shape_3d.shape.set_radius(Dados_da_Torre.Tower_Range)#O COLLISION SHAPE É O REAL RAIO DA TORRE
	#O TOWER_RANGE É O VISUALIZADOR DO RANGE
	tower_range.scale = Vector3(2*Dados_da_Torre.Tower_Range,
								2*Dados_da_Torre.Tower_Range,
								2*Dados_da_Torre.Tower_Range)
	mesh = Dados_da_Torre.Tower_3d_Mesh.mesh
	
	bullet_spawner.set_wait_time(Dados_da_Torre.Tower_Attack_Cooldown)
	
	
