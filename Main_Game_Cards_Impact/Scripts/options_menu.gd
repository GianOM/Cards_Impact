extends Node2D


func _on_back_pressed() -> void:
	SceneSwitcher.switch_scene("res://Scenes/main_menu.tscn")


func _on_res_1080_pressed() -> void:
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	


func _on_res_720_pressed() -> void:
	DisplayServer.window_set_size(Vector2i(1280, 720))
