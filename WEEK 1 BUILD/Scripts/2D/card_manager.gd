extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2 #collision layer and mask in cardslot/area2d should also match this number
const DEFAULT_CARD_MOVE_SPEED = 0.3

const CARD_SCENE_PATH = "res://Scenes/2D/card.tscn"

@onready var deck: Node2D = $"../Deck"
@onready var player_hand: Node2D = $"../PlayerHand"

@onready var input_manager: Node2D = $"../InputManager"
@onready var card_database_reference = preload("res://Scripts/2D/card_database.gd")

var screen_size
var card_being_dragged
var is_hovering_on_card
var player_hand_reference
var cards_inside_card_slots = []
var selected_rerolled_card
var selected_card
var which_reroll_slot_path
var hand_with_stuff
var last_number_of_towers = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	input_manager.connect("left_mouse_button_released", on_left_click_released)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var  mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),
			clamp(mouse_pos.y,0,screen_size.y))


func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	hand_with_stuff = player_hand.player_hand
	#print(card.card_name)
	#print(card.card_atk)
	if CollisionCheck.is_mouse_hitting_a_hex_cell == true:
		card.visible = false
	else:
		card.visible = true
#
	#if selected_card:
		#if selected_card == card:
			#card.position.y += 40
#
		#else:
			#selected_card.position.y += 40
#
			#selected_card = card
			#card.position.y -= 40
#
	#else:
		#selected_card = card
		#card.position.y -= 40


func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	#if CollisionCheck.is_a_card_being_dragged == false:
		#player_hand_reference.remove_card_from_hand(card_being_dragged)
		#return
	if CollisionCheck.number_of_towers_placed != last_number_of_towers:

		player_hand_reference.remove_card_from_hand(card_being_dragged)
		last_number_of_towers = CollisionCheck.number_of_towers_placed

	var card_slot_found = raycast_check_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		
		#card_being_dragged.z_index = -1
		#is_hovering_on_card = false
		#card_being_dragged.card_slot_card_is_in = card_slot_found
		
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		#reference to card slots----------------------------------------------AAAAAAAAAAAAAAAAAAAAAAA
		cards_inside_card_slots.append(card_being_dragged)
		#print(card_being_dragged.name)
		#print(cards_inside_card_slots)
		card_being_dragged.position = card_slot_found.position
		#card in slot is not longer able to be interacted with
		card_being_dragged.get_node("CardArea2D/CardCollisionShape2D").disabled = true

		card_slot_found.card_in_slot = true
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)

	card_being_dragged = null
	



func connect_card_signals(card):
	card.connect("hovered", on_hovered_card)
	card.connect("unhovered", on_unhovered_card)
	
func on_left_click_released():
	if card_being_dragged:
		CollisionCheck.is_a_card_being_dragged = false
		finish_drag()
		

func on_hovered_card(card):

	#if !is_hovering_on_card and !card.is_reroll_card:
	if !is_hovering_on_card:
		if card.is_reroll_card:
			highlight_rerolled_card(card, true)
			return
		is_hovering_on_card = true
		highlight_card(card, true)
	#elif !is_hovering_on_card and card.is_reroll_card:
		#highlight_rerolled_card(card, true)

	
func on_unhovered_card(card):
	#if !card_being_dragged and !card.is_reroll_card:
		#highlight_card(card, false)
	if !card_being_dragged:
		if card.is_reroll_card:
			highlight_rerolled_card(card, false)
			return
		highlight_card(card, false)
		var new_card_hovered = raycast_check()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false
	#else:
		#highlight_rerolled_card(card, false)

#PREVIOUS HOVER AND UNHOVER LOGIC WITHOUT REROLL CARDS-----------------------------------------------

#func on_hovered_card(card):
	#if !is_hovering_on_card:
		#is_hovering_on_card = true
		#highlight_card(card, true)
	#
#func on_unhovered_card(card):
	#if !card_being_dragged:
		#highlight_card(card, false)
		#var new_card_hovered = raycast_check()
		#if new_card_hovered:
			#highlight_card(new_card_hovered, true)
		#else:
			#is_hovering_on_card = false

#----------------------------------------------------------------------------------------------------

func select_rerolled_card(card):
	
	var button_path
	if selected_rerolled_card:
		if selected_rerolled_card == card:
			card.position.y += 40
			which_reroll_slot_path = which_slot_is_selected(card)
			#button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path) + "/Button" + var_to_str(which_reroll_slot_path))
			if which_reroll_slot_path != null:
				button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path))
				$"../LeftMenu".get_node(button_path).visible = false
			#$"../LeftMenu".get_node(which_reroll_slot_path).visible = false
			selected_rerolled_card = null
		else:
			selected_rerolled_card.position.y += 40
			which_reroll_slot_path = which_slot_is_selected(selected_rerolled_card)
			#button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path) + "/Button" + var_to_str(which_reroll_slot_path))
			if which_reroll_slot_path != null:
				button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path))
				$"../LeftMenu".get_node(button_path).visible = false
			#$"../LeftMenu".get_node(which_reroll_slot_path).visible = false
			selected_rerolled_card = card
			card.position.y -= 40
			which_reroll_slot_path = which_slot_is_selected(card)
			if which_reroll_slot_path != null:
				button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path))
			#button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path) + "/Button" + var_to_str(which_reroll_slot_path))
				$"../LeftMenu".get_node(button_path).visible = true
			#$"../LeftMenu".get_node(which_reroll_slot_path).visible = true
			
	else:
		selected_rerolled_card = card
		card.position.y -= 40
		which_reroll_slot_path = which_slot_is_selected(card)
		if which_reroll_slot_path != null:
			button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path))
		#button_path = str("RerollSlot" + var_to_str(which_reroll_slot_path) + "/Button" + var_to_str(which_reroll_slot_path))
			$"../LeftMenu".get_node(button_path).visible = true
		#$"../LeftMenu".get_node(which_reroll_slot_path).visible = true
	#which_reroll_slot_path = which_slot_is_the_card_in(card)
	#$"../LeftMenu".get_node(which_reroll_slot_path).visible = true

func which_slot_is_selected(card):
	var reroll_slot_n
	if card.position.x == $"../LeftMenu/RerollSlot1".position.x:
		reroll_slot_n = 1
	elif card.position.x == $"../LeftMenu/RerollSlot2".position.x:
		reroll_slot_n = 2
	elif card.position.x == $"../LeftMenu/RerollSlot3".position.x:
		reroll_slot_n = 3
	#var path = str("RerollSlot" + var_to_str(reroll_slot_n))
	#$"../LeftMenu".get_node(path).visible = true
	return reroll_slot_n

func which_card_to_return(card):
	#player_hand_reference.add_card_to_hand(card, DEFAULT_CARD_MOVE_SPEED)
	pass

func highlight_rerolled_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.5, 1.5)
		card.z_index = 7
	else:
		card.scale = Vector2(1.3, 1.3)
		card.z_index = 6

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1


func raycast_check_card_slot():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null



func raycast_check():
	var space_state = get_viewport().world_2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_viewport().get_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[1].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
	

#
#func _on_button_1_pressed() -> void:
	#var aaa = get_parent()
	#print(aaa.card_name)
#
#
#func _on_button_2_pressed() -> void:
	#var aaa = get_parent()
	#print(aaa.card_name)
#
#
#func _on_button_3_pressed() -> void:
	#var aaa = get_parent()
	#print(aaa.card_name)
