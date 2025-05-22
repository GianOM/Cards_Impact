extends Node2D

signal reroll

@onready var card_slot: Node2D = $CardSlot
@onready var card_slot_2: Node2D = $CardSlot2
@onready var card_manager: Node2D = $"../CardManager"

@onready var reroll_slot_1: Node2D = $RerollSlot1
@onready var reroll_slot_2: Node2D = $RerollSlot2
@onready var reroll_slot_3: Node2D = $RerollSlot3



var rerolled_cards = [reroll_slot_1, reroll_slot_2, reroll_slot_3]

var reroll_card_slots = [card_slot, card_slot_2]

func _on_reroll_button_pressed() -> void:
	
	$RerollButton.disabled = true
	#var card_to_be_destroyed
	#card_slot = card_manager.raycast_check_card_slot()

	if card_slot.card_in_slot and card_slot_2.card_in_slot:
		
		if card_manager.cards_inside_card_slots.size() > 1:
			var card_to_be_destroyed = card_manager.cards_inside_card_slots[0]
			var card_to_be_destroyed2 = card_manager.cards_inside_card_slots[1]
			card_to_be_destroyed.visible = false
			card_to_be_destroyed2.visible = false
			card_manager.cards_inside_card_slots.clear()

			#print(card_manager.cards_inside_card_slots)
			card_slot.card_in_slot = false
			card_slot_2.card_in_slot = false
			$RerollButton.disabled = false
			#print("reroll")
			reroll.emit()
			$FullBGImage.visible = true
			#$RerollSlot1.visible = true
	else:
		print("needs 2 cards to reroll")
	$RerollButton.disabled = false
		


#func _on_reroll_select_pressed() -> void:
	#$FullBGImage.visible = false
	#$RerollSelect.visible = false
