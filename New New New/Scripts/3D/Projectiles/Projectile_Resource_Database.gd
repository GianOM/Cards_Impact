class_name Projectile_Data
extends Resource

var Projectile_Name : String
var Projectile_Speed : float
var Projectile_Damage: float
var Mesh_3D: MeshInstance3D



const PROJECTILE_PROPERTIES = {
	0: {"name": "Pointy 1", "damage": 1.0,"Speed": 5, "node_path": "Tower_Projectile_Tier_1"},
	1: {"name": "Pointy 1", "damage": 2.0,"Speed": 10.0, "node_path": "Tower_Projectile_Tier_2"},
	#Propriedades das Torres
}

func Set_Projectile_Mesh_Based_on_ID(idx:int):
	if PROJECTILE_PROPERTIES.has(idx):
		const PROJECTILE_DATABASE = preload("res://Scenes/3D/Projectile/Projectile_Database.tscn")
		var database_instance = PROJECTILE_DATABASE.instantiate()
		
		Mesh_3D = database_instance.get_node(PROJECTILE_PROPERTIES[idx].node_path)
		
		Projectile_Name = PROJECTILE_PROPERTIES[idx].name
		Projectile_Damage = PROJECTILE_PROPERTIES[idx].damage
		Projectile_Speed = PROJECTILE_PROPERTIES[idx].Speed
		
	else:
		print("Invalid Projectile Index")
