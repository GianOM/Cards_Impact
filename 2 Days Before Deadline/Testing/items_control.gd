class_name ItemsControl
extends Control

const ITEMS_PER_PAGE := 4
const TWEEN_SCROLL_DURATION := 0.1

@export var up_button: TextureButton
@export var down_button: TextureButton

@onready var items: VBoxContainer = %Items
@onready var page_length = self.custom_minimum_size.y

var num_of_items := 0
var current_page := 1
var max_page := 0
var tween: Tween

func _ready() -> void:
	up_button.pressed.connect(_on_up_button_pressed)
	down_button.pressed.connect(_on_down_button_pressed)
	
	for item_ui: ItemUI in items.get_children():
		item_ui.free()
	
	items.child_order_changed.connect(_on_items_child_order_changed)

func update() -> void:
	if not is_instance_valid(up_button) or not is_instance_valid(down_button):
		return
	
	num_of_items = items.get_child_count()
	max_page = ceili(num_of_items / float(ITEMS_PER_PAGE))
	
	up_button.disabled = current_page <= 1
	down_button.disabled = current_page >= max_page

func _tween_to(y_position: float) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(items, "position:y", y_position, TWEEN_SCROLL_DURATION)

func _on_up_button_pressed() -> void:
	if current_page > 1:
		current_page -= 1
		update()
		_tween_to(items.position.y + page_length)

func _on_down_button_pressed() -> void:
	if current_page < max_page:
		current_page += 1
		update()
		_tween_to(items.position.y - page_length)

func _on_items_child_order_changed() -> void:
	update()
