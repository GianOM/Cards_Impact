extends Node3D

@onready var camera_3d: Camera3D = $"../Camera3D"

@export var card_size_x: float = 0.7 # Width of the card
@export var card_size_y: float = 1.0 # Height of the card
@export var card_size_z: float = 0.05 # Thickness of the card (like a thin card)
@export var distance_from_camera: float = 2.0 # How far in front of the camera the card will appear
@export var card_color: Color = Color(0.8, 0.2, 0.2) # Default color for the card (reddish)

func _position_card_on_screen(camera: Camera3D):
	
	#Retorna o tamanho da tela - 1. Ou seja, se a resolucao for (1920,1080)
	#Ele retornara (1919,1079)
	var viewport_size = get_viewport().size#Retorna o tamanho da tela - 1
	
	var target_screen_pos: Vector2 = $"../CanvasLayer/Panel/HBoxContainer/ColorRect".global_position + Vector2(100,100)
	
	# Get a ray origin and direction from the camera through the target screen position.
	var ray_origin = camera.project_ray_origin(target_screen_pos)
	var ray_normal = camera.project_ray_normal(target_screen_pos)

	# Calculate the 3D world position by extending the ray by `distance_from_camera`.
	var world_position = ray_origin + ray_normal * distance_from_camera
	$"3dCard".global_transform.origin = world_position

	# Make the card always face the camera.
	# Using `camera.global_transform.basis` directly ensures its rotation matches the camera's.
	$"3dCard".global_transform.basis = camera.global_transform.basis

# You can add a function to update the card's position if the camera or viewport moves,
# for example, in _process(delta) or _unhandled_input(event) for resizing.
# For dynamic following, you might re-call _position_card_on_screen in _process.
#
func _process(_delta: float) -> void:
	_position_card_on_screen(camera_3d)
		
		
#
#var Card_Distance_from_Camera: float = 1
#var Vertical_offset: float = 0.8
#
#func _process(delta: float) -> void:
	#var My_Camera = get_viewport().get_camera_3d()
	##$"3dCard".basis = My_Camera.global_transform.basis
	##$"3dCard".origin += My_Camera.basis * Vector3.BACK*0.1
	##card_mesh_instance.global_transform.origin = camera.global_transform.origin - camera.global_transform.basis.z * distance_from_camera
	#$"3dCard".global_transform.basis= My_Camera.global_transform.basis
	#$"3dCard".global_transform.origin = My_Camera.global_transform.origin - My_Camera.global_transform.basis.z * Card_Distance_from_Camera
	##position
	##$"3dCard".position.z += Vertical_offset
	##$"3dCard".global_transform.basis= My_Camera.global_transform.basis
	##My_Camera.
	#print("oi")
