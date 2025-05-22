extends Node3D

#Dimensoes do Hexagono:
# x = 3.46
# y = 4
#Alem disso, ele esta centralizado na origem
const Hex_Tile = preload("res://Scenes/3D/Grid/Hexagon Tile.tscn")#Referencia à cena que contem o unico hexagono
const HEX_SCALE = 1
const HEXAGON_SIZE_IN_METERS :Vector2 = Vector2(3.66,4.24)

@export var is_enemy_grid: bool = false#Variavel usada para diferenciar grid aliada de inimiga

var Tile_Placement_Coordinates: Vector2#Variavel usada para colocar o Tile na posicao certa
const TILE_GRID_SIZE: Vector2 = Vector2(31,27)#Tamanho 

func _ready() -> void:
	_generate_grid()#Assim que comeca o game gera a grid
	
func _generate_grid():
	for x in range(TILE_GRID_SIZE.x):
		Tile_Placement_Coordinates.x += HEXAGON_SIZE_IN_METERS.x * cos(deg_to_rad(30))
		Tile_Placement_Coordinates.y = 0.0 if (x%2 == 0) else (HEXAGON_SIZE_IN_METERS.x/2)#Desloca as grids, quando estiver nas posicoes pares
		
		for y in range(TILE_GRID_SIZE.y):
			var Hex_Tile_Instance = Hex_Tile.instantiate() as Node3D
			SceneSwitcher.current_scene.add_child.call_deferred(Hex_Tile_Instance)
			#SceneSwitcher.get_tree().current_scene.add_child.call_deferred(Hex_Tile_Instance)
			
			#Checka se a posicao a ser colocada a tile esta ocupada por alguma Area3d + CollisionShape3D. Se estiver
			#Apaga a Tile, caso contrario, move ela e da scale
			if Hex_Tile_Instance.Check_Overlap_Collision(Vector3(global_position.x + Tile_Placement_Coordinates.y, 0, global_position.z + Tile_Placement_Coordinates.x)) == true:
				Hex_Tile_Instance.queue_free()
			else:
				#Nao podemos usar global_position em nodes que ainda nao estao na scene tree. Para isto, usamos o Transform Origin
				Hex_Tile_Instance.transform.origin = Vector3(global_position.x + Tile_Placement_Coordinates.y, 0, global_position.z + Tile_Placement_Coordinates.x)#Precisa ficar invertido
				Hex_Tile_Instance.scale = Vector3(HEX_SCALE,HEX_SCALE,HEX_SCALE)#o Scale é UNIFORME
				
				if is_enemy_grid == true:
					Hex_Tile_Instance.is_enemy_tile = true
			
			
			Tile_Placement_Coordinates.y += HEXAGON_SIZE_IN_METERS.x
