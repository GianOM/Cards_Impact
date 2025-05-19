class_name Tower_Data
extends Resource

@export var Tower_Name : String
@export var Tower_Range : float
@export var Tower_Index: int
var Tower_3d_Mesh: MeshInstance3D

func Set_Mesh_Based_on_ID(i:int):
	const TOWERS_DATABASE = preload("res://Scenes/3D/Towers/Towers_Database.tscn")
	var database_instance = TOWERS_DATABASE.instantiate()
	var tower_tier = database_instance.get_node("Tower_Tier_1")
	
	if i == 0:
		Tower_3d_Mesh = tower_tier
		Tower_Range = 0.5
		Tower_Name = "ROOK_TOWER"
	elif i == 1:
		tower_tier = database_instance.get_node("Tower_Tier_2")
		Tower_3d_Mesh = tower_tier
		Tower_Range = 1
		Tower_Name = "QUEEN_TOWER"
