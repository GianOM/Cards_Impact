extends Node3D



var Tower_Database: Array[Tower_Data] = []


func Load_Tower_Resource_Database(path:String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				#O CODIGO ABAIXO E PARA CONSEGUIR RODAR QUANDO EXPORTED:
				#https://github.com/godotengine/godot/issues/66014
				if '.tres.remap' in file_name: # <---- NEW
					file_name = file_name.trim_suffix('.remap') # <---- NEW
					
				var file_path = path.path_join(file_name)
				var resource = load(file_path)
				#print("Found file: " + file_name)
				Tower_Database.append(resource)
			file_name = dir.get_next()
			
			
func Set_Tower_Range_from_Index(idx:int):
	if Tower_Database.size() == 0:
		Load_Tower_Resource_Database("res://Scripts/3D/Tower/Data/")
		
	var Novo_Raio = Tower_Database[idx].Tower_Range
	$Tower_Range.scale = Vector3(0.1*Novo_Raio,
								0.1*Novo_Raio,
								0.1*Novo_Raio)


#TODO: THIS IS A DUMB WAY OF DOING THIS. FIND A BETTER ONE
func set_mesh_from_tier(index: int):
	#Tower_Data_Resource.Tower_Range
	
	match index:
		0:
			Hide_All_Meshes()
			Set_Tower_Range_from_Index(0)
			$Index_0.show()
		1:
			Hide_All_Meshes()
			Set_Tower_Range_from_Index(1)
			$Index_1.show()
			
		2:
			Hide_All_Meshes()
			Set_Tower_Range_from_Index(2)
			$Index_2.show()
			
		3:
			Hide_All_Meshes()
			Set_Tower_Range_from_Index(3)
			$Index_3.show()
		4:
			Hide_All_Meshes()
			Set_Tower_Range_from_Index(4)
			$Index_4.show()
		5:
			Hide_All_Meshes()
			Set_Tower_Range_from_Index(5)
			$Index_5.show()
		6:
			Hide_All_Meshes()
			Set_Tower_Range_from_Index(6)
			$Index_6.show()
			
			
			
			
			
			
			
#TODO: FIX THIS DUMB SHIT
#1. Colocar os Vectors 4 como variaveis
#2. Get the active mesh index to avoid changing all of them
func set_shader_color_based_on_raycast_result(is_in_Correct_field: bool):
	if is_in_Correct_field:
		$"Index_0/Rook Tower".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Index_1/Tower_Tier_2.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Index_2/Jenga.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$"Index_3/Banco Imobiliario".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Index_4/Santorini.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Index_5/Bunker.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$"Index_6/Money Tower".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		$Tower_Range.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(0.318,0.961,0.086,1))
		
		
	else:
		$"Index_0/Rook Tower".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Index_1/Tower_Tier_2.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Index_2/Jenga.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$"Index_3/Banco Imobiliario".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Index_4/Santorini.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Index_5/Bunker.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$"Index_6/Money Tower".get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
		$Tower_Range.get_active_material(0).set_shader_parameter("Main_Hover_Color", Vector4(1,0,0,1))
	

func Hide_All_Meshes():
	$Index_0.hide()
	$Index_1.hide()
	$Index_2.hide()
	$Index_3.hide()
	$Index_4.hide()
	$Index_5.hide()
	$Index_6.hide()
