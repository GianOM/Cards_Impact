extends CardState

var mouse_over_card := false

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	#------------------------------------------------------------------------v
	CollisionCheck.troop_was_placed = false
	CollisionCheck.tower_was_placed = false
	CollisionCheck.is_a_card_being_dragged = false
	#------------------------------------------------------------------------^
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()

func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	
	if mouse_over_card and event.is_action_pressed("left_mouse_click"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)

func on_mouse_entered() -> void:
	mouse_over_card = true
	if not card_ui.playable or card_ui.disabled:
		return
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)

func on_mouse_exited() -> void:
	mouse_over_card = false
	if not card_ui.playable or card_ui.disabled:
		return
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()
