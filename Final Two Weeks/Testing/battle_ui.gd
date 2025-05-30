class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var hand: Hand = $Hand as Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var token_ui: TokenUI = $TokenUI as TokenUI
@onready var end_turn_button: Button = %EndTurnButton
@onready var reroll_button: Button = %RerollButton
@onready var ready_button: Button = %ReadyButton

#var turn_number: int

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	reroll_button.pressed.connect(_on_reroll_button_pressed)
	ready_button.pressed.connect(_on_ready_button_pressed)
	Events.hide_ui_requested.connect(_hide_ui)
	Events.show_ui_requested.connect(_show_ui)
	Events.disable_reroll_button_requested.connect(_disable_reroll_button)
	#turn_number = 1

func _hide_ui() -> void:
	self.set_process_mode(Node.PROCESS_MODE_DISABLED)
	self.visible = false

func _show_ui() -> void:
	self.set_process_mode(Node.PROCESS_MODE_INHERIT)
	self.visible = true

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
	#turn_number += 1

func _on_reroll_button_pressed() -> void:
	end_turn_button.disabled = true
	reroll_button.disabled = true
	Events.reroll_requested.emit()

func _on_ready_button_pressed() -> void:
	CollisionCheck.troca_o_estado_do_botao()
	if !CollisionCheck.I_AM_READY:
		ready_button.text = "READY"
	else:
		ready_button.text = "UNREADY"
		
		
func _disable_reroll_button() -> void:
	reroll_button.disabled = true
