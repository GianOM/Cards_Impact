class_name Enemy_Spawner
extends MeshInstance3D

@onready var enemy_spawner_counter: Control = $SubViewport/EnemySpawnerCounter
@onready var path_area_3d: Area3D = $".."

var Troop_Spawner_Team: int

	

@rpc("any_peer","call_local","reliable")
func Adcionar_Tropa_Ao_Enemy_Spawner(INDEX: int, Troop_Quantity:int):
	if CollisionCheck.is_Shop_Time == false:
		path_area_3d.rpc("Adcionar_Tropa_Ao_Enemy_Spawner", INDEX, Troop_Quantity)
		
	elif CollisionCheck.is_Shop_Time == true:
		var msg := "[center]Voce nao pode colocar tropas durante o periodo de compras[/center]"
		SignalManager.emit_signal("warning_message", msg)
