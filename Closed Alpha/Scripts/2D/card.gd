extends Node2D

signal hovered
signal unhovered

var card_slot_card_is_in
var position_in_hand
var card_name
var card_atk
var card_hp
var card_type
var gaslight_cost
var gatekeep_cost
var card_id

var is_reroll_card = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_card_area_2d_mouse_entered() -> void:
	emit_signal("hovered",self)


func _on_card_area_2d_mouse_exited() -> void:
	emit_signal("unhovered",self)
