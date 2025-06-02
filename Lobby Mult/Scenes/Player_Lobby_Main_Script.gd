extends VBoxContainer

#Player 1 Variables
@onready var player_name: Label = $"Player_1_Stats_HBOX/HBoxContainer/Player Name"
@onready var player_civilization: Label = $"Player_1_Stats_HBOX/HBoxContainer/Player Civilization"
@onready var player_status: Label = $"Player_1_Stats_HBOX/HBoxContainer/Player Status"

#Player 2 Variables
@onready var player_2_name: Label = $"Player_2_Stats_HBOX/HBoxContainer/Player Name"
@onready var player_2_civilization: Label = $"Player_2_Stats_HBOX/HBoxContainer/Player Civilization"
@onready var player_2_status: Label = $"Player_2_Stats_HBOX/HBoxContainer/Player Status"


func Refresh_Player_Lobby_List():
	for Jogador in LobbyMultiplayer.List_of_Players:
		if Jogador == 1:
			player_name.text = LobbyMultiplayer.List_of_Players[Jogador].name
			print("Temos o nosso ADM AQUI")
		else:
			$Player_2_Stats_HBOX.show()
			player_2_name.text = LobbyMultiplayer.List_of_Players[Jogador].name
			print("Temos o nosso Client aqui")
