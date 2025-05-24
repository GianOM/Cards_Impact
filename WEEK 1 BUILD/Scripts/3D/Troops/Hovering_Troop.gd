extends Node3D


func set_mesh_from_tier(index: int):
	match index:
		0:
			$Tier_1.show()
			$Tier_2.hide()
		1:
			$Tier_1.hide()
			$Tier_2.show()
