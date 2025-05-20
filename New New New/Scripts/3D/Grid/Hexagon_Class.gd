class_name Hexagono
extends Node3D

#se Placed_Tower for Null, e pq nao tem nada na Grid Cell
var Placed_Tower : Torre = null


@onready var hexagon_grid: MeshInstance3D = $Hexagon_Grid


var MAT_1 = preload("res://Assets/3D Assets/Grid/Default_Grid_Material.tres")
var MAT_2 = preload("res://Assets/3D Assets/Grid/Highlighted_Grid_Material.tres.tres")
var MAT_3 = preload("res://Assets/3D Assets/Grid/Occupied_Grid_Material.tres")

func Occupied_Cell():
	hexagon_grid.material_override = null#Precisamos assinalar a Null para assim dar Override
	hexagon_grid.set_surface_override_material(0, MAT_3)

func Highlight():

	hexagon_grid.material_override = null#Precisamos assinalar a Null para assim dar Override
	hexagon_grid.set_surface_override_material(0, MAT_2)
	
func Remove_Highlight():

	hexagon_grid.material_override = null
	hexagon_grid.set_surface_override_material(0, MAT_1)
	
	
func Check_Overlap_Collision(Posicao_do_Ponto_Para_Testar:Vector3):
	#Funcao usada para testar se o um certo ponto colide com alguma 
	#Area3d. Se sim, retorna true, se nao retorna false
	
	#Para fazer isto, precisamos fazer um Query pra Engine de Fisica do Godot.
	#Por boas praticas, limpa-se o querry antes
	var space_state = null
	var shape_query = null

	#Cria o novo Querry
	shape_query = PhysicsPointQueryParameters3D.new()
	
	
	#Seta o Parametros do Querry
	shape_query.collide_with_areas = true
	shape_query.collide_with_bodies = true
	shape_query.position = Posicao_do_Ponto_Para_Testar
	
	#Retorna o resultado do Querry
	space_state = SceneSwitcher.current_scene.get_world_3d().direct_space_state
	var result = space_state.intersect_point(shape_query)
	
	if result.size() > 0:
		return true
		
	return false
