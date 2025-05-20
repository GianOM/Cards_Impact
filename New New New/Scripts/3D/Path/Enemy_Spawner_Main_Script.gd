class_name Enemy_Spawner
extends MeshInstance3D

@onready var path_area_3d: Area3D = $".."

func Bota_Uma_Tropa_Ai_Chefe():
	path_area_3d.Adcionar_Tropa_Ao_Enemy_Spawner()
