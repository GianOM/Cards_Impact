class_name CoinUI
extends HBoxContainer

@export var run_stats: RunStats: set = set_run_stats

@onready var label: Label = $Label

func _ready() -> void:
	label.text = "0"

func set_run_stats(new_value: RunStats) -> void:
	run_stats = new_value
	
	if not run_stats.coins_changed.is_connected(_update_coins):
		run_stats.coins_changed.connect(_update_coins)
		_update_coins()

func _update_coins() -> void:
	label.text = str(run_stats.coins)
