class_name Card
extends Resource

enum Type {ATTACK, DEFEND, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id_number: int
@export var id_attack: int
@export var id_defend: int
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var gaslight_cost: int
@export var gatekeep_cost: int


@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return[]

func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	char_stats.gaslight_tokens -= gaslight_cost
	char_stats.gatekeep_tokens -= gatekeep_cost
	#CollisionCheck.card_id_number = self.id_number
	
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))

#will be overridden by each card effect's scripts
func apply_effects(_targets: Array[Node]) -> void:
	pass
