extends Node3D


func set_mesh_from_tier(index: int):
	#Como fazer um Switch/Case padrao
	match index:
		0:
			Hide_All_Meshes()
			$Index_0.show()
		1:
			Hide_All_Meshes()
			$Index_1.show()
			
		2:
			Hide_All_Meshes()
			$Index_2.show()
			
		3:
			Hide_All_Meshes()
			$Index_3.show()
		4:
			Hide_All_Meshes()
			$Index_4.show()
		5:
			Hide_All_Meshes()
			$Index_5.show()
			
			
			
func set_shader_color_based_on_raycast_result(is_in_Correct_field: bool):
	if is_in_Correct_field:
		$Index_0/Pawn.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Index_1/Bishop.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Index_2/Horse.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$"Index_3/Monopoly Car".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$"Index_4/Monopoly Hat".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Index_5/Domino.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		
	else:
		$Index_0/Pawn.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Index_1/Bishop.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Index_2/Horse.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$"Index_3/Monopoly Car".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$"Index_4/Monopoly Hat".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Index_5/Domino.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		
		
func Hide_All_Meshes():
	$Index_0.hide()
	$Index_1.hide()
	$Index_2.hide()
	$Index_3.hide()
	$Index_4.hide()
	$Index_5.hide()
	
