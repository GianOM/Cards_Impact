extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected


#LobbyMultiplayer.List_of_Players RETORNA O ID
#Exemplo de variavel LobbyMultiplayer.List_of_Players[n]:
#for n in LobbyMultiplayer.List_of_Players:
#LobbyMultiplayer.List_of_Players[n] = { "name": 1, "is_Player_Ready": false }
#
#---------------
#LobbyMultiplayer.List_of_Players[n] = { "name": "892482740", "is_Player_Ready": false }
#---------------

@export var app_id : String = "480"


var List_of_Players = {}

var Player_Basic_Info = {"name": "NAME","is_Player_Ready": false}



#----------------------STEAM------------------------------------

signal on_steam_lobby_created


var Steam_ID
var Steam_UserName

var Steam_Lobby_ID:int

var Steam_Peer: SteamMultiplayerPeer


	
func _process(delta: float) -> void:
	Steam.run_callbacks()



func Local_Signals_Init():
		#Conecta os sinais para caso algum Peer se Conecte ou Desconecte
	multiplayer.peer_connected.connect(_New_Player_Connected)
	multiplayer.peer_disconnected.connect(_Player_Disconnected)
	
	#Conecta o Sinal para caso alguem consiga se conectar ao servidor
	multiplayer.connected_to_server.connect(_Player_Connected_Sucessfully)
	
	#Conecta os Sinais para caso alguem nao consiga se conectar ou entao
	#
	multiplayer.connection_failed.connect(_Connection_Failed)
	multiplayer.server_disconnected.connect(_Server_Disconnected)
	


func Create_Multiplayer_Game():
	#Cria um novo Peer e seta ele como servidor
	var Basic_Peer = ENetMultiplayerPeer.new()
	
	Basic_Peer.create_server(7000,2)#Numero da Porta (7000) e o numero maximo de players(2)
	multiplayer.multiplayer_peer = Basic_Peer
	
	List_of_Players[1] = Player_Basic_Info#Captura informacoes basicas sobre o Host
	
	List_of_Players[1].name = 1#Atualiza o nome do host para ser o seu ID, neste caso 1
	
	player_connected.emit(1, Player_Basic_Info)
	
	
	
	print("Host Created. List of Players: ")
	print(List_of_Players)
	
	
	
	
func Join_Multiplayer_Game():
	#Cria um Peer e seta ele como Client
	var ClientPeer = ENetMultiplayerPeer.new()
	ClientPeer.create_client("localhost", 7000)#No futuro, substituir "localhost" por um IP gerado pelo UPnP(video com tutorial no ClickUp)
	
	multiplayer.multiplayer_peer = ClientPeer 

	
func _New_Player_Connected(id):
	print("Registrando Player %d na Database" % id)
	_register_player.rpc_id(id, Player_Basic_Info)
	print(List_of_Players)
	
@rpc("any_peer","reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	List_of_Players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	
	print(List_of_Players)
	
func _Player_Disconnected(id):
	List_of_Players.erase(id)
	player_disconnected.emit(id)

func _Player_Connected_Sucessfully():
	#Pega a informacao basica sobre o Player se ele conectar 
	var peer_id = multiplayer.get_unique_id()
	List_of_Players[peer_id] = Player_Basic_Info
	List_of_Players[peer_id].name = str(peer_id)#Atualiza o nome do novo peer para ser o seu ID
	player_connected.emit(peer_id, Player_Basic_Info)
	
func _Connection_Failed():
	#Setar o player como null apaga ele
	multiplayer.multiplayer_peer = null
	
func _Server_Disconnected():
	#Servidor desligou
	multiplayer.multiplayer_peer = null
	List_of_Players.clear()
	server_disconnected.emit()
	
	
	
func initialize_steam() -> void:
	
	#Quando lancar na steam, soltar o app_id
	
	OS.set_environment("SteamAppId", app_id)
	OS.set_environment("SteamGameId", app_id)
	
	var initialize_response: Dictionary = Steam.steamInitEx()
	
	if initialize_response["status"] == 0:
		print_rich("[color=green]Steam Is Running![/color]")
		
	elif initialize_response['status'] > 0:
		print_rich("[color=red]Failed to initialize Steam [/color] | Shutting Down: %s" % initialize_response)
		get_tree().quit()
		
	if !Steam.isSubscribed(): 
		get_tree().quit()
	else:
		Steam_ID = Steam.getSteamID()
		Steam_UserName = Steam.getPersonaName()
		print_rich("[color=red]Username: %s of Steam ID: %s[/color]" % [Steam_UserName, Steam_ID])
		
		
	Steam.lobby_created.connect(_on_steam_lobby_created.bind())
	
	multiplayer.peer_connected.connect(self._player_Steam_connected)
	#multiplayer.peer_disconnected.connect(self._player_disconnected)
	
	
	
# Callback from SceneTree.
func _player_Steam_connected(id):
	# Registration of a client beings here, tell the connected player that we are here.
	register_Steam_player.rpc_id(id, Steam_UserName)
	
@rpc("any_peer","reliable","call_local")
func register_Steam_player(My_Steam_Username):
	var id = multiplayer.get_remote_sender_id()
	
	List_of_Players[id] = Player_Basic_Info#Captura informacoes basicas sobre o Host
	
	List_of_Players[id].name = My_Steam_Username#Atualiza o nome do host para ser o seu ID, neste caso 1
	
	player_connected.emit(id, Player_Basic_Info)
	
	print(List_of_Players)
	
	
func _on_steam_lobby_created(connected, id):
		if connected:
			var Steam_Lobby_ID = id
			
			Steam.setLobbyData(id, "name", "CImpact")
			#Steam.setLobbyData(id, "mode", "CoOP")
			Steam.setLobbyJoinable(id, true)
			
			_create_host()
			
			print("Lobby id: " + str(id))
			
			#Seu eu for o Host, o meu Unique ID continua como 1, mesmo usando a Steam API
			#Rgistra o Player manualmente no List of Players, ja que nao e possivel chamar a funcao
			List_of_Players[multiplayer.get_unique_id()] = Player_Basic_Info#Captura informacoes basicas sobre o Host
			List_of_Players[multiplayer.get_unique_id()].name = Steam_UserName#Atualiza o nome do host para ser o seu ID, neste caso 1
			
			player_connected.emit(1, Player_Basic_Info)
			
			
			print("List of Players: ")
			print(List_of_Players)
			
			
			#_player_connected(multiplayer.get_unique_id())
			#_New_Player_Connected(1)
			
			
func _create_host():
	Steam_Peer = SteamMultiplayerPeer.new()
	var error = Steam_Peer.create_host(0)
	#multiplayer.set_multiplayer_peer(Steam_Peer)
	if error == OK:
		multiplayer.set_multiplayer_peer(Steam_Peer)
		if not OS.has_feature("dedicated_server"):
			#_New_Player_Connected(1)
			print("Lobby created sucessfully")
	else:
		print(error)
		
func create_Steam_Lobby():
	
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC,2)
	
	
	
func join_game(lobby_id = 0):
	Steam_Peer = SteamMultiplayerPeer.new()
	Steam.lobby_joined.connect(_on_lobby_joined.bind())
	#print("Connecting Player %s" % Steam_UserName)
	print("Entering lobby_id %d of %s" % [lobby_id, Steam_UserName])
	Steam.joinLobby(int(lobby_id))
	
	
func _on_lobby_joined(lobby: int, permissions: int, locked: bool, response: int) -> void:
	
	print("New Player Entering")
	
	if response == 1:
		var id = Steam.getLobbyOwner(lobby)
		if id != Steam.getSteamID():
			print("Connecting client to socket...")
			connect_socket(id)
			
		else:
		# Get the failure reason
			var FAIL_REASON: String
			match response:
				2:  FAIL_REASON = "This lobby no longer exists."
				3:  FAIL_REASON = "You don't have permission to join this lobby."
				4:  FAIL_REASON = "The lobby is now full."
				5:  FAIL_REASON = "Uh... something unexpected happened!"
				6:  FAIL_REASON = "You are banned from this lobby."
				7:  FAIL_REASON = "You cannot join due to having a limited account."
				8:  FAIL_REASON = "This lobby is locked or disabled."
				9:  FAIL_REASON = "This lobby is community locked."
				10: FAIL_REASON = "A user in the lobby has blocked you from joining."
				11: FAIL_REASON = "A user you have blocked is in the lobby."
			
	print("Resposta do servidor %d" % response)
			
func connect_socket(steam_id: int):
	var error = Steam_Peer.create_client(steam_id, 0)
	if error == OK:
		print("Connecting peer to host...")
		multiplayer.set_multiplayer_peer(Steam_Peer)
	else:
		print("Error creating client: %s" % str(error))
	
	
func Steam_get_lobby_list() -> void:
	#LOBBY_DISTANCE_FILTER_CLOSE = 0
	#LOBBY_DISTANCE_FILTER_DEFAULT = 1
	#LOBBY_DISTANCE_FILTER_FAR = 2
	#LOBBY_DISTANCE_FILTER_WORLDWIDE = 3
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_FAR)
	Steam.addRequestLobbyListStringFilter("name", "CImpact", Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()
