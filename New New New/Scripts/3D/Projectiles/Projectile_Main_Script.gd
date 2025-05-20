class_name Projetil
extends CharacterBody3D

var Projectile_Speed: float = 10.0
var Projectile_Damage: float = 5
var is_Projectile_Flying: bool = false
var Target: Moving_Units

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:#CODIGO SE O PROJETIL ACERTA UMA MOVING UNIT
		#BUGG OU  FEATURE: Se a torre mira em um alvo, e alguem passa 
		#na frente dele, o projetil acerta este alguem que entrou na frente
		Target.Take_Damage(Projectile_Damage)#Funcao que subtrai o parametro da propria vida
		queue_free()
		
func _process(_delta: float) -> void:
	if Target != null:
		velocity = global_position.direction_to(Target.global_position) * Projectile_Speed
		look_at(Target.global_position)
		move_and_slide()
		
	elif Target == null and is_Projectile_Flying:
		queue_free()
		
	#Adcionar aqui uma funcao pra destruir o projeto mid-air se o Target morrer
	
func set_projectile_target(Alvo: Moving_Units):
	Target = Alvo
