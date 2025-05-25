extends Button

@export var I_AM_READY: bool = false

func _on_pressed() -> void:
	troca_o_estado_do_botao()
	#troca_o_estado_do_botao.rpc()
	#for p in LobbyMultiplayer.List_of_Players:
		#print(LobbyMultiplayer.List_of_Players[p])
		#print("---------------")
		#print(str(LobbyMultiplayer.List_of_Players[p].Player_Basic_Info.name))
		#print(str(LobbyMultiplayer.Player_Basic_Info[p].is_Player_Ready))


@rpc("any_peer", "call_local", "reliable")
func troca_o_estado_do_botao() ->  void:
	if ReadyButton.I_AM_READY == false:
		ReadyButton.I_AM_READY = true
		LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready = true
		Update_Ready_State.rpc(multiplayer.get_unique_id(), true)
	elif ReadyButton.I_AM_READY == true:
		ReadyButton.I_AM_READY = false
		LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready = false
		Update_Ready_State.rpc(multiplayer.get_unique_id(), false)
		
		
@rpc("any_peer", "call_local", "reliable")
func Update_Ready_State(sender_id: int, final_ready_state: bool) -> void:
	LobbyMultiplayer.List_of_Players[sender_id].is_Player_Ready = final_ready_state
	
