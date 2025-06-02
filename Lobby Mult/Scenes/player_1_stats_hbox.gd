extends HBoxContainer

	
func Host_Initialize_Lobby() -> void:
	$"HBoxContainer/Player Name".text = str(LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].name)
	
	
func Inicializa_Player_2_no_Host(Player_2_ID: int):
	$"../Player_2_Stats_HBOX".show()
	$"../Player_2_Stats_HBOX/HBoxContainer/Player Name".text = LobbyMultiplayer.List_of_Players[Player_2_ID].name
	#$"../Player_2_Stats_HBOX".Player_2_Inicializa_o_Host.rpc_id(Player_2_ID)
