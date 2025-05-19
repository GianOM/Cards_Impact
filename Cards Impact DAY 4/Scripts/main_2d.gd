extends Node2D


@onready var fps: Label = $UI/FPS
@onready var in_game_menu: CanvasLayer = $InGameMenu
@onready var is_on_main_menu = false
@onready var is_hovering_on_main_menu = false
@onready var timer: Timer = $UI/Timer


func _process(_delta):
	fps.text = ""
	fps.text += "fps: " + str(Engine.get_frames_per_second())

func _ready() -> void:


	in_game_menu.visible = false
	SignalManager.connect("signal_manager_warning", reemit_signal)

func reemit_signal():

	$UI/Warnings.text = "You tried to select an occupied cell, select another one"
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESC") && is_on_main_menu == false:
		in_game_menu.visible = true
		is_on_main_menu = true
	elif event.is_action_pressed("ESC") && is_on_main_menu == true:
		in_game_menu.visible = false
		is_on_main_menu = false
#------NEED TO FIND A WAY TO CLOSE IN GAME MENU BY CLICKING OUT-----

#------ALSO NEED TO STOP INTERACTING WITH BACKGROUND WHEN IN GAME MENU IS OPEN-
#---maybe by using raycast and checking collision masks

func _on_button_pressed() -> void:
	SceneSwitcher.switch_scene("res://Scenes/main_menu.tscn")
	


func _on_timer_timeout() -> void:
	$UI/Warnings.text = ""
