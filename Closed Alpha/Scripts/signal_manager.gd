extends Node

@warning_ignore("unused_signal")
signal occupied_tile
signal cannot_reroll
signal cannot_deploy_in_enemy_field

signal warning_message

#var warning: String
var is_ready

func occupied_tile_warning():
	SignalManager.emit_signal("occupied_tile")

func unable_to_reroll():
	SignalManager.emit_signal("cannot_reroll")

func cannot_interact_with_enemy_field():
	SignalManager.emit_signal("cannot_deploy_in_enemy_field")
