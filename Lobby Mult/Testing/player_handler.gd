class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.15
const HAND_DISCARD_INTERVAL := 0.15
#const BASE_GASLIGHT_INCOME := 1.0

@export var hand: Hand

@onready var passive_income_timer: Timer = %PassiveIncomeTimer

var character: CharacterStats
#var switch: bool


func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	CollisionCheck.refund_card.connect(_refund_defend_card)
	Events.reroll_requested.connect(reroll)
	passive_income_timer.start()
	passive_income_timer.timeout.connect(_generate_income)

func _generate_income() -> void:
	character.update_income()
	#character.gaslight_tokens += BASE_GASLIGHT_INCOME

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	start_turn()

func start_turn() -> void:
	#if switch == false:
		#switch = true
		#character.draw_pile = character.attack_deck.duplicate(true)
	#else:
		#character.draw_pile = character.defend_deck.duplicate(true)
		#switch = false
	#character.draw_pile.shuffle()
	#character.discard = CardPile.new()
	character.block = 0
	character.update_gaslight_tokens()
	character.update_gatekeep_tokens()
	character.reset_mana()
	draw_cards(character.cards_per_turn)
	#CollisionCheck.turn_number += 1
	#print("turn number: " + str(CollisionCheck.turn_number))

func reroll() -> void:
	if not hand.get_children():
		return
	hand.disable_hand()
	var tween := create_tween()
	var count := 0
	for card_ui in hand.get_children():
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
		count += 1
	
	await tween.finished
	draw_cards(count - 1)


func end_turn() -> void:
	hand.disable_hand()
	discard_cards()

func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()

func draw_cards(amount: int) -> void:
	if amount == 0:
		Events.player_hand_drawn.emit()
		return
	var tween = create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func(): 
			Events.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	if not hand.get_children():
		Events.player_hand_discarded.emit()
		return
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
	)

func reshuffle_deck_from_discard() -> void: #reshuffles discarded cards back to deck
	if not character.draw_pile.empty():     #^only if deck isn't empty
		return
	
	while not character.discard.empty(): #empties discard pile back into main deck
		character.draw_pile.add_card(character.discard.draw_card())
	
	character.draw_pile.shuffle()

func _on_card_played(card: Card) -> void:
	character.discard.add_card(card)
	
	#var discard_pile = character.discard.find_cards()
	#for i in character.discard.size():
		#if discard_pile[i].id_number == 1:
			#print(discard_pile[i].id_number)
	#print("----------------")
func _refund_defend_card(card_id: int) -> void:
	#var card_refunded := false
	var discard_pile = character.discard.find_cards()
	#print(discard_pile)
	for i in character.discard.size():
		if discard_pile[i].id_defend == card_id:
			#print(discard_pile[i].id_number)
			character.gaslight_tokens += discard_pile[i].gaslight_cost
			character.gatekeep_tokens += discard_pile[i].gatekeep_cost
			hand.add_card(character.discard.draw_card_by_id(discard_pile[i].id_defend))
			character.discard.remove_card_by_id(discard_pile[i].id_defend)
			#card_refunded = true
			return
