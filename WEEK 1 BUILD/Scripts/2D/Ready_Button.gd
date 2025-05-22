extends Button

var I_AM_READY: bool = false

func _on_pressed() -> void:
	if ReadyButton.I_AM_READY == false:
		ReadyButton.I_AM_READY = true
	elif ReadyButton.I_AM_READY == true:
		ReadyButton.I_AM_READY = false
