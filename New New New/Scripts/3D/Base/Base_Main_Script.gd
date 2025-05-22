extends Node3D

var Base_Possible_Targets:Array[Moving_Units]

@onready var base_projectile_origin_marker_3d: Marker3D = $Base_Projectile_Origin_Marker3D

@onready var base_projectiles_container: Node = $Base_Projectiles_Container

var Base_Projectiles:Array[Projetil]

const PROJECTILE = preload("res://Scenes/3D/Projectile/Projectile.tscn")

func _process(delta: float) -> void:
	
	if Base_Projectiles.size() > 32:
		Base_Projectiles = Base_Projectiles.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		Base_Possible_Targets.append(body)


func _on_base_buller_spawner_timer_timeout() -> void:
	if Base_Possible_Targets.size() > 0:
			var temp_projectile : Projetil = PROJECTILE.instantiate()#Precisamos desta varial...PQ???
			get_tree().root.add_child(temp_projectile)
			temp_projectile.global_position = base_projectile_origin_marker_3d.global_position
			temp_projectile.seleciona_mesh_pelo_indice(1)
			
			for n in range (Base_Possible_Targets.size()):
				if Base_Possible_Targets[n] != null:
					temp_projectile.set_projectile_target(Base_Possible_Targets[n])
					break
			
			temp_projectile.is_Projectile_Flying = true
			Base_Projectiles.append(temp_projectile)
