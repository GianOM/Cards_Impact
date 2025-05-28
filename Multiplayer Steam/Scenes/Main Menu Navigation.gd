extends Control





func _on_multiplayer_selected():
	Hide_All_Menus()
	$"Multiplayer Local or Steam".show()



func _on_public_multiplayer_clicked():
	Hide_All_Menus()
	$CanvasLayer/Title.hide()
	$"Public Multiplayer".show()
	LobbyMultiplayer.initialize_steam()

func _on_public_multiplayer_host_clicked():
	Hide_All_Menus()
	print("Voce agora esta hosteando um servido da Staem")
	
	
func _on_public_multiplayer_join_clicked():
	Hide_All_Menus()
	
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	LobbyMultiplayer.Steam_get_lobby_list()
	

func _on_lobby_match_list(lobbies: Array):
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		if lobby_name != "":
			print(lobby_name)
	

func _on_local_multiplayer_clicked():
	Hide_All_Menus()
	$"Local Multiplayer".show()

func _on_local_multiplayer_host():
	Hide_All_Menus()
	LobbyMultiplayer.Create_Multiplayer_Game()

func _on_local_multiplayer_join():
	Hide_All_Menus()
	LobbyMultiplayer.Join_Multiplayer_Game()
	print("Conecting...")

func _on_back_to_Start_menu_clicked():
	Hide_All_Menus()
	$"Single Or Multiplayer".show()
	
	
	
func Hide_All_Menus():
	$"Single Or Multiplayer".hide()
	$"Multiplayer Local or Steam".hide()
	$"Local Multiplayer".hide()
	$"Public Multiplayer".hide()
