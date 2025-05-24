class_name Enemy_Spawner
extends MeshInstance3D

@onready var path_area_3d: Area3D = $".."

@rpc("any_peer","call_local","reliable")
func Adcionar_Tropa_Ao_Enemy_Spawner(INDEX: int):
	#path_area_3d.Adcionar_Tropa_Ao_Enemy_Spawner(INDEX)
	if ReadyButton.I_AM_READY == false:
		path_area_3d.rpc("Adcionar_Tropa_Ao_Enemy_Spawner",INDEX)
	elif ReadyButton.I_AM_READY == true:
		print("Voce nao pode colocar tropas apos a fase de preparacao")
