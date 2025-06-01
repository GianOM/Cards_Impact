class_name Item
extends Resource

@export_group("Item Attributes")
@export var id: String
@export var cost: int

@export_group("Item Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
