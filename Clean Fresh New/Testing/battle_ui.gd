class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var hand: Hand = $Hand as Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var token_ui: TokenUI = $TokenUI as TokenUI
@onready var end_turn_button: Button = %EndTurnButton
@onready var reroll_button: Button = %RerollButton


func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	reroll_button.pressed.connect(_on_reroll_button_pressed)

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	token_ui.char_stats = char_stats
	mana_ui.char_stats = char_stats
	hand.char_stats = char_stats

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false
	reroll_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	reroll_button.disabled = true
	Events.player_turn_ended.emit()

func _on_reroll_button_pressed() -> void:
	end_turn_button.disabled = true
	reroll_button.disabled = true
	Events.reroll_requested.emit()
