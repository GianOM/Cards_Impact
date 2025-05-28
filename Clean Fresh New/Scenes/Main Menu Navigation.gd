extends Control





func _on_multiplayer_selected():
	Hide_All_Menus()
	$"Multiplayer Local or Steam".show()



func _on_public_multiplayer_clicked():
	Hide_All_Menus()
	$CanvasLayer/Title.hide()
	$"Public Multiplayer".show()
	LobbyMultiplayer.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)

func _on_public_multiplayer_host_clicked():
	Hide_All_Menus()
	print("Voce agora esta hosteando um servido da Staem")
	LobbyMultiplayer.create_Steam_Lobby()
	
	
func _on_public_multiplayer_join_clicked():
	print("Clickou em Join")
	

func _on_lobby_match_list(lobbies: Array):
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		if lobby_name != "":
			create_lobby_button(lobby_name)
			
func refresh_lobby_list():
	for lobby in $"Public Multiplayer/Panel/ScrollContainer/VBoxContainer".get_children():
		lobby.queue_free()
	LobbyMultiplayer.Steam_get_lobby_list()
	

func create_lobby_button(Lobby_Name: String):
	var Novo_Botao = Button.new()
	Novo_Botao.set_text(Lobby_Name)
	$"Public Multiplayer/Panel/ScrollContainer/VBoxContainer".add_child(Novo_Botao)



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
