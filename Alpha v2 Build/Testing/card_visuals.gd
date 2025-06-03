class_name CardVisuals
extends Control

@export var card: Card: set = set_card

@onready var panel: Panel = $Panel
@onready var gaslight_cost: RichTextLabel = %GaslightCost
@onready var unit_amount: RichTextLabel = %UnitAmount
@onready var icon: TextureRect = $Icon
@onready var tier: TextureRect = $Tier

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	gaslight_cost.text = str(card.gaslight_cost)
	unit_amount.text = str(card.unit_amount)
	icon.texture = card.icon
	tier.modulate = Card.TIER_COLOR[card.tier]
