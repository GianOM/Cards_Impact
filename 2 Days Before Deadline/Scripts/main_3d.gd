extends Node3D

@export var players_containers: Node3D
const PLAYER_CAMERA_SCENE = preload("res://Scenes/Player/Player Camera Scene.tscn")
@onready var ready_status: Label = $"Control/Ready Status"
@onready var testing_ui: Control = $TestingUI

var ui_visible: bool = false

func _ready() -> void:
	#Somente o servidor spawna 2 tropas assim que uma Instancia e colocada
	if not multiplayer.is_server():
		return
	
	#Conecta os sinais para peers conectados e desconectados
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)
	
	
	#Adciona um Player para cada peer existente. Isso porem nao adciona um player para o host.
	for id in multiplayer.get_peers():#get peers nao retorna o host
		add_player(id)#Roda 1 vez para cada player
		
		
	add_player(1)#Adciona um Player para o Host
	
func add_player(id:int):
	var New_Player = PLAYER_CAMERA_SCENE.instantiate()#Cria uma instancia da cena do Player
	New_Player.name = str(id)#Setamos o nome para ser o peer_unique_id
	
	#Adcionamos um Player a um Container contendo um Multiplayer Spawner para ser replicado
	#aos outros Peers, dado que somente o Host adciona trop
	players_containers.add_child(New_Player)
	
	
func _process(_delta: float) -> void:
	#Seta os labels mostrando o Unique ID e o status de estar pronto ou nao
	ready_status.text = "ID: " + str(multiplayer.get_unique_id()) + " Status: " + str(CollisionCheck.I_AM_READY)
	#print(multiplayer.get_peers())
	 
func _exit_tree() -> void:
	if not multiplayer.is_server():
		return
	multiplayer.peer_disconnected.disconnect(delete_player)
	
func delete_player(id):
	if not players_containers.has_node(str(id)):
		return
	players_containers.get_node(str(id)).queue_free() #Laga o game
	
#func hideUI():
	#testing_ui.set_process_mode(Node.PROCESS_MODE_DISABLED)
	#testing_ui.visible = false
	#print("hide ui")
#func showUI():
	#testing_ui.set_process_mode(Node.PROCESS_MODE_INHERIT)
	#testing_ui.visible = true
	#print("show ui")
#
#
#func _input(_event):
	#if Input.is_action_just_pressed("hide_ui"): #just_pressed triggers only once
		#if ui_visible == false:
			#ui_visible = true
			#
			#hideUI()
		#else:
			#ui_visible = false
			#showUI()
			#
	#if Input.is_action_just_pressed("ESC") and ui_visible:
			#ui_visible = false
			#showUI()

func _input(_event):
	if Input.is_action_just_pressed("hide_ui"): #just_pressed triggers only once
		if ui_visible == false:
			ui_visible = true
			Events.hide_ui_requested.emit()
		else:
			ui_visible = false
			Events.show_ui_requested.emit()
			
	if Input.is_action_just_pressed("ESC") and ui_visible:
			ui_visible = false
			Events.show_ui_requested.emit()
