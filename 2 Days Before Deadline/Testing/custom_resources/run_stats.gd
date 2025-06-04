class_name RunStats
extends Resource

signal coins_changed

const STARTING_COINS := 50
const BASE_T1_WEIGHT := 8.0
const BASE_T2_WEIGHT := 2.0

@export var coins := STARTING_COINS: set = set_coins
@export_range(0.0, 10.0) var t1_weight := BASE_T1_WEIGHT
@export_range(0.0, 10.0) var t2_weight := BASE_T2_WEIGHT

func set_coins(new_amount: int) -> void:
	coins = new_amount
	coins_changed.emit()

func reset_weights() -> void:
	t1_weight = BASE_T1_WEIGHT
	t2_weight = BASE_T2_WEIGHT
