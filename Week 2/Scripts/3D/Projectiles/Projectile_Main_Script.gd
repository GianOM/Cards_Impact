class_name Projetil
extends CharacterBody3D

var Projectile_Speed: float
var Projectile_Damage: float
var is_Projectile_Flying: bool = false
var Target: Moving_Units

#@onready var projectile_mesh: MeshInstance3D = $Projectile_Mesh

@export var Projectile_Database: Array[Projectile_Data] = []

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
	
	var Projectile_Data_Resource: Projectile_Data = Projectile_Database[index]
	
	var Projectile_Scene = load(Projectile_Data_Resource.Projectile_Scene_Path)#Carrega a PackedScene contendo a malha 3D
	var Correct_Projectile_InstanceMesh3D = Projectile_Scene.instantiate()#Ja que a Packed Scene so contem uma InstanceMesh3D, instancia-la carrega para uma variavel
	
	$Projectile_Mesh.mesh = Correct_Projectile_InstanceMesh3D.mesh
	
	Projectile_Speed = Projectile_Data_Resource.Projectile_Speed
	Projectile_Damage = Projectile_Data_Resource.Projectile_Damage
	
