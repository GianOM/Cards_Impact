extends Node

signal refund_card(id_number: int)

var is_a_card_being_dragged: bool = false
var is_Tower_Showing_up: bool = false

var tower_was_placed := false


var card_id_number: int
#var card_id_number_refund: int

var card_id_attack: int
var card_id_defense: int


var number_of_towers_placed: int = 0
var tower_placed = false
