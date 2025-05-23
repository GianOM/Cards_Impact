class_name Projetil
extends CharacterBody3D

var Projectile_Speed: float
var Projectile_Damage: float
var is_Projectile_Flying: bool = false
var Target: Moving_Units

@onready var projectile_mesh: MeshInstance3D = $Projectile_Mesh

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == Target:#So da dano na tropa que mirou
		Target.Take_Damage(Projectile_Damage)#Funcao que subtrai o parametro da propria vida
		queue_free()
		
func _process(_delta: float) -> void:
	if Target != null:
		velocity = global_position.direction_to(Target.global_position) * Projectile_Speed
		look_at(Target.global_position)
		move_and_slide()
		#rotation.z += 1.25 * delta
		
	elif Target == null and is_Projectile_Flying:
		queue_free()
		
	#Adcionar aqui uma funcao pra destruir o projeto mid-air se o Target morrer
	
func set_projectile_target(Alvo: Moving_Units):
	Target = Alvo
	
func seleciona_mesh_pelo_indice(index:int):
	projectile_mesh.seleciona_mesh_do_projetil_pelo_indice(index)
