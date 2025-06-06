class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var hand: Hand = $Hand
@onready var mana_ui: ManaUI = $ManaUI
@onready var token_ui: TokenUI = $TokenUI
@onready var end_turn_button: Button = %EndTurnButton
@onready var reroll_button: Button = %RerollButton
@onready var ready_button: Button = %ReadyButton
@onready var fps: RichTextLabel = %FPS
@onready var reroll_timer: Timer = $RerollTimer
@onready var paid_reroll_button: Button = %PaidRerollButton
@onready var item_handler: ItemHandler = %ItemHandler

@onready var draw_pile_button: CardPileOpener = %DrawPileButton
@onready var discard_pile_button: CardPileOpener = %DiscardPileButton
@onready var draw_pile_view: CardPileView = %DrawPileView
@onready var discard_pile_view: CardPileView = %DiscardPileView



var on_cooldown := false
#var turn_number: int

func _ready() -> void:
	#item_handler.add_item(character.starting_item)
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	
	reroll_button.pressed.connect(_on_reroll_button_pressed)
	paid_reroll_button.pressed.connect(_on_paid_reroll_button_pressed)
	
	
	Initialize_Reroll_Disable()
	
	ready_button.pressed.connect(_on_ready_button_pressed)
	Events.hide_ui_requested.connect(_hide_ui)
	Events.show_ui_requested.connect(_show_ui)
	draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw Pile", true))
	discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard Pile"))
	#Events.disable_reroll_button_requested.connect(_disable_reroll_button)
	#turn_number = 1

func initialize_card_pile_ui() -> void:
	draw_pile_button.card_pile = char_stats.draw_pile
	draw_pile_view.card_pile = char_stats.draw_pile
	discard_pile_button.card_pile = char_stats.discard
	discard_pile_view.card_pile = char_stats.discard

func _process(_delta):
	fps.text = ""
	fps.text += str(Engine.get_frames_per_second())
	if on_cooldown:
		reroll_button.text = "Reroll\n %02d:%02d" % time_left_to_reroll()
	else:
		reroll_button.text = "Reroll"

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
	paid_reroll_button.disabled = false
	#reroll_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	reroll_button.disabled = true
	paid_reroll_button.disabled = true
	CollisionCheck.turn_number += 1
	Events.player_turn_ended.emit()
	#turn_number += 1

func time_left_to_reroll():
	var time_left = reroll_timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]
	
	
	
func _on_ready_button_pressed() -> void:
	CollisionCheck.troca_o_estado_do_botao()
	if !CollisionCheck.I_AM_READY:
		ready_button.text = "READY"
	else:
		ready_button.text = "UNREADY"
		
		

#region REROLL BUTTONS
func Initialize_Reroll_Disable():
	on_cooldown = true
	reroll_timer.start()
	end_turn_button.disabled = true
	paid_reroll_button.disabled = true
	reroll_button.disabled = true

func _on_reroll_button_pressed() -> void:
	on_cooldown = true
	reroll_timer.start()
	end_turn_button.disabled = true
	paid_reroll_button.disabled = true
	reroll_button.disabled = true
	CollisionCheck.turn_number += 1
	Events.reroll_requested.emit()

func _on_paid_reroll_button_pressed() -> void:
	
	if char_stats.gaslight_tokens > 80:
		end_turn_button.disabled = true
		paid_reroll_button.disabled = true
		reroll_button.disabled = true
		CollisionCheck.turn_number += 1
		Events.reroll_requested.emit()
		
		char_stats.gaslight_tokens -= 80
		

func _disable_reroll_button() -> void:
	reroll_button.disabled = true

func _on_reroll_timer_timeout() -> void:
	reroll_button.disabled = false
	on_cooldown = false
#endregion
