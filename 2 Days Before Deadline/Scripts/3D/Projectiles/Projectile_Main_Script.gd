class_name Projetil
extends CharacterBody3D

var Projectile_Speed: float
var Projectile_Damage: float
var is_Projectile_Flying: bool = false
var Target: Moving_Units

var Dead_Target_Position:Vector3

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
		
		Dead_Target_Position = Target.global_position
		#rotation.z += 1.25 * delta
		
	#O codigo abaixo garante que o projetil nao desapareca do nada enquanto esta voando e o alvo foi morto
	#Assim, ele continua ate que a distancia no eixo X seja minima, quando entao ele se apaga
	elif Target == null and is_Projectile_Flying:
		if ( abs(global_position.z - Dead_Target_Position.z) < 0.1):
			queue_free()
		else:
			velocity = global_position.direction_to(Dead_Target_Position) * Projectile_Speed
			look_at(Dead_Target_Position)
			move_and_slide()
			#queue_free()
		
	#Adcionar aqui uma funcao pra destruir o projeto mid-air se o Target morrer
	
func set_projectile_target(Alvo: Moving_Units):
	Target = Alvo
	
func Inicializa_Projetil(index:int, Tower_damage: float):
	
	var Projectile_Data_Resource: Projectile_Data = Projectile_Database[index]
	
	var Projectile_Scene = load(Projectile_Data_Resource.Projectile_Scene_Path)#Carrega a PackedScene contendo a malha 3D
	var Correct_Projectile_InstanceMesh3D = Projectile_Scene.instantiate()#Ja que a Packed Scene so contem uma InstanceMesh3D, instancia-la carrega para uma variavel
	
	add_child(Correct_Projectile_InstanceMesh3D)
	#$Projectile_Mesh.mesh = Correct_Projectile_InstanceMesh3D.mesh
	
	Projectile_Speed = Projectile_Data_Resource.Projectile_Speed
	Projectile_Damage = Tower_damage
	
