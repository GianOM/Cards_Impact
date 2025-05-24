extends Node

@onready var control: Control = $Control
@onready var canvas_layer: CanvasLayer = $Control/CanvasLayer

@onready var level_spawner: Node = $"Level Spawner"

const MAIN = preload("res://Scenes/Main.tscn")

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_Connected_To_Server_Sucessfully)
	
func _on_play_pressed() -> void:
	Hide_Main_Menu.rpc()
	change_level_to_play.call_deferred()
	#SceneSwitcher.switch_scene("res://Scenes/Main.tscn")
	
@rpc("authority","call_local","reliable")
func Hide_Main_Menu():
	control.hide()
	canvas_layer.hide()
	
func change_level_to_play():
	level_spawner.add_child(MAIN.instantiate())
	
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func Host_Button_Apertado():
	LobbyMultiplayer.Create_Multiplayer_Game()
	
func Join_Button_Apertado():
	LobbyMultiplayer.Join_Multiplayer_Game()
	print("Conecting...")
	
func _on_connection_failed():
	print("Conection Failed")
	
func _Connected_To_Server_Sucessfully():
	print("CONNECTED")
