class_name Item
extends Resource

enum CharacterType {ALL, WARRIOR}

@export_group("Item Attributes")
@export var item_name: String
@export var id: String
@export var character_type: CharacterType
@export var starter_item: bool = false

@export_group("Item Visuals")
@export var icon: Texture
@export_multiline var tooltip: String

func initialize_item(_owner: ItemUI) -> void:
	pass

func activate_item(owner: ItemUI) -> void:
	pass

func deactivate_item(owner: ItemUI) -> void:
	pass

func get_tooltip() -> String:
	return tooltip

func can_appear_as_reward(character: CharacterStats) -> bool:
	if starter_item:
		return false
	
	if character_type == CharacterType.ALL:
		return true
	
	var item_char_name: String = CharacterType.keys()[character_type].to_lower()
	var char_name := character.character_name.to_lower()
	
	return item_char_name == char_name
