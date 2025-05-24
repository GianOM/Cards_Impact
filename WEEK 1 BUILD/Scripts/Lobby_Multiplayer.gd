extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

var List_of_Players = {}

var Player_Basic_Info = {"name": "NAME"}

func _ready() -> void:
	
	multiplayer.peer_connected.connect(_New_Player_Connected)
	multiplayer.peer_disconnected.connect(_Player_Disconnected)
	
	multiplayer.connected_to_server.connect(_Player_Connected_Sucessfully)
	
	multiplayer.connection_failed.connect(_Connection_Failed)
	multiplayer.server_disconnected.connect(_Server_Disconnected)
	
	

func Create_Multiplayer_Game():
	
	var Basic_Peer = ENetMultiplayerPeer.new()
	
	Basic_Peer.create_server(7000,2)
	multiplayer.multiplayer_peer = Basic_Peer
	
	List_of_Players[1] = Player_Basic_Info
	
	player_connected.emit(1, Player_Basic_Info)
	
	print("Host Created")
	
func Join_Multiplayer_Game():
	
	var ClientPeer = ENetMultiplayerPeer.new()
	ClientPeer.create_client("localhost", 7000)
	
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
	var peer_id = multiplayer.get_unique_id()
	List_of_Players[peer_id] = Player_Basic_Info
	player_connected.emit(peer_id, Player_Basic_Info)
	
func _Connection_Failed():
	multiplayer.multiplayer_peer = null
	
func _Server_Disconnected():
	#Servidor desligou
	multiplayer.multiplayer_peer = null
	List_of_Players.clear()
	server_disconnected.emit()
