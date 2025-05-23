extends RayCast3D

const HEXAGON_SCENE = preload("res://Scenes/3D/Grid/Hexagon Tile.tscn")

@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var player: Node3D = $".."

const TOWERS = preload("res://Scenes/3D/Towers/Towers.tscn")
var Tower_Instance = TOWERS.instantiate() as Node3D

const INDIVIDUAL_TROOP = preload("res://Scenes/3D/Troops/Individual_Troop.tscn")
var Troop_Instance = INDIVIDUAL_TROOP.instantiate() as Node3D



var Ray_Hit: Object# Esta variavel precisa ser global para ser acessada por outros nodes
#O seu tipo e "Object" pq nao sabemos ainda o que o Ray_Hit vai acertar

#Variavel para o Killer fazer a carta sumir. Se for true, o mouse ta passando por uma
#grid cell, se for false, nao esta
var is_Mouse_Hitting_a_Hex_Cell : bool

var last_hovered: Hexagono
var remove_range_hovering: Hexagono
#------------------------removed/commented from here

func _ready() -> void:      
	SceneSwitcher.current_scene.add_child.call_deferred(Tower_Instance) 
	SceneSwitcher.current_scene.add_child.call_deferred(Troop_Instance)
	#Precisamos usar o SceneSwitcher.current_scene para obtermos a TScene atual

	#ADCIONAMOS A TORRE NUMA ESCALA PEQUENA ASSIM Q COMECA O GAME
	Tower_Instance.scale = Vector3(0.01,0.01,0.01)
	Troop_Instance.scale = Vector3(0.01,0.01,0.01)

func _process(_delta: float) -> void:
	Screen_Point_to_Ray()

func Screen_Point_to_Ray() -> void:
	var mouse_Position = get_viewport().get_mouse_position()
	#get_viewport().get_mouse_position() Retorna a posicao do mouse na tela, aumentando da esquerda para direita e
	# de cima para baixo
	
	#TO DO: LIMITAR O RAY CAST PARA SOMENTE 60% DA ALTURA PARA NAO DAR PROBLEMA COM AS CARTAS
	
	#Seta a Origem e o alvo do RayCast
	position = camera_3d.project_ray_origin(mouse_Position)
	target_position = position + (camera_3d.project_ray_normal(mouse_Position)) * 8192#QUANTO MAIOR ESTE NUMERO, MAIS PRECISO E O RAYCAS

	if is_colliding():
		# Esta variavel precisa ser global para ser acessada por outros nodes
		# O seu tipo e "Object" pq nao sabemos ainda o que o Ray_Hit vai acertar
		Ray_Hit = get_collider()
		var Ray_Hit_Owner = Ray_Hit.get_owner()#Precisamos catar o Owner para saber sua classe e sua posicao
		#o check de hexagono tem que vir antes de tentar pegarmos o owner, 
		#ou entao, ele vai crashar ao tentar selecionar uma tropa
		if Ray_Hit_Owner is Hexagono and CollisionCheck.is_a_card_being_dragged:
			
			CollisionCheck.is_mouse_hitting_a_hex_cell = true
			
			Troop_Instance.scale = Vector3(0.01,0.01,0.01)
			
			
			Tower_Instance.Troca_Pra_Torre_Pelo_Indice(player.Tower_Selected_Index)
			Tower_Instance.global_position = Ray_Hit.global_position
			
			is_Mouse_Hitting_a_Hex_Cell = true
			
			if last_hovered and (last_hovered.Placed_Tower == null):
				last_hovered.Remove_Highlight()
					
			if (Ray_Hit_Owner and (Ray_Hit_Owner.Placed_Tower == null)):
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
			if Ray_Hit_Owner.Placed_Tower == null:
				Tower_Instance.scale = Vector3(1,1,1)
			else:
				Tower_Instance.scale = Vector3(0.01,0.01,0.01)
		
		elif Ray_Hit_Owner is Enemy_Spawner:
			
			CollisionCheck.is_mouse_hitting_a_hex_cell = false
			
			Troop_Instance.scale = Vector3(1,1,1)
			Troop_Instance.global_position = Ray_Hit.global_position
			Tower_Instance.scale = Vector3(0.01,0.01,0.01)

		elif last_hovered:
			last_hovered.Remove_Highlight()
			#O RayCast3D sempre entre nesta condicao quando ele colide com algo
			#que nao seja um Hexagono, como por exemplo o Enemy Spawner
			Tower_Instance.scale = Vector3(0.01,0.01,0.01)
			Troop_Instance.scale = Vector3(0.01,0.01,0.01)
			
			CollisionCheck.is_mouse_hitting_a_hex_cell = false
			
	else :
		
		CollisionCheck.is_mouse_hitting_a_hex_cell = false
		
		is_Mouse_Hitting_a_Hex_Cell = false
		Tower_Instance.scale = Vector3(0.01,0.01,0.01)#Se nao colidir com nada, deixa a torre pequena e apaga a grid cell
		Troop_Instance.scale = Vector3(0.01,0.01,0.01)
		
		if last_hovered and (last_hovered.Placed_Tower == null):
			last_hovered.Remove_Highlight()
			last_hovered = null
		
		if remove_range_hovering != null :
			if (remove_range_hovering.Placed_Tower!= null):
			#Para o caso de colocar a torre em um Hexagono, verificar o range dela
			# dando hovering, e o mouse sumir para a PQP
				remove_range_hovering.Placed_Tower.Zerar_o_Tower_Range()
