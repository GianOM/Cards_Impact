class_name Projectile_Generator extends Marker3D


const PROJECTILE = preload("res://Scenes/3D/Projectile/Projectile.tscn")

var Possible_Targets_for_Projectiles:Array[Moving_Units]


var List_of_Projectiles:Array[Projetil]

var Tower_Index: int
var Tower_Damage:float


func Clean_Up_Projectile_Array():
	List_of_Projectiles = List_of_Projectiles.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null


func Spawn_a_Prjectile(Array_of_Targets:Array[Moving_Units]) -> void:
	var temp_projectile : Projetil = PROJECTILE.instantiate()#Precisamos desta varial...PQ???
	add_child(temp_projectile)
	temp_projectile.global_position = global_position
	temp_projectile.Inicializa_Projetil(Tower_Index, Tower_Damage)
	
	for Target in (Array_of_Targets):
		if Target != null:
			temp_projectile.set_projectile_target(Target)
			break
	
	temp_projectile.is_Projectile_Flying = true
	List_of_Projectiles.append(temp_projectile)
