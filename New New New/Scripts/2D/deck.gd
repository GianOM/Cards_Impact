extends Node2D

const CARD_SCENE_PATH = "res://Scenes/2D/card.tscn"
const CARD_DRAW_SPEED = 0.3
const STARTING_HAND_SIZE = 4
#const COLLISION_MASK_CARD = 1
#const COLLISION_MASK_REROLL_SLOT = 16

var rerolled_cards = []

var player_deck = ["Ian", "Scholles", "Caio", "Gian", "Luis", "Ian", "Scholles", "Caio", "Gian", "Luis", 
					"Ian", "Scholles", "Caio", "Gian", "Luis", "Ian", "Scholles", "Caio", "Gian", "Luis"]
var card_database_reference 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://Scripts/2D/card_database.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()



func draw_card(): #called in input_manager.gd
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name) #removes currently drawn card from deck
	
	if player_deck.size() == 0: #checks if deck empty and if so disables deck
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	#$"../CardManager".add_child(new_card)
	#new_card.position = position
	var card_image_path = str("res://Assets/2D Assets/" + card_drawn_name + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	new_card.get_node("ATK").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("HP").text = str(card_database_reference.CARDS[card_drawn_name][1])
	new_card.card_type = card_database_reference.CARDS[card_drawn_name][2]
	new_card.get_node("Name").text = card_drawn_name
	$"../CardManager".add_child(new_card)
	new_card.position = position
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")



func draw_reroll_card(): #called in input_manager.gd
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name) #removes currently drawn card from deck
	
	if player_deck.size() == 0: #checks if deck empty and if so disables deck
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	#$"../CardManager".add_child(new_card)
	#new_card.position = position
	var card_image_path = str("res://Assets/2D Assets/" + card_drawn_name + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Name").text = card_drawn_name
	new_card.get_node("ATK").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("HP").text = str(card_database_reference.CARDS[card_drawn_name][1])
	#set variables according to the card drawn, so they can be used later------
	new_card.card_name = card_drawn_name
	new_card.card_atk = card_database_reference.CARDS[card_drawn_name][0]
	new_card.card_hp = card_database_reference.CARDS[card_drawn_name][1]
	new_card.card_type = card_database_reference.CARDS[card_drawn_name][2]
	#---------------------------------------------------------------------------

	$"../CardManager".add_child(new_card)
	new_card.position = position
	new_card.name = "Card"
	new_card.get_node("AnimationPlayer").play("card_flip")
	return new_card



func _on_left_menu_reroll() -> void:
	var new_pos = [$"../LeftMenu/RerollSlot1".position, 
					$"../LeftMenu/RerollSlot2".position, $"../LeftMenu/RerollSlot3".position]
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	var new_card
	for i in range(3):
		new_card = draw_reroll_card()
		new_card.z_index = 7
		tween.tween_property(new_card, "position", new_pos[i], CARD_DRAW_SPEED)
		tween2.tween_property(new_card, "scale", Vector2(1.3, 1.3), CARD_DRAW_SPEED)
		
		#print(rerolled_cards[i].card_name)
		#new_card.get_node("CardArea2D/CardCollisionShape2D").disabled = true
		#new_card.get_node("CardArea2D").set_collision_layer_value(16,16) #layer 5
		#new_card.get_node("CardArea2D").collision_mask_value(16,16) #mask 5
		new_card.get_node("CardArea2D").collision_mask = 16
		new_card.is_reroll_card = true
		rerolled_cards.append(new_card)
		#print(rerolled_cards[i].card_name)
		#print(rerolled_cards[i].card_hp)


func _on_reroll_select_pressed() -> void:
	$"../LeftMenu/FullBGImage".visible = false
	$"../LeftMenu/RerollSelect".visible = false
