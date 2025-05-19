extends Node2D


func _on_play_pressed() -> void:
	SceneSwitcher.switch_scene("res://Scenes/Main.tscn")



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	SceneSwitcher.switch_scene("res://Scenes/options_menu.tscn")
