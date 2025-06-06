extends Control



signal on_steam_lobby_created

func _ready() -> void:
	LobbyMultiplayer.Terminou_de_Construir_o_Lobby.connect(Atualiza_a_List_de_Players_do_Lobby)
	LobbyMultiplayer.Player_2_Registrado_no_Host.connect(Atualiza_a_List_de_Players_do_Lobby)


func _on_multiplayer_selected():
	Hide_All_Menus()
	$"CanvasLayer/Back to Start Menu Button".show()
	$"Multiplayer Local or Steam".show()

# ----------- STEAM MULTIPLAYER ----------------------

func _on_public_multiplayer_clicked():
	Hide_All_Menus()
	$CanvasLayer/Title.hide()
	$"Public Multiplayer".show()
	LobbyMultiplayer.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)

func _on_public_multiplayer_host_clicked():
	Hide_All_Menus()
	print("Started to create a Lobby")
	LobbyMultiplayer.create_Steam_Lobby()
	on_steam_lobby_created.emit()
	#$"Public Multiplayer Lobby".show()
	#$"Public Multiplayer Lobby/VBoxContainer/Players List Panel/VBoxContainer/Player_1_Stats_HBOX".Host_Initialize_Lobby()
	
	
#A funcao abaixo nomeia o Player_1_Stats_HBox com o nome do player
func Terminei_de_Construir_o_Lobby():
	$"Public Multiplayer Lobby".show()
	$"Public Multiplayer Lobby/VBoxContainer/Players List Panel/VBoxContainer/Player_1_Stats_HBOX".Host_Initialize_Lobby()
	
	
func Inicializar_Player_2():
	$"Public Multiplayer Lobby/VBoxContainer/Players List Panel/VBoxContainer/Player_2_Stats_HBOX".Initialize_Second_Player()
	
	
func Atualiza_a_List_de_Players_do_Lobby():
	$"Public Multiplayer Lobby".show()
	$"Public Multiplayer Lobby/VBoxContainer/Players List Panel/VBoxContainer".Refresh_Player_Lobby_List()
	
	
	
	
	
	
	
	
	
	
	
	
func _on_public_multiplayer_join_clicked():
	print("Clickou em Join")
	
	
func refresh_lobby_list():
	#Limpa os botoes anteriores
	for lobby in $"Public Multiplayer/Panel/ScrollContainer/VBoxContainer".get_children():
		lobby.queue_free()
	LobbyMultiplayer.Steam_get_lobby_list()
	

func _on_lobby_match_list(lobbies: Array):
	for lobby in lobbies:
		var lobby_name: String = Steam.getLobbyData(lobby, "name")
		if lobby_name != "":
			create_lobby_button(lobby_name,lobby)

func create_lobby_button(Lobby_Name: String, Lobby_ID: int):
	var Novo_Botao = Button.new()
	Novo_Botao.set_text(Lobby_Name)
	$"Public Multiplayer/Panel/ScrollContainer/VBoxContainer".add_child(Novo_Botao)
	
	Novo_Botao.connect("pressed", Callable(self, "join_lobby").bind(Lobby_ID))

func join_lobby(lobby_id = 0):
	print("Joining lobby %s" % lobby_id)
	LobbyMultiplayer.join_game(lobby_id)

# ----------- LOCAL MULTIPLAYER ----------------------

func _on_local_multiplayer_clicked():
	Hide_All_Menus()
	$"Local Multiplayer".show()
	LobbyMultiplayer.Local_Signals_Init()

func _on_local_multiplayer_host():
	Hide_All_Menus()
	LobbyMultiplayer.Create_Multiplayer_Game()

func _on_local_multiplayer_join():
	Hide_All_Menus()
	LobbyMultiplayer.Join_Multiplayer_Game()
	print("Conecting...")
	$"Public Multiplayer Lobby".show()
	
	
	
	
	
	
	
	
	
	
	
	
	
func _on_back_to_Start_menu_clicked():
	Hide_All_Menus()
	$"Single Or Multiplayer".show()
	$"CanvasLayer/Back to Start Menu Button".hide()
	
	
func Hide_All_Menus():
	$"Single Or Multiplayer".hide()
	$"Multiplayer Local or Steam".hide()
	$"Local Multiplayer".hide()
	$"Public Multiplayer".hide()
	$"Public Multiplayer Lobby".hide()
	$"CanvasLayer/Lobby Ready Button".hide()
	#$"CanvasLayer/Back to Start Menu Button".hide()
