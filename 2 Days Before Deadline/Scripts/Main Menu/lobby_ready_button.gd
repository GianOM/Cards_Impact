extends Button

@onready var v_box_container: VBoxContainer = $"../../Public Multiplayer Lobby/VBoxContainer/Players List Panel/VBoxContainer"


func is_everyone_ready() -> bool:
	#Checka se todo mundo ta ready iterando pela lista de players que é
	#Atualizada pelo Ready_Button.gd
	for player in LobbyMultiplayer.List_of_Players:
		if LobbyMultiplayer.List_of_Players[player].is_Player_Ready == false:
			return false
	return true



func _on_toggled(_toggled_on: bool) -> void:
	if LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready == false:
		
		LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready = true
		v_box_container.Update_Status_Text(multiplayer.get_unique_id(), true)
		Update_Ready_Status.rpc(true)
		
	elif LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready == true:
		
		LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready = false
		v_box_container.Update_Status_Text(multiplayer.get_unique_id(), false)
		Update_Ready_Status.rpc(false)
		
	print("Fui apertado pelo %d" % multiplayer.get_unique_id())
	print(LobbyMultiplayer.List_of_Players)
	
@rpc("any_peer","call_remote","reliable")
func Update_Ready_Status(ready_status: bool):
	LobbyMultiplayer.List_of_Players[multiplayer.get_remote_sender_id()].is_Player_Ready = ready_status
	v_box_container.Update_Status_Text(multiplayer.get_remote_sender_id(), ready_status)
