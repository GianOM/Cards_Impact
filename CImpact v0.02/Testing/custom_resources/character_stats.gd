class_name CharacterStats
extends Stats

@export var starting_deck: CardPile
@export var starting_defend_deck: CardPile
@export var starting_attack_deck: CardPile
@export var cards_per_turn: int
@export var max_mana: int
@export var initial_gaslight_tokens: int
@export var initial_gatekeep_tokens: int
@export var base_income: float

var gaslight_tokens: int: set = set_gaslight_tokens
var gatekeep_tokens: int: set = set_gatekeep_tokens
var mana: int: set = set_mana
var deck: CardPile
#var defend_deck: CardPile
#var attack_deck: CardPile
var discard: CardPile
var draw_pile: CardPile
var current_income: float

func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()

func set_gaslight_tokens(value: int):
	gaslight_tokens = value
	stats_changed.emit()

func update_income() -> void:
	current_income = base_income + CollisionCheck.gaslight_income
	self.gaslight_tokens += current_income
	stats_changed.emit()

func update_gaslight_tokens():
	self.gaslight_tokens += initial_gaslight_tokens

func set_gatekeep_tokens(value: int):
	gatekeep_tokens = value
	stats_changed.emit()

func update_gatekeep_tokens():
	self.gatekeep_tokens += initial_gatekeep_tokens


func reset_mana() -> void:
	self.mana = max_mana

#add gaslight and gatekeep later
#func can_play_card(card: Card) -> bool:
	#return mana >= card.cost

func can_play_card(card: Card) -> bool:
	return gaslight_tokens >= card.gaslight_cost
	#return gaslight_tokens >= card.gaslight_cost and gatekeep_tokens >= card.gatekeep_cost

func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.gaslight_tokens = 0
	instance.gatekeep_tokens = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	#instance.defend_deck = instance.starting_defend_deck.duplicate()
	#instance.attack_deck = instance.starting_attack_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
