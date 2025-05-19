extends Node

@warning_ignore("unused_signal")
signal _signal_manager_warning

func send_warning():
	SignalManager.emit_signal("_signal_manager_warning")
