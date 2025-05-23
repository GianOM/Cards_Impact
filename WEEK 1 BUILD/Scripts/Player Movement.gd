extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

var velocity: Vector3 = Vector3.ZERO
var acceleration: float = 50#Uma boa aceleracao pra garantir que o jogo seja responsivo
var max_speed: float = 15
var friction: float = 22

var rotating_on_middle_mouse_button :bool = false#Variavel usada para rotacionar a camera com o botao do mouse
var Camera_Rotation_Speed :float = 50
var Camera_Zoom_Speed :float = 800
var Clamped_Zoom:float = 0

const TOWERS = preload("res://Scenes/3D/Towers/Towers.tscn")
var Tower_Selected_Index:int = 0

const INDIVIDUAL_TROOP = preload("res://Scenes/3D/Troops/Individual_Troop.tscn")
var Individual_Troop_Selected_Index:int = 0


@onready var My_Ray_Cast = $RayCast3D

func _process(delta: float) -> void:
	Move_Camera(delta)
	
func Move_Camera(delta) -> void:
	#Se o Player Aperta Shift, Aumenta a Variavel Camera_Move_Speed e Camera_Rotation Speed
	var Input_Sprint = Input.is_action_pressed("Shift_Key")
	if Input_Sprint:
		Camera_Rotation_Speed = 100
		max_speed = 30
	else:
		max_speed = 15
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
	if rotating_on_middle_mouse_button == false:
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
		# My_Ray_Cast.Ray_Hit.get_owner() RETORNA O OBJETO QUE O RAYCAST ACERTOU
		#print(My_Ray_Cast.Ray_Hit.get_owner())
		if Input.is_action_just_released("left_mouse_click"):
			#Precisamos checkar o RayCast ta colidindo para rodar a logica, ou entao o resultado do
			#Raycas sera Null e o jogo crasha
			if (My_Ray_Cast.is_colliding()):
				if (My_Ray_Cast.Ray_Hit.get_owner() is Hexagono and CollisionCheck.is_a_card_being_dragged):#codigo para colocar a torre
					#Se a Grid Cell esta livre, ou seja, se a Placed_Tower for null, e vc selecionou uma Tile que nao é uma tile inimiga
					#vc pode colocar uma torre no lugar
					
					
					
					if (My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower == null) and (My_Ray_Cast.Ray_Hit.get_owner().is_enemy_tile == false):
						var Tower_Instance = TOWERS.instantiate() as Node3D
						get_tree().current_scene.add_child(Tower_Instance) 
						
						Tower_Instance.Troca_Pra_Torre_Pelo_Indice(Tower_Selected_Index)
						
						Tower_Instance.global_position = My_Ray_Cast.Ray_Hit.global_position
						
						Tower_Instance.Zerar_o_Tower_Range()#Zera o indicador visual do range da torre
						Tower_Instance.is_Tower_Place_on_Grid = true#Usada para evitar que a hovered tower de dano
						
						My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower = Tower_Instance#Cria uma referencia a torre
						
						My_Ray_Cast.Ray_Hit.get_owner().Occupied_Cell()
					elif(My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower != null):#Manda um Warning que o Player tentou colocar uma torre em uma grid ocupada
						SignalManager.occupied_tile_warning()
					elif (My_Ray_Cast.Ray_Hit.get_owner().is_enemy_tile == true):
						SignalManager.cannot_interact_with_enemy_field()
						#print("VOCE NÃO PODE COLOCAR TORRES EM BASES INIMIGAS, DUMB DUMB")
				elif (My_Ray_Cast.Ray_Hit.get_owner() is Enemy_Spawner):
					My_Ray_Cast.Ray_Hit.get_owner().Adcionar_Tropa_Ao_Enemy_Spawner()
				
		if Input.is_action_just_pressed("right_mouse_click"):
				#REMOVE A TORRE SE NO LUGAR DA GRID TINHA ALGO, ou seja, se nao era null
				if (My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower != null) and (My_Ray_Cast.Ray_Hit.get_owner() is Hexagono):
					
					My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower.queue_free()
					
					My_Ray_Cast.Ray_Hit.get_owner().Highlight()
					My_Ray_Cast.last_hovered = My_Ray_Cast.Ray_Hit.get_owner()
	
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			rotating_on_middle_mouse_button = true #Setado para poder rodar a camera
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)#Faz o mouse desaparecer

		elif Input.is_action_just_released("Middle_Mouse_Button"):
			rotating_on_middle_mouse_button = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion and rotating_on_middle_mouse_button:
		var delta = event.relative
		rotation_degrees.y -= (Camera_Rotation_Speed/512) * delta.x
	
	#TODO: MELHORAR ISSO AQUI
	if Input.is_action_just_pressed("1_Key"):
		Tower_Selected_Index = 0
	elif Input.is_action_just_pressed("2_Key"):
		Tower_Selected_Index = 1
