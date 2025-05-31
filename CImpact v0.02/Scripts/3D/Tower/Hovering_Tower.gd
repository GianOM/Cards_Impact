extends Node3D


#TODO: THIS IS A DUMB WAY OF DOING THIS. FIND A BETTER ONE
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
		6:
			Hide_All_Meshes()
			$Index_6.show()
			
func Hide_All_Meshes():
	$Index_0.hide()
	$Index_1.hide()
	$Index_2.hide()
	$Index_3.hide()
	$Index_4.hide()
	$Index_5.hide()
	$Index_6.hide()
