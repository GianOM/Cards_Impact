extends CardState

var played: bool

#func enter() -> void:
	#played = false
	#
	#if not card_ui.targets.is_empty():
		#Events.tooltip_hide_requested.emit()
		#played = true
		#card_ui.play()
		#----------------------------------------------------------------------v
		#await get_tree().create_timer(0.2).timeout
		#CollisionCheck.is_a_card_being_dragged = false
		#card_ui.queue_free()
		#----------------------------------------------------------------------^

func post_enter() -> void:
	await get_tree().create_timer(0.1).timeout
	if not CollisionCheck.tower_was_placed and not CollisionCheck.troop_was_placed:
		transition_requested.emit(self, CardState.State.BASE)
	else:
		Events.tooltip_hide_requested.emit()
		played = true
		card_ui.play()
		CollisionCheck.is_a_card_being_dragged = false
		CollisionCheck.tower_was_placed = false
		CollisionCheck.troop_was_placed = false
	#transition_requested.emit(self, CardState.State.BASE)
