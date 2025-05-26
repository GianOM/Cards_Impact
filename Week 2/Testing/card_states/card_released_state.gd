extends CardState

var played: bool

func enter() -> void:
	played = false
	
	if not card_ui.targets.is_empty():
		played = true
		print("played card for target(s) ", card_ui.targets)
		#----------------------------------------------------------------------v
		await get_tree().create_timer(0.2).timeout
		CollisionCheck.is_a_card_being_dragged = false
		card_ui.queue_free()
		#----------------------------------------------------------------------^

func on_input(_event: InputEvent) -> void:
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
