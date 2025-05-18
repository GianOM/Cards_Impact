extends RayCast3D

const HEXAGON_SCENE = preload("res://Scenes/3D/Grid/Hexagon Tile.tscn")

@onready var camera_3d: Camera3D = $"../Camera3D"
#@onready var tower_example: Node3D = $"../Tower Example"

const TOWERS = preload("res://Scenes/3D/Towers/Towers.tscn")
var Tower_Instance = TOWERS.instantiate() as Node3D


var Ray_Hit: Object# Esta variavel precisa ser global para ser acessada por outros nodes

#Variavel para o Killer fazer a carta sumir. Se for true, o mouse ta passando por uma
#grid cell, se for false, nao esta
var is_Mouse_Hitting_a_Hex_Cell : bool

var last_hovered: Hexagono
#------------------------removed/commented from here

func _ready() -> void:      
	SceneSwitcher.current_scene.add_child.call_deferred(Tower_Instance) 
	#Precisamos usar o SceneSwitcher.current_scene para obtermos a TScene atual

	#ADCIONAMOS A TORRE NUMA ESCALA PEQUENA ASSIM Q COMECA O GAME
	Tower_Instance.scale = Vector3(0.01,0.01,0.01)


#---------------------------------------to here

func _process(_delta: float) -> void:
	Screen_Point_to_Ray()
	#print(is_Mouse_Hitting_a_Hex_Cell)

func Screen_Point_to_Ray() -> void:
	var mouse_Position = get_viewport().get_mouse_position()
	#get_viewport().get_mouse_position() Retorna a posicao do mouse na tela, aumentando da esquerda para direita e
	# de cima para baixo
	
	var Ray_Cast_Origin = camera_3d.project_ray_origin(mouse_Position)
	var Ray_Cast_Target = Ray_Cast_Origin + (camera_3d.project_ray_normal(mouse_Position)) * 8192#QUANTO MAIOR ESTE NUMERO, MAIS PRECISO E O RAYCAS
	
	position = Ray_Cast_Origin
	target_position = Ray_Cast_Target

	if is_colliding():
		
		Ray_Hit = get_collider()
		var Ray_Hit_Owner = Ray_Hit.get_owner()#Precisamos catar o Owner para saber sua classe e sua posicao
		
		if Ray_Hit_Owner is Hexagono:
			
			is_Mouse_Hitting_a_Hex_Cell = true
			
			if last_hovered and (last_hovered.Placed_Tower == null):
				last_hovered.Remove_Highlight()
					
			if (Ray_Hit_Owner and (Ray_Hit_Owner.Placed_Tower == null)):
				Ray_Hit_Owner.Highlight()
				last_hovered = Ray_Hit_Owner

			#Impede que o Tower Hover esteja visivel quando passar o mouse por uma tile que ja
			#possui uma torre
			if Ray_Hit_Owner.Placed_Tower == null:
				Tower_Instance.scale = Vector3(20,20,20)
			else:
				Tower_Instance.scale = Vector3(0.01,0.01,0.01)

		elif last_hovered:
			last_hovered.Remove_Highlight()
			#last_hovered = null
			
		Tower_Instance.global_position = Ray_Hit.global_position

	else :
		is_Mouse_Hitting_a_Hex_Cell = false
		Tower_Instance.scale = Vector3(0.01,0.01,0.01)#Se nao colidir com nada, deixa a torre pequena e apaga a grid cell
		if last_hovered and (last_hovered.Placed_Tower == null):
			last_hovered.Remove_Highlight()
			last_hovered = null
