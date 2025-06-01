class_name CardPile
extends Resource

signal card_pile_size_changed(cards_amount)

@export var cards: Array[Card] = []

func empty() -> bool:
	return cards.is_empty()

func draw_card() -> Card:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card

func draw_card_by_id(card_id: int) -> Card:
	var card: Card
	for i in cards.size():
		if cards[i].id_defend == card_id:
			card = cards[i]
	return card

func add_card(card: Card):
	cards.append(card)
	card_pile_size_changed.emit(cards.size())

func shuffle() -> void:
	cards.shuffle()

func size() -> int:
	return cards.size()

func find_cards() -> Array:
	return cards

func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())

func _to_string() -> String:
	var _card_strings: PackedStringArray = []
	for i in range(cards.size()):
		#_card_strings.append("%s: %s" % [i+1, cards[i].id_number])
		_card_strings.append("%s" % [cards[i].id_number])
	return "\n".join(_card_strings)
	
