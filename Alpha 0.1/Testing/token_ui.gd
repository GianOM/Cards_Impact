class_name TokenUI
extends PanelContainer

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var gaslight_icon: TextureRect = %GaslightIcon
@onready var gaslight_tokens: RichTextLabel = %GaslightTokens
@onready var gatekeep_icon: TextureRect = %GatekeepIcon
@onready var gatekeep_tokens: RichTextLabel = %GatekeepTokens

#func _ready() -> void:
	#await get_tree().create_timer(2).timeout
	#char_stats.mana = 2

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()

func _on_stats_changed() -> void:
	gaslight_tokens.text = str(char_stats.gaslight_tokens)
	gatekeep_tokens.text = str(char_stats.gatekeep_tokens)
