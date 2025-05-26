extends Node3D

# --- Node Onready ---
@onready var camera_3d: Camera3D = $Camera3D
@onready var My_Ray_Cast: RayCast3D = $RayCast3D # Renomeado para clareza e consistência


# --- Constantes de Movimento da Câmera ---
const DEFAULT_ACCELERATION: float = 50.0#Uma boa aceleracao pra garantir que o jogo seja responsivo
const DEFAULT_MAX_SPEED: float = 15.0
const SPRINT_MAX_SPEED: float = 30.0
const FRICTION: float = 22.0

var velocity: Vector3 = Vector3.ZERO
var max_speed: float = 15


# --- Variáveis de Estado da Câmera ---
var rotating_on_middle_mouse_button :bool = false#Variavel usada para rotacionar a camera com o botao do mouse
var Camera_Rotation_Speed :float = 50
var Camera_Zoom_Speed :float = 800
var Clamped_Zoom:float = 0

# --- Constantes de Cenário ---
const TOWERS_SCENE = preload("res://Scenes/3D/Towers/Towers.tscn")
const INDIVIDUAL_TROOP_SCENE = preload("res://Scenes/3D/Troops/Troops Database/Tier_1_PAWN.tscn")

@export var Tower_Selected_Index:int = 0
var Individual_Troop_Selected_Index:int = 0

# --- Times ---
#Variavel usada para separar os times e impedir que um possa influenciar o grid do outro
@export var My_Team :int = 0 #Host Pertence ao time 0


# --- Multiplayer Variables ---
var Owner_ID: int
#Trocar pra _enter_tree conserta o Bug, Erro, porem temos que atualizar todo frame
func _enter_tree() -> void:
	#Setamos o Multiplayer Authority de cada player para o seu Unique Peer ID
	#Assim, o player com o nome "1530935"(um Client) somente tem autoridade sobre 
	#um dos players
	Owner_ID = name.to_int()
	set_multiplayer_authority(Owner_ID)
	
	#Assinala o Time garantindo que o Host seja de um time e Todos os Clients
	#sejam de outro time
	if multiplayer.get_unique_id() == 1:
		My_Team = 0
	else:
		My_Team = 1
	

func _process(delta: float) -> void:
	#print(multiplayer.get_unique_id())
	if Owner_ID == multiplayer.get_unique_id():
		camera_3d.make_current()
		
		Handle_Camera_Movement(delta)
		Handle_Camera_Rotation(delta)
		Handle_Camera_Zoom(delta)
		
		Handle_Mouse_Click()
	
	
func Handle_Camera_Movement(delta: float) -> void:
	var Input_Sprint = Input.is_action_pressed("Shift_Key")
	if Input_Sprint:
		max_speed = SPRINT_MAX_SPEED
	else:
		max_speed = DEFAULT_MAX_SPEED
		
	#Input_Direction e uma tupla do tipo (x,y), onde x e y vao de -1(Tecla A ou S) ate 1(Tecla D ou W)
	var Input_Direction = Input.get_vector("A_Key","D_Key","W_Key","S_Key")
	#As direcoes da camera mudam conforme ela gira. Logo, precisamos atualizar, multiplicando pela direcao local e normalizando
	var movement_direction = (transform.basis * Vector3(Input_Direction.x,0,Input_Direction.y) ).normalized()
	
	if movement_direction != Vector3.ZERO:
		# Aplica inercia de movimento
		velocity = velocity.move_toward(movement_direction * max_speed, DEFAULT_ACCELERATION * delta)
	else:
		# Aplica friccao
		velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)
	
	#Atualiza a Posicao do Node3D Player
	position += velocity*delta
	
func Handle_Camera_Rotation(delta: float) -> void:
	#Se o Player Aperta Shift, Aumenta a Variavel Camera_Move_Speed e Camera_Rotation Speed
	var Input_Sprint = Input.is_action_pressed("Shift_Key")
	if Input_Sprint:
		Camera_Rotation_Speed = 100
	else:
		Camera_Rotation_Speed = 50
	
	#Input_Rotation é um float que vai de -1(Quando aperta-se Q) ate +1(Quando Aperta-se E)
	var Input_Rotation = Input.get_axis("E_Key","Q_Key")
	if rotating_on_middle_mouse_button == false:
		rotation_degrees.y += Camera_Rotation_Speed * Input_Rotation * delta
	


func Handle_Camera_Zoom(delta:float) -> void:
	var zoom_direction = (int(Input.is_action_just_released("Scroll_Down"))
						- int(Input.is_action_just_released("Scroll_Up")) )
						
	#Clamped_Zoom limita o Zoom de um valor acumulado -5 ate +3
	var zoom_amount = Camera_Zoom_Speed * zoom_direction * delta
	var new_zoom = clamp(Clamped_Zoom + zoom_amount, -5.0, 45.0)
	zoom_amount = new_zoom - Clamped_Zoom
	Clamped_Zoom = new_zoom

	camera_3d.translate_object_local(Vector3(0, 0, zoom_amount))
		
	camera_3d.rotation.x = clamp(camera_3d.rotation.x - zoom_direction * 0.01, -1.25, -1.01)#Rotaciona a camera pra cima e para baixo um pouco quando da zoom
	
func Handle_Mouse_Click():
	if Input.is_action_just_released("left_mouse_click"):
		#Precisamos checkar o RayCast ta colidindo para rodar a logica, ou entao o resultado do
		#Raycas sera Null e o jogo crasha
		if (My_Ray_Cast.is_colliding()):
		# My_Ray_Cast.Ray_Hit.get_owner() RETORNA O OBJETO QUE O RAYCAST ACERTOU
		#print(My_Ray_Cast.Ray_Hit.get_owner())
			#Checkamos se o Resultado do Raycast é um Hexagono e se há alguma carta sendo arrastada. Se sim, roda a parte abaixo
			if My_Ray_Cast.Ray_Hit.get_owner() is Hexagono and CollisionCheck.is_a_card_being_dragged:#codigo para colocar a torre
				#Se a Grid Cell esta livre, ou seja, se a Placed_Tower for null, e vc selecionou uma Tile que nao é uma tile inimiga
				#vc pode colocar uma torre no lugar
				if (My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower == null) and (My_Ray_Cast.Ray_Hit.get_owner().Hexagon_Team == My_Team):
					#CODIGO PARA BOTAR A TORRE
					
					Create_Tower_at_Clicked.rpc()
					
				elif(My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower != null):#Manda um Warning que o Player tentou colocar uma torre em uma grid ocupada
					SignalManager.occupied_tile_warning()
				elif (My_Ray_Cast.Ray_Hit.get_owner().Hexagon_Team != My_Team):
					SignalManager.cannot_interact_with_enemy_field()
					print("NAO PODE COLOCAR TORRES NO CAMPO INIMIGO")
					
			elif (My_Ray_Cast.Ray_Hit.get_owner() is Enemy_Spawner):
				#Troop_Spawner_Team e uma variavel do Enemy Spawner que é setada pelo PATH no ready
				if My_Ray_Cast.Ray_Hit.get_owner().Troop_Spawner_Team == My_Team:
					#My_Ray_Cast.Ray_Hit.get_owner().rpc("Adcionar_Tropa_Ao_Enemy_Spawner", Tower_Selected_Index)
					My_Ray_Cast.Ray_Hit.get_owner().Adcionar_Tropa_Ao_Enemy_Spawner(Tower_Selected_Index)
				else:
					print("VOCE NAO PODE ADCIONAR TROPAS PARA ATACAR SUA PROPRIA BASE")
				
				
	
	
@rpc("any_peer","call_local","reliable")
func Create_Tower_at_Clicked():
	var Tower_Instance = TOWERS_SCENE.instantiate() as Node3D
	get_tree().current_scene.add_child(Tower_Instance) 
	
	Tower_Instance.Troca_Pra_Torre_Pelo_Indice(Tower_Selected_Index)
	
	Tower_Instance.global_position = My_Ray_Cast.Ray_Hit.global_position
	
	Tower_Instance.Zerar_o_Tower_Range()#Zera o indicador visual do range da torre
	Tower_Instance.is_Tower_Place_on_Grid = true#Usada para evitar que a hovered tower de dano
	
	My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower = Tower_Instance#Cria uma referencia a torre
	
	My_Ray_Cast.Ray_Hit.get_owner().Occupied_Cell()
	
@rpc("any_peer","call_local","reliable")
func Delete_Tower_at_Clicked():
	#REMOVE A TORRE SE NO LUGAR DA GRID TINHA ALGO, ou seja, se nao era null
	My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower.queue_free()
	
	My_Ray_Cast.Ray_Hit.get_owner().Highlight()
	My_Ray_Cast.last_hovered = My_Ray_Cast.Ray_Hit.get_owner()
	
	
	
#TODO: MELHORAR ISSO AQUI !!!
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_mouse_click"):
		if Owner_ID == multiplayer.get_unique_id():
			if (My_Ray_Cast.is_colliding()):
				if My_Ray_Cast.Ray_Hit.get_owner() is Hexagono:
					if (My_Ray_Cast.Ray_Hit.get_owner().Placed_Tower != null):
						Delete_Tower_at_Clicked.rpc()
						
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			if Owner_ID == multiplayer.get_unique_id():
				rotating_on_middle_mouse_button = true #Setado para poder rodar a camera
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)#Faz o mouse desaparecer

	elif Input.is_action_just_released("Middle_Mouse_Button"):
			if Owner_ID == multiplayer.get_unique_id():
				rotating_on_middle_mouse_button = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and rotating_on_middle_mouse_button:
			if Owner_ID == multiplayer.get_unique_id():
				var delta = event.relative
				rotation_degrees.y -= (Camera_Rotation_Speed/512) * delta.x
	#TODO: MELHORAR ISSO AQUI
	if Input.is_action_just_pressed("1_Key"):
		if Owner_ID == multiplayer.get_unique_id():
			Tower_Selected_Index = 0
			My_Ray_Cast.Tower_Instance.Troca_Pra_Torre_Pelo_Indice(Tower_Selected_Index)
			My_Ray_Cast.Troop_Instance.set_mesh_from_tier(Tower_Selected_Index)
	elif Input.is_action_just_pressed("2_Key"):
		if Owner_ID == multiplayer.get_unique_id():
			Tower_Selected_Index = 1
			My_Ray_Cast.Tower_Instance.Troca_Pra_Torre_Pelo_Indice(Tower_Selected_Index)
			My_Ray_Cast.Troop_Instance.set_mesh_from_tier(Tower_Selected_Index)
