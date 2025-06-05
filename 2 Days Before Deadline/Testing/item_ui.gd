class_name ItemUI
extends Control

@export var item: Item: set = set_item

@onready var icon: TextureRect = $Icon
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#func _ready() -> void:
	#item = preload("res://Testing/items/item_ian.tres")
	#await get_tree().create_timer(2.0).timeout
	#visual_effect()

func set_item(new_item: Item) -> void:
	if not is_node_ready():
		await ready
	
	item = new_item
	icon.texture = item.icon

func visual_effect() -> void:
	animation_player.play("effect")

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		print("item tooltip")
