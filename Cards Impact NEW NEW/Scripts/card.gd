extends Node2D

signal hovered
signal unhovered

var position_in_hand
var card_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_card_area_2d_mouse_entered() -> void:
	emit_signal("hovered",self)


func _on_card_area_2d_mouse_exited() -> void:
	emit_signal("unhovered",self)
