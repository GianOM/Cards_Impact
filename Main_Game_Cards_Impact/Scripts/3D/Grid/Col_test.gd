extends StaticBody3D

@onready var hexagon: Hexagono = $"../.."

func Teste_de_Colisao_Com_Paths(Posicao_do_Ponto_Para_Testar:Vector3) -> bool:
	
	var space_state = null
	var shape_query = null

	shape_query = PhysicsPointQueryParameters3D.new()
	
	shape_query.collide_with_areas = true
	shape_query.collide_with_bodies = true
	shape_query.position = Posicao_do_Ponto_Para_Testar
	

	space_state = SceneSwitcher.current_scene.get_world_3d().direct_space_state
	var result = space_state.intersect_point(shape_query)
	
	if result.size() > 0:
		return true
		
	return false
