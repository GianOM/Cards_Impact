class_name ItemHandler
extends VBoxContainer

const ITEM_APPLY_INTERVAL := 0.5
const ITEM_UI := preload("res://Testing/item_ui.tscn")

@onready var items_control: ItemsControl = $ItemsControl
@onready var items: VBoxContainer = %Items

func _ready() -> void:
	items.child_exiting_tree.connect(_on_items_child_exiting_tree)
	add_item(preload("res://Testing/items/coupon.tres"))
	await get_tree().create_timer(2.0).timeout
	add_item(preload("res://Testing/items/item_ian.tres"))
	await get_tree().create_timer(2.0).timeout
	add_item(preload("res://Testing/items/item_scholles.tres"))
	await get_tree().create_timer(2.0).timeout
	add_item(preload("res://Testing/items/item_ian.tres"))

func add_items(items_array: Array[Item]) -> void:
	for item: Item in items_array:
		add_item(item)

func add_item(item: Item) -> void:
	if has_item(item.id):
		return
	
	var new_item_ui := ITEM_UI.instantiate() as ItemUI
	items.add_child(new_item_ui)
	new_item_ui.item = item
	new_item_ui.item.initialize_item(new_item_ui)

func has_item(id: String) -> bool:
	for item_ui: ItemUI in items.get_children():
		if item_ui.item.id == id and is_instance_valid(item_ui):
			return true
	
	return false

func get_all_items() -> Array[Item]:
	var item_ui_nodes := _get_all_item_ui_nodes()
	var items_array: Array[Item] = []
	
	for item_ui: ItemUI in item_ui_nodes:
		items_array.append(item_ui.item)
	
	return items_array

func _get_all_item_ui_nodes() -> Array[ItemUI]:
	var all_items: Array[ItemUI] = []
	for item_ui: ItemUI in items.get_children():
		all_items.append(item_ui)
	
	return all_items

func _on_items_child_exiting_tree(item_ui: ItemUI) -> void:
	if not item_ui:
		return
	
	if item_ui.item:
		item_ui.item.deactivate_item(item_ui)
