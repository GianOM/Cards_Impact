extends Node2D

@onready var card_slot: Node2D = $CardSlot
@onready var card_slot_2: Node2D = $CardSlot2
@onready var card_manager: Node2D = $"../CardManager"




func _on_reroll_button_pressed() -> void:
	#card_slot = card_manager.raycast_check_card_slot()

	if card_slot.card_in_slot and card_slot_2.card_in_slot:
		print("reroll")
	else:
		print("needs 2 cards to reroll")
