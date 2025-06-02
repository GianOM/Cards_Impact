class_name TokenUI
extends PanelContainer

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var gaslight_icon: TextureRect = %GaslightIcon
@onready var gaslight_tokens: RichTextLabel = %GaslightTokens
@onready var gatekeep_icon: TextureRect = %GatekeepIcon
@onready var gatekeep_tokens: RichTextLabel = %GatekeepTokens
@onready var income_per_second: RichTextLabel = %IncomePerSecond
@onready var coin_ui: CoinUI = %CoinUI

var stats: RunStats

func _ready() -> void:
	stats = RunStats.new()
	
func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()

func _on_stats_changed() -> void:
	coin_ui.run_stats = stats
	gaslight_tokens.text = str(char_stats.gaslight_tokens)
	gatekeep_tokens.text = str(char_stats.gatekeep_tokens)
	income_per_second.text = str("[right]%s[/right]" %char_stats.current_income)
