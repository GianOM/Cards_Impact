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

# Steam Lobby Filtering
var current_filters = {
	"name": "",
	"max_players": 0,
	"has_password": false,
	"friends_only": false,
	"distance": Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE
}

# Distance filter options
const DISTANCE_FILTERS = {
	"Worldwide": Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE,
	"Close": Steam.LOBBY_DISTANCE_FILTER_CLOSE,
	"Far": Steam.LOBBY_DISTANCE_FILTER_FAR,
}

const LOBBY_TYPES = {
	"PUBLIC": Steam.LOBBY_TYPE_PUBLIC,
	"FRIENDS_ONLY": Steam.LOBBY_TYPE_FRIENDS_ONLY,
	"PRIVATE": Steam.LOBBY_TYPE_PRIVATE
}


func _ready() -> void:
	#Conecta os sinais para caso algum Peer se Conecte ou Desconecte
	multiplayer.peer_connected.connect(_New_Player_Connected)
	multiplayer.peer_disconnected.connect(_Player_Disconnected)
	
	#Conecta o Sinal para caso alguem consiga se conectar ao servidor
	multiplayer.connected_to_server.connect(_Player_Connected_Sucessfully)
	
	#Conecta os Sinais para caso alguem nao consiga se conectar ou entao
	#
	multiplayer.connection_failed.connect(_Connection_Failed)
	multiplayer.server_disconnected.connect(_Server_Disconnected)
	
	
	#Steam Setup
	
	Steam.lobby_created.connect(_on_Steam_Lobby_created.bind())
	
	
func _process(delta: float) -> void:
	Steam.run_callbacks()

func Create_Multiplayer_Game():
	
	#Cria um novo Peer e seta ele como servidor
	var Basic_Peer = ENetMultiplayerPeer.new()
	
	Basic_Peer.create_server(7000,2)#Numero da Porta (7000) e o numero maximo de players(2)
	multiplayer.multiplayer_peer = Basic_Peer
	
	List_of_Players[1] = Player_Basic_Info#Captura informacoes basicas sobre o Host
	
	List_of_Players[1].name = 1#Atualiza o nome do host para ser o seu ID, neste caso 1
	
	player_connected.emit(1, Player_Basic_Info)
	
	
	
	print("Host Created")
	
	
	
	
func Join_Multiplayer_Game():
	#Cria um Peer e seta ele como Client
	var ClientPeer = ENetMultiplayerPeer.new()
	ClientPeer.create_client("localhost", 7000)#No futuro, substituir "localhost" por um IP gerado pelo UPnP(video com tutorial no ClickUp)
	
	multiplayer.multiplayer_peer = ClientPeer 

	
func _New_Player_Connected(id):
	_register_player.rpc_id(id, Player_Basic_Info)
	
@rpc("any_peer","reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	List_of_Players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	
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
		print(Steam_ID)
		print_rich("[color=red]%s[/color]" % Steam_UserName)
		
		
		
	Steam_Peer = SteamMultiplayerPeer.new()
	
	
	
	
func create_Steam_Lobby():
	var lobby_type = LOBBY_TYPES.PUBLIC
	
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC,2)
	
	multiplayer.multiplayer_peer = Steam_Peer
	
	
	
func _on_Steam_Lobby_created(connected, id):
	if connected:
		Steam_Lobby_ID = id
		
		# Set basic lobby data
		#update_lobby_name()  # Set initial name with player count
		#Steam.setLobbyData(steam_lobby_id, "max_players", str(host_max_players.value))
		#
		## Set password protection status
		#if host_password_protected.button_pressed:
			#Steam.setLobbyData(steam_lobby_id, "has_password", "1")
			#Steam.setLobbyData(steam_lobby_id, "password", host_password_input.text)
		#else:
			#Steam.setLobbyData(steam_lobby_id, "has_password", "0")
		#
		## Set member limit
		#Steam.setLobbyMemberLimit(steam_lobby_id, host_max_players.value)
		#
		## Make the lobby joinable
		#Steam.setLobbyJoinable(steam_lobby_id, true)
		#
		#print(steam_lobby_id, " Running")


func Refresh_Lobby_List() -> void:
	pass
	
func Steam_get_lobby_list() -> void:
	#LOBBY_DISTANCE_FILTER_CLOSE = 0
	#LOBBY_DISTANCE_FILTER_DEFAULT = 1
	#LOBBY_DISTANCE_FILTER_FAR = 2
	#LOBBY_DISTANCE_FILTER_WORLDWIDE = 3
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
