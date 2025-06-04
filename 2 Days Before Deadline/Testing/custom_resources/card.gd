class_name Card
extends Resource

enum Type {ATTACK, DEFEND, POWER}
enum Tier {T1, T2}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

const TIER_COLOR := {
	Card.Tier.T1: Color.GRAY,
	Card.Tier.T2: Color.GREEN,
}


# ---- GIAN WAS HERE -------
@export_group("Resources")
@export var Dados_de_Tropas:Moving_Units_Data

#class_name Moving_Units_Data
#extends Resource
#
#@export var Vida: float
#@export var Velocidade: float
#@export var Dano: float
#@export var Tier: int#Variavel de 0 a 1
#@export var Troops_Quantity: int
#
#@export_file("*.tscn") var troop_scene_path: String

@export var Dados_de_Torres:Tower_Data

#class_name Tower_Data extends Resource
#
#@export var Tower_Name : String
#@export var Tower_Range : float
#@export var Tower_Damage : float
#@export var Tower_Index: int
#@export var Tower_Attack_Cooldown: float
#
#@export var Gaslight_Token_Cost:int
#@export var Gatekeep_Token_Cost:int
#
#@export_file("*.tscn") var Tower_scene_path: String

# ---- END OF GIAN EDIT -------


@export_group("Card Attributes")
@export var id_number: int
@export var id_attack: int
@export var id_defend: int
@export var id: String
@export var type: Type
@export var tier: Tier
@export var unit_amount: int
@export var target: Target
@export var cost: int
@export var gaslight_cost: int
@export var gatekeep_cost: int
@export var gaslight_income: float


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
	#char_stats.mana -= cost
	char_stats.gaslight_tokens -= gaslight_cost
	#char_stats.gatekeep_tokens -= gatekeep_cost
	#CollisionCheck.card_id_number = self.id_number
	
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))

#will be overridden by each card effect's scripts
func apply_effects(_targets: Array[Node]) -> void:
	pass
