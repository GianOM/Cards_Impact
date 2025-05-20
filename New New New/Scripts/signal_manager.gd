extends Node

@warning_ignore("unused_signal")
signal signal_manager_warning

func send_warning():
	SignalManager.emit_signal("signal_manager_warning")
