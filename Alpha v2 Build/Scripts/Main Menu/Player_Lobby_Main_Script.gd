extends VBoxContainer

#Player 1 Variables
@onready var player_name: Label = $"Player_1_Stats_HBOX/HBoxContainer/Player Name"
@onready var player_civilization: Label = $"Player_1_Stats_HBOX/HBoxContainer/Player Civilization"
@onready var player_status: Label = $"Player_1_Stats_HBOX/HBoxContainer/Player Status"

#Player 2 Variables
@onready var player_2_name: Label = $"Player_2_Stats_HBOX/HBoxContainer/Player Name"
@onready var player_2_civilization: Label = $"Player_2_Stats_HBOX/HBoxContainer/Player Civilization"
@onready var player_2_status: Label = $"Player_2_Stats_HBOX/HBoxContainer/Player Status"

#This is...fine...for two players. For more, need to improve this
#Chamada a por sinais conectados no main_menu.gd
func Refresh_Player_Lobby_List():
	for Jogador in LobbyMultiplayer.List_of_Players:
		if Jogador == 1:
			player_name.text = LobbyMultiplayer.List_of_Players[Jogador].name
			print("Temos o nosso ADM AQUI")
		else:
			$Player_2_Stats_HBOX.show()
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
