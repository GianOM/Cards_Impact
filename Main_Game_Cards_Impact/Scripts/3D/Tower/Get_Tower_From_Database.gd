extends MeshInstance3D

const TOWERS_DATABASE = preload("res://Scenes/3D/Towers/Towers_Databese.tscn")


@onready var collision_shape_3d: CollisionShape3D = $"../Enemy_Detection_3D/CollisionShape3D"
@onready var tower_range: MeshInstance3D = $"../Enemy_Detection_3D/Tower_Range"

#0.5 Radius esta para 1.0 Scale do Tower_Range Mesh Instance

func set_tier_1_Mesh():
	var database_instance = TOWERS_DATABASE.instantiate()
	var tower_tier_1 = database_instance.get_node("Tower_Tier_1")
	collision_shape_3d.shape.set_radius(0.5)
	tower_range.scale = Vector3(1,1,1)
	mesh = tower_tier_1.mesh


func set_tier_2_Mesh():
	var database_instance = TOWERS_DATABASE.instantiate()
	var tower_tier_2 = database_instance.get_node("Tower_Tier_2")
	collision_shape_3d.shape.set_radius(1)
	tower_range.scale = Vector3(2,2,2)
	mesh = tower_tier_2.mesh
