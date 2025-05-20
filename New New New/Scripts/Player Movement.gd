extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

var velocity: Vector3 = Vector3.ZERO
var acceleration: float = 50#Uma boa aceleracao pra garantir que o jogo seja responsivo
var max_speed: float = 6
var friction: float = 10

var rotating :bool = false#Variavel usada para rotacionar a camera com o botao do mouse
var Camera_Rotation_Speed :float = 50
var Camera_Zoom_Speed :float = 800
var Clamped_Zoom:float = 0


const TOWERS = preload("res://Scenes/3D/Towers/Towers.tscn")
var Tower_Selected_Index:int = 0

@onready var My_Ray_Cast = $RayCast3D

var Hit_Hexagon: Hexagono
var Hit_Enemy_Spawner: Enemy_Spawner

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	Move_Camera(delta)
	
func Move_Camera(delta) -> void:
	#Se o Player Aperta Shift, Aumenta a Variavel Camera_Move_Speed e Camera_Rotation Speed
	var Input_Sprint = Input.is_action_pressed("Shift_Key")
	if Input_Sprint:
		Camera_Rotation_Speed = 100
		max_speed = 20
	else:
		max_speed = 6
		Camera_Rotation_Speed = 50

	
	#Input_Direction e uma tupla do tipo (x,y), onde x e y vao de -1(Tecla A ou S) ate 1(Tecla D ou W)
	var Input_Direction = Input.get_vector("A_Key","D_Key","W_Key","S_Key")
	#As direcoes da camera mudam conforme ela gira. Logo, precisamos atualizar, multiplicando pela direcao local e normalizando
	var movement_direction = (transform.basis * Vector3(Input_Direction.x,0,Input_Direction.y) ).normalized()
	
	if movement_direction != Vector3.ZERO:
		# Aplica inercia de movimento
		velocity = velocity.move_toward(movement_direction * max_speed, acceleration * delta)
	else:
		# Aplica friccao
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
	
	#Atualiza a Posicao do Node3D Player
	position += velocity*delta
	
	
	#Input_Rotation é um float que vai de -1(Quando aperta-se Q) ate +1(Quando Aperta-se E)
	var Input_Rotation = Input.get_axis("Q_Key","E_Key")
	rotation_degrees.y += Camera_Rotation_Speed * Input_Rotation * delta
	
	
	var zoom_direction = (int(Input.is_action_just_released("Scroll_Down"))
						- int(Input.is_action_just_released("Scroll_Up")) )
						
	#Clamped_Zoom limita o Zoom de um valor acumulado -5 ate +3
	var zoom_amount = Camera_Zoom_Speed * zoom_direction * delta
	var new_zoom = clamp(Clamped_Zoom + zoom_amount, -5.0, 45.0)
	zoom_amount = new_zoom - Clamped_Zoom
	Clamped_Zoom = new_zoom

	camera_3d.translate_object_local(Vector3(0, 0, zoom_amount))
		
	camera_3d.rotation.x = clamp(camera_3d.rotation.x - zoom_direction * 0.01, -1.25, -1.01)#Rotaciona a camera pra cima e para baixo um pouco quando da zoom


func _input(event):
	if event is InputEventMouseButton:
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#Precisamos checkar o RayCast ta colidindo para rodar a logica, ou entao o resultado do
			#Raycas sera Null e o jogo crasha
			#print(My_Ray_Cast.Ray_Hit.get_owner())
			if (My_Ray_Cast.Ray_Hit.get_owner() is Hexagono):#codigo para colocar a torre
				Hit_Hexagon = My_Ray_Cast.Ray_Hit.get_owner()
				#Se a Grid Cell esta livre, ou seja, se a Placed_Tower for null,
				#vc pode colocar uma torre no lugar
				if Hit_Hexagon.Placed_Tower == null:
					
					var Tower_Instance = TOWERS.instantiate() as Node3D
					get_tree().current_scene.add_child(Tower_Instance) 
					
					Tower_Instance.Troca_Pra_Torre_Pelo_Indice(Tower_Selected_Index)
					
					Tower_Instance.global_position = My_Ray_Cast.Ray_Hit.global_position
					
					Tower_Instance.Zerar_o_Tower_Range()#Zera o indicador visual do range da torre
					Tower_Instance.is_Tower_Place_on_Grid = true#Usada para evitar que a hovered tower de dano
					
					Hit_Hexagon.Placed_Tower = Tower_Instance#Cria uma referencia a torre
					Tower_Instance.scale = Vector3(20,20,20)
					
					Hit_Hexagon.Occupied_Cell()
				else:
					SignalManager.send_warning()#Manda um Warning que o Player tentou colocar uma torre em uma grid ocupada
			
			elif (My_Ray_Cast.Ray_Hit.get_owner() is Enemy_Spawner):
				Hit_Enemy_Spawner = My_Ray_Cast.Ray_Hit.get_owner()
				Hit_Enemy_Spawner.Bota_Uma_Tropa_Ai_Chefe()
				
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				
				#REMOVE A TORRE SE NO LUGAR DA GRID TINHA ALGO, ou seja, se nao era null
				if (Hit_Hexagon.Placed_Tower != null) and (My_Ray_Cast.Ray_Hit.get_owner() is Hexagono):
					Hit_Hexagon = My_Ray_Cast.Ray_Hit.get_owner()
					Hit_Hexagon.Placed_Tower.queue_free()
					
					Hit_Hexagon.Placed_Tower = null
					
					Hit_Hexagon.Highlight()
					My_Ray_Cast.last_hovered = Hit_Hexagon
	
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			rotating = true #Setado para poder rodar a camera
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)#Faz o mouse desaparecer

		elif Input.is_action_just_released("Middle_Mouse_Button"):
			rotating = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion and rotating:
		var delta = event.relative
		rotation_degrees.y -= (Camera_Rotation_Speed/512) * delta.x
	
	if Input.is_action_just_pressed("1_Key"):
		Tower_Selected_Index = 0
		My_Ray_Cast.Hovered_Tower_Index = 0
	elif Input.is_action_just_pressed("2_Key"):
		Tower_Selected_Index = 1
		My_Ray_Cast.Hovered_Tower_Index = 1
