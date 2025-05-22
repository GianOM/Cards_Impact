extends Node2D

const CARD_SCENE_PATH = "res://Scenes/2D/card.tscn"
const CARD_DRAW_SPEED = 0.3
const STARTING_HAND_SIZE = 4
#const COLLISION_MASK_CARD = 1
#const COLLISION_MASK_REROLL_SLOT = 16
var rerolled_card_1
var rerolled_card_2
var rerolled_card_3

var rerolled_cards = []
var new_card
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
	var new_reroll_card
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
	
	rerolled_card_1 = draw_reroll_card()
	rerolled_card_1.z_index = 7
	rerolled_card_1.is_reroll_card = true
	rerolled_card_1.get_node("CardArea2D").collision_mask = 16
	tween.tween_property(rerolled_card_1, "position", $"../LeftMenu/RerollSlot1".position, CARD_DRAW_SPEED)
	tween2.tween_property(rerolled_card_1, "scale", Vector2(1.3, 1.3), CARD_DRAW_SPEED)
	
	rerolled_card_2 = draw_reroll_card()
	rerolled_card_2.z_index = 7
	rerolled_card_2.is_reroll_card = true
	rerolled_card_2.get_node("CardArea2D").collision_mask = 16
	tween.tween_property(rerolled_card_2, "position", $"../LeftMenu/RerollSlot2".position, CARD_DRAW_SPEED)
	tween2.tween_property(rerolled_card_2, "scale", Vector2(1.3, 1.3), CARD_DRAW_SPEED)
	
	rerolled_card_3 = draw_reroll_card()
	rerolled_card_3.z_index = 7
	rerolled_card_3.is_reroll_card = true
	rerolled_card_3.get_node("CardArea2D").collision_mask = 16
	tween.tween_property(rerolled_card_3, "position", $"../LeftMenu/RerollSlot3".position, CARD_DRAW_SPEED)
	tween2.tween_property(rerolled_card_3, "scale", Vector2(1.3, 1.3), CARD_DRAW_SPEED)
	#for i in range(3):
		#new_card = draw_reroll_card()
		#new_card.z_index = 7
		#tween.tween_property(new_card, "position", new_pos[i], CARD_DRAW_SPEED)
		#tween2.tween_property(new_card, "scale", Vector2(1.3, 1.3), CARD_DRAW_SPEED)
		#
		##print(rerolled_cards[i].card_name)
		##new_card.get_node("CardArea2D/CardCollisionShape2D").disabled = true
		##new_card.get_node("CardArea2D").set_collision_layer_value(16,16) #layer 5
		##new_card.get_node("CardArea2D").collision_mask_value(16,16) #mask 5
		#
		#if i == 0:
			#new_card.get_node("CardArea2D").collision_mask = 16
			#new_card.is_reroll_card = true
			#rerolled_card_1 = new_card
		#if i == 1:
			#new_card.get_node("CardArea2D").collision_mask = 16
			#new_card.is_reroll_card = true
			#rerolled_card_2 = new_card
		#if i == 1:
			#new_card.get_node("CardArea2D").collision_mask = 16
			#new_card.is_reroll_card = true
			#rerolled_card_3 = new_card
		#new_card.queue_free()
			
			
		#---------------------------------working-v----------------------------------
		#if i == 0: #16 = 5, 32 = 6, 64 = 7
			#new_card.get_node("CardArea2D").collision_mask = 16
			#new_card.is_reroll_card = true
			#rerolled_cards.append(new_card)
		#else:
			#new_card.get_node("CardArea2D").collision_mask = 16 * (i + i)
			#new_card.is_reroll_card = true
			#rerolled_cards.append(new_card)
		#----------------------------------------^--------------------------------
		#new_card.get_node("CardArea2D").collision_mask = 16
		#new_card.is_reroll_card = true
		#rerolled_cards.append(new_card)
		
		#print(new_card.get_node("CardArea2D").collision_mask)
		#print(rerolled_cards[i].card_name)
		#print(rerolled_cards[i].card_hp)

#func _on_button_1_pressed() -> void:
	##rerolled_cards.clear()
	##new_card.queue_free()
	#var tween = get_tree().create_tween()
	#$"../PlayerHand".add_card_to_hand(rerolled_card_1, CARD_DRAW_SPEED)
	#tween.tween_property(rerolled_card_1, "scale", Vector2(1, 1), CARD_DRAW_SPEED)
	#rerolled_card_1.z_index = 1
	#rerolled_card_1.is_reroll_card = false
	#rerolled_card_1.get_node("CardArea2D").collision_mask = 1
	#rerolled_card_2.queue_free()
	#rerolled_card_3.queue_free()
	#$"../LeftMenu/FullBGImage".visible = false
	#$"../LeftMenu/RerollSlot1".visible = false
	#$"../LeftMenu/RerollSlot2".visible = false
	#$"../LeftMenu/RerollSlot3".visible = false
#
#func _on_button_2_pressed() -> void:
	#var tween = get_tree().create_tween()
	#$"../PlayerHand".add_card_to_hand(rerolled_card_2, CARD_DRAW_SPEED)
	#tween.tween_property(rerolled_card_2, "scale", Vector2(1, 1), CARD_DRAW_SPEED)
	#rerolled_card_2.z_index = 1
	#rerolled_card_2.is_reroll_card = false
	#rerolled_card_2.get_node("CardArea2D").collision_mask = 1
	#rerolled_card_1.queue_free()
	#rerolled_card_3.queue_free()
	#$"../LeftMenu/FullBGImage".visible = false
	#$"../LeftMenu/RerollSlot1".visible = false
	#$"../LeftMenu/RerollSlot2".visible = false
	#$"../LeftMenu/RerollSlot3".visible = false
#
#func _on_button_3_pressed() -> void:
	#var tween = get_tree().create_tween()
	#$"../PlayerHand".add_card_to_hand(rerolled_card_3, CARD_DRAW_SPEED)
	#tween.tween_property(rerolled_card_3, "scale", Vector2(1, 1), CARD_DRAW_SPEED)
	#rerolled_card_3.z_index = 1
	#rerolled_card_3.is_reroll_card = false
	#rerolled_card_3.get_node("CardArea2D").collision_mask = 1
	#rerolled_card_1.queue_free()
	#rerolled_card_2.queue_free()
	#$"../LeftMenu/FullBGImage".visible = false
	#$"../LeftMenu/RerollSlot1".visible = false
	#$"../LeftMenu/RerollSlot2".visible = false
	#$"../LeftMenu/RerollSlot3".visible = false

# Adicione suas variáveis aqui, caso ainda não existam
#@export var rerolled_card_1: Node2D
#@export var rerolled_card_2: Node2D
#@export var rerolled_card_3: Node2D
#@export var CARD_DRAW_SPEED: float = 0.5 # Exemplo de valor

func _on_button_1_pressed() -> void:
	_process_reroll_card(rerolled_card_1, [rerolled_card_2, rerolled_card_3])

func _on_button_2_pressed() -> void:
	_process_reroll_card(rerolled_card_2, [rerolled_card_1, rerolled_card_3])

func _on_button_3_pressed() -> void:
	_process_reroll_card(rerolled_card_3, [rerolled_card_1, rerolled_card_2])

func _process_reroll_card(card_to_keep: Node2D, cards_to_free: Array[Node2D]) -> void:
	var tween = get_tree().create_tween()
	$"../PlayerHand".add_card_to_hand(card_to_keep, CARD_DRAW_SPEED)
	tween.tween_property(card_to_keep, "scale", Vector2(1, 1), CARD_DRAW_SPEED)
	card_to_keep.z_index = 1
	card_to_keep.is_reroll_card = false
	card_to_keep.get_node("CardArea2D").collision_mask = 1

	for card in cards_to_free:
		if is_instance_valid(card): # Garante que o nó ainda existe antes de tentar liberá-lo
			card.queue_free()

	# Desativar elementos da UI (seja lá o que esses RerollSlot sejam)
	$"../LeftMenu/FullBGImage".visible = false
	$"../LeftMenu/RerollSlot1".visible = false
	$"../LeftMenu/RerollSlot2".visible = false
	$"../LeftMenu/RerollSlot3".visible = false
