extends Node3D

@onready var main_2d: Node2D = $Main2D
@export var players_containers: Node3D
const PLAYER_CAMERA_SCENE = preload("res://Scenes/Player Camera Scene.tscn")
@onready var label: Label = $Control/Label

func _ready() -> void:
	if not multiplayer.is_server():#Somente o servidor spawna 2 tropas
		return
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)
	
	for id in multiplayer.get_peers():
		add_player(id, true)#Roda 1 vez para cada player
		
	add_player(1,false)#adciona o Host
	
	
func _process(delta: float) -> void:
	label.text = "my id is: " + str(multiplayer.get_unique_id())
	
func add_player(id:int, player2:bool):
	var New_Player = PLAYER_CAMERA_SCENE.instantiate()
	New_Player.name = str(id)
	players_containers.add_child(New_Player)
	 
func _exit_tree() -> void:
	if not multiplayer.is_server():
		return
	multiplayer.peer_disconnected.disconnect(delete_player)
	
func delete_player(id):
	if not players_containers.has_node(str(id)):
		return
	players_containers.get_node(str(id)).queue_free() #Laga o game
	
func hideUI():
	
	main_2d.set_process_mode(Node.PROCESS_MODE_DISABLED)
	main_2d.visible = false
	
func showUI():
	main_2d.set_process_mode(Node.PROCESS_MODE_INHERIT)
	main_2d.visible = true
	
var ui_visible: bool = false

func _input(_event):
	if Input.is_action_just_pressed("hide_ui"): #just_pressed triggers only once
		if ui_visible == false:
			ui_visible = true
			
			hideUI()
		else:
			ui_visible = false
			showUI()
			
	if Input.is_action_just_pressed("ESC") and ui_visible:
			ui_visible = false
			showUI()
		
		
		#elif Input.is_action_just_pressed("ESC") or ui_visible == true:
			#ui_visible = false
			#showUI()
			
		#else:
			#ui_visible = false
			#showUI()
		#if Input.is_action_just_pressed("ESC") and ui_visible:
			#showUI()
