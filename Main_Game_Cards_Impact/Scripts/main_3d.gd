extends Node3D

@onready var main_2d: Node2D = $Main2D

func hideUI():
	main_2d.visible = false
func showUI():
	main_2d.visible = true
var uiToggle: bool = false

func _input(_event):
	if Input.is_action_just_pressed("hide_ui"): #just_pressed triggers only once
		if uiToggle == false:
			uiToggle = true
			hideUI()

		else:
			uiToggle = false
			showUI()
