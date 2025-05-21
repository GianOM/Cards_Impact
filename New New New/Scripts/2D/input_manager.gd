extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_REROLL_SLOT = 16
const COLLISION_MASK_DECK = 4 #is set to 3 in inspector, but inspector and output show different values,
							  #so 4 in code is 3 in inspector
var card_manager_reference
var deck_reference

func _ready() -> void:
	card_manager_reference = $"../CardManager"
	deck_reference = $"../Deck"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
			
			
func raycast_at_cursor():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		var card_found = result[0].collider.get_parent()
		if result_collision_mask == COLLISION_MASK_CARD:
			#card clicked
			#print("card clicked")
			
			if card_found:
				#print("card found")
				card_manager_reference.start_drag(card_found)
		elif result_collision_mask == COLLISION_MASK_DECK:
			#deck clicked
			deck_reference.draw_card()
		elif result_collision_mask == COLLISION_MASK_REROLL_SLOT:
			card_manager_reference.select_rerolled_card(card_found)
			#print("card in rerolled card slot clicked")
