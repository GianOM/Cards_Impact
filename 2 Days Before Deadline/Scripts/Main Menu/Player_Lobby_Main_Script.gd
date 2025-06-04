extends VBoxContainer

#Player 1 Variables
@onready var player_name: Label = $"../Players Name VBOX/Player1 Name"
@onready var player_civilization: Label = $"../Players Civilizations VBOX/Player1 Civilization"
@onready var player_status: Label = $"../Players Status VBOX/Player1 Status"

#Player 2 Variables
@onready var player_2_name: Label = $"../Players Name VBOX/Player2 Name"
@onready var player_2_civilization: Label = $"../Players Civilizations VBOX/Player2 Civilization"
@onready var player_2_status: Label = $"../Players Status VBOX/Player2 Status2"

#This is...fine...for two players. For more, need to improve this
#Chamada a por sinais conectados no main_menu.gd
func Refresh_Player_Lobby_List():
	for Jogador in LobbyMultiplayer.List_of_Players:
		if Jogador == 1:
			player_name.text = LobbyMultiplayer.List_of_Players[Jogador].name
			print("Temos o nosso ADM AQUI")
		else:
			$"../Players Name VBOX/Player2 Name".show()
			$"../Players Civilizations VBOX/Player2 Civilization".show()
			$"../Players Status VBOX/Player2 Status2".show()
			
			$"../../../../CanvasLayer/Lobby Ready Button".show()
			player_2_name.text = LobbyMultiplayer.List_of_Players[Jogador].name
			print("Temos o nosso Client aqui")
			
func Update_Status_Text(Id_to_Update:int, Status_to_Update:bool):
	if Status_to_Update == true:
		if Id_to_Update == 1:
			player_status.text = "Ready"
		else:
			player_2_status.text = "Ready"
	elif Status_to_Update == false:
		if Id_to_Update == 1:
			player_status.text = "Not Ready"
		else:
			player_2_status.text = "Not Ready"
