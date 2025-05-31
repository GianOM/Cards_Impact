extends Node

@warning_ignore("unused_signal")
signal refund_card(id_number: int)

var is_a_card_being_dragged: bool = false

var tower_was_placed := false
var troop_was_placed := false

var gaslight_income: float
var number_of_units: int
var card_id_number: int
#var card_id_number_refund: int
var turn_number: int

var card_id_attack: int
var card_id_defense: int
var card_deployed_past_turn: bool

var number_of_towers_placed: int = 0
var tower_placed = false

var I_AM_READY := false

#Variavel Global usada para saber se estamos no momento de Freeze
#Quando o Shop aparece
var is_Shop_Time = false


@rpc("any_peer", "call_local", "reliable")
func troca_o_estado_do_botao() ->  void:
	if I_AM_READY == false:
		I_AM_READY = true
		LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready = true
		Update_Ready_State.rpc(multiplayer.get_unique_id(), true)
	elif I_AM_READY == true:
		I_AM_READY = false
		LobbyMultiplayer.List_of_Players[multiplayer.get_unique_id()].is_Player_Ready = false
		Update_Ready_State.rpc(multiplayer.get_unique_id(), false)
		
		
@rpc("any_peer", "call_local", "reliable")
func Update_Ready_State(sender_id: int, final_ready_state: bool) -> void:
	LobbyMultiplayer.List_of_Players[sender_id].is_Player_Ready = final_ready_state
