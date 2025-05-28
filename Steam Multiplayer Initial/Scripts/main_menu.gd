extends Node

@onready var control: Control = $Control
@onready var canvas_layer: CanvasLayer = $Control/CanvasLayer

@onready var level_spawner: Node = $"Level Spawner"

const MAIN = preload("res://Scenes/Main.tscn")

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_Connected_To_Server_Sucessfully)
	
func _on_play_pressed() -> void:
	Hide_Main_Menu.rpc()#Chama a funcao no modo RPC para garantir que todos os clientes escondam o menu
	#Hide_Main_Menu()
	change_level_to_play.call_deferred()
	#SceneSwitcher.switch_scene("res://Scenes/Main.tscn")
	
@rpc("authority","call_local","reliable")
func Hide_Main_Menu():
	#Hide garante que ele nao sera clickavel
	control.hide()#Esconde os botoes e as fotos
	canvas_layer.hide()#Esconde o Titulo e Subtitulo
	
func change_level_to_play():
	#O Host deve apertar o botao de play criando uma instancia do level a ser colocado dentro do node
	#Level Spawener. O Multiplayer Spawner garante que ele sera replicado para todos os outros players
	level_spawner.add_child(MAIN.instantiate())
	
	
func _on_exit_pressed() -> void:
	get_tree().quit()

	
func _on_connection_failed():
	print("Conection Failed")
	
func _Connected_To_Server_Sucessfully():
	print("CONNECTED")
