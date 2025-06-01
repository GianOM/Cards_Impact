extends RayCast3D

# --- Constantes ---
const TOWERS_SCENE = preload("res://Scenes/3D/Towers/Hovering_Tower.tscn")
const INDIVIDUAL_TROOP_SCENE = preload("res://Scenes/3D/Troops/Hovering Troop.tscn")


const INSTANCE_SCALE_HIDDEN = Vector3(0.0002, 0.0002, 0.0002)
const INSTANCE_SCALE_VISIBLE = Vector3(1.0, 1.0, 1.0)
const RAYCAST_DISTANCE = 8192.0

# --- Nodes Onready ---
@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var player: Node3D = $".."


# --- Instâncias de Cenas ---
@export var Tower_Instance: Node3D
@export var Troop_Instance: Node3D


var Ray_Hit: Object# Esta variavel precisa ser global para ser acessada por outros nodes
#O seu tipo e "Object" pq nao sabemos ainda o que o Ray_Hit vai acertar

var last_hovered: Hexagono
var remove_range_hovering: Hexagono
# --- Multiplayer Variables ---

var Owner_ID: int

func _ready() -> void:
	
	Owner_ID = player.name.to_int()
	set_multiplayer_authority(Owner_ID)
	
	Tower_Instance = TOWERS_SCENE.instantiate()
	Troop_Instance = INDIVIDUAL_TROOP_SCENE.instantiate()
	
	Troop_Instance.set_mesh_from_tier(0)#Mostra uma malha tier 1 Temporariamente
	Tower_Instance.set_mesh_from_tier(0)
	
	SceneSwitcher.current_scene.add_child.call_deferred(Tower_Instance) 
	SceneSwitcher.current_scene.add_child.call_deferred(Troop_Instance)
	#Precisamos usar o SceneSwitcher.current_scene para obtermos a TScene atual

	#ADCIONAMOS A TORRE NUMA ESCALA PEQUENA ASSIM Q COMECA O GAME
	Tower_Instance.scale = INSTANCE_SCALE_HIDDEN
	Troop_Instance.scale = INSTANCE_SCALE_HIDDEN
	

func _process(_delta: float) -> void:
	if Owner_ID == multiplayer.get_unique_id():
		Update_Raycast_Target()# O raycast é atualizado atraves do MultiplayerSynchronizer
	Screen_Point_to_Ray()

func Update_Raycast_Target() -> void:
	var mouse_Position = get_viewport().get_mouse_position()
	#get_viewport().get_mouse_position() Retorna a posicao do mouse na tela, aumentando da esquerda para direita e
	# de cima para baixo
	
	#Seta a Origem e o alvo do RayCast
	position = camera_3d.project_ray_origin(mouse_Position)
	target_position = position + (camera_3d.project_ray_normal(mouse_Position)) * 8192#QUANTO MAIOR ESTE NUMERO, MAIS PRECISO E O RAYCAS
	
func Screen_Point_to_Ray() -> void:
	if is_colliding():
		# Esta variavel precisa ser global para ser acessada por outros nodes
		# O seu tipo e "Object" pq nao sabemos ainda o que o Ray_Hit vai acertar
		Ray_Hit = get_collider()
		var Ray_Hit_Owner = Ray_Hit.get_owner()#Precisamos catar o Owner para saber sua classe e sua posicao
		#o check de hexagono tem que vir antes de tentar pegarmos o owner, 
		#ou entao, ele vai crashar ao tentar selecionar uma tropa
		if Ray_Hit_Owner is Hexagono:
			Troop_Instance.scale = INSTANCE_SCALE_HIDDEN
			#CollisionCheck.card_id_attack é -1 para cartas de defesa
			#CollisionCheck.card_id_defense é -1 para cartas de ataque
			if CollisionCheck.is_a_card_being_dragged and Ray_Hit_Owner.Placed_Tower == null and CollisionCheck.card_id_attack == -1:

				#O indice e setado no Player Movement usando eventos
				Tower_Instance.scale = INSTANCE_SCALE_VISIBLE
				Tower_Instance.global_position = Ray_Hit.global_position
			else:
				Tower_Instance.scale = INSTANCE_SCALE_HIDDEN
				
				
			if last_hovered and (last_hovered.Placed_Tower == null):
				#Remove o Highlight do Hex Tile se o ultimo HexTile que o Raycast colidiu esta vazio
				last_hovered.Remove_Highlight()
					
			if (Ray_Hit_Owner and (Ray_Hit_Owner.Placed_Tower == null)):
				#Se o Raycast acertar uma Tile vazia, coloca o material de Highlight nela
				Ray_Hit_Owner.Highlight()
				last_hovered = Ray_Hit_Owner
			
			#O CODIGO ABAIXO MOSTRA E ESCONDE O TOWER RANGE SE ESTIVER HOVERING
			if (Ray_Hit_Owner != remove_range_hovering) and (remove_range_hovering != null):
				if (remove_range_hovering.Placed_Tower!= null):
					remove_range_hovering.Placed_Tower.Zerar_o_Tower_Range()
			
			if Ray_Hit_Owner.Placed_Tower != null:
					Ray_Hit_Owner.Placed_Tower.Show_Tower_Range_When_Hovered()
					remove_range_hovering = Ray_Hit_Owner
			#Impede que o Tower Hover esteja visivel quando passar o mouse por uma tile que ja
			#possui uma torre
			
		#Garante que
		elif Ray_Hit_Owner is Enemy_Spawner and  CollisionCheck.is_a_card_being_dragged:
			Troop_Instance.set_mesh_from_tier(player.Global_Card_Index)
			
			Troop_Instance.scale = INSTANCE_SCALE_VISIBLE
			Troop_Instance.global_position = Ray_Hit.global_position
			Tower_Instance.scale = INSTANCE_SCALE_HIDDEN

		elif last_hovered:
			last_hovered.Remove_Highlight()
			#O RayCast3D sempre entre nesta condicao quando ele colide com algo
			#que nao seja um Hexagono, como por exemplo o Enemy Spawner
			Tower_Instance.scale = INSTANCE_SCALE_HIDDEN
			Troop_Instance.scale = INSTANCE_SCALE_HIDDEN
			
			
	else :
		#Se nao colidir com nada, deixa a torre e a Tropa
		Tower_Instance.scale = INSTANCE_SCALE_HIDDEN
		Troop_Instance.scale = INSTANCE_SCALE_HIDDEN
		
		if last_hovered and (last_hovered.Placed_Tower == null):
			last_hovered.Remove_Highlight()
			last_hovered = null
		
		if remove_range_hovering != null :
			if (remove_range_hovering.Placed_Tower!= null):
			#Para o caso de colocar a torre em um Hexagono, verificar o range dela
			# dando hovering, e o mouse sumir para a PQP
				remove_range_hovering.Placed_Tower.Zerar_o_Tower_Range()
