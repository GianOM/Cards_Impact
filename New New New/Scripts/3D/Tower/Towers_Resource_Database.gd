class_name Tower_Data
extends Resource

@export var Tower_Name : String
@export var Tower_Range : float
@export var Tower_Index: int
var Tower_3d_Mesh: MeshInstance3D

const TOWER_PROPERTIES = {
	0: {"name": "ROOK_TOWER", "range": 0.5, "node_path": "Tower_Tier_1"},
	1: {"name": "QUEEN_TOWER", "range": 1.0, "node_path": "Tower_Tier_2"},
	#Propriedades das Torres
}

func Set_Mesh_Based_on_ID(idx:int):
	if TOWER_PROPERTIES.has(idx):
		const TOWERS_DATABASE = preload("res://Scenes/3D/Towers/Towers_Database.tscn")
		var database_instance = TOWERS_DATABASE.instantiate()
		
		Tower_Range = TOWER_PROPERTIES[idx].range
		Tower_Name = TOWER_PROPERTIES[idx].name
		Tower_3d_Mesh = database_instance.get_node(TOWER_PROPERTIES[idx].node_path)
	else:
		print("Invalid Tower Index")
