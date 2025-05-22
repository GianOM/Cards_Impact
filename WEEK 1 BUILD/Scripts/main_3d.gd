extends Node3D

@onready var main_2d: Node2D = $Main2D



func hideUI():

	main_2d.set_process_mode(Node.PROCESS_MODE_DISABLED)
	main_2d.visible = false
func showUI():
	main_2d.set_process_mode(Node.PROCESS_MODE_INHERIT)
	main_2d.visible = true
	
var ui_visible: bool = false

func _input(_event):
	if Input.is_action_just_pressed("hide_ui"): #just_pressed triggers only once
		if ui_visible == false:
			ui_visible = true

			hideUI()
		else:
			ui_visible = false
			showUI()
	
	if Input.is_action_just_pressed("ESC") and ui_visible:
			ui_visible = false
			showUI()
		
		
		#elif Input.is_action_just_pressed("ESC") or ui_visible == true:
			#ui_visible = false
			#showUI()
		
		
		
		#else:
			#ui_visible = false
			#showUI()
		#if Input.is_action_just_pressed("ESC") and ui_visible:
			#showUI()
