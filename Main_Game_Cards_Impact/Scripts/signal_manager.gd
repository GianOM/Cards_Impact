extends Node

signal signal_manager_warning

func send_warning():
	SignalManager.emit_signal("signal_manager_warning")
