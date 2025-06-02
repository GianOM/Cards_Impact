extends HBoxContainer


func Initialize_Second_Player():
	$"HBoxContainer/Player Name".text = str(LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].name)
	show()
	print("%d Acaba de se registrar" % multiplayer.get_unique_id())
	
	
	
#func Inicializa_Player_2_no_Host():
	#$"../Player_1_Stats_HBOX".rpc("Inicializar_o_Player_2")
	#$"../Player_1_Stats_HBOX/HBoxContainer/Player Name".text = LobbyMultiplayer.List_of_Players[1].name
	#
	
	
	
@rpc("any_peer", "reliable")
func Player_2_Inicializa_o_Host():
	$"../Player_1_Stats_HBOX/HBoxContainer/Player Name".text = LobbyMultiplayer.List_of_Players[1].name
	$"HBoxContainer/Player Name".text = str(LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].name)
	
	
	
	
	
	
	
