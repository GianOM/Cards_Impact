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



var List_of_Players = {}

var Player_Basic_Info = {"name": "NAME","is_Player_Ready": false}

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
	
	

func Create_Multiplayer_Game():
	
	#Cria um novo Peer e seta ele como servidor
	var Basic_Peer = ENetMultiplayerPeer.new()
	
	Basic_Peer.create_server(7000,2)#Numero da Porta (7000) e o numero maximo de players(2)
	multiplayer.multiplayer_peer = Basic_Peer
	
	List_of_Players[1] = Player_Basic_Info#Captura informacoes basicas sobre o Host
	
	List_of_Players[1].name = 1#Atualiza o nome do host para ser o seu ID, neste caso 1
	
	player_connected.emit(1, Player_Basic_Info)
	
	print("Host Created")
	
	Teste_UPNP()
	
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
	
	
	
	
	
	
	
	
	
	
	
	
	
func Teste_UPNP():
	var UPnP = UPNP.new()
	
	var discover_result = UPnP.discover()
	
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
							"UPNP Discover Failed! Error %s" % discover_result)
							
							
	#assert(UPnP.get_gateway() and UPnP.get_gateway().is_valid_gateway(), \
							#"UPNP Invalid Gateway")
							#
	#var map_result = UPnP.add_port_mapping(7777)
	#assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
			#"UPNP Port Mapping Failed! Error %s" % map_result)
			#
	#print("New IP is: %s" % UPnP.query_external_address())
	##print(discover_result)
	
	
	
	
