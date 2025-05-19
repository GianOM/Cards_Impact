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
	var static_body_3d: StaticBody3D = $Hexagon_Grid/StaticBody3D
	
	#Funcao usada para apagar a grid cell unit se ela colide com algum Node que contem uma 
	#Area3D Com um CollisionShape3D
	return static_body_3d.Teste_de_Colisao_Com_Paths(Posicao_do_Ponto_Para_Testar)
