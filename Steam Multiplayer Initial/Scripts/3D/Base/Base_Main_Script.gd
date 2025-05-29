class_name Tower_Base
extends Node3D

var Base_Possible_Targets:Array[Moving_Units]

#Usar Export para ser sincronizado
@export var Base_Health_Points : float = 5500.0

@onready var progress_bar: Control = $SubViewport/ProgressBar

const PROJECTILE = preload("res://Scenes/3D/Projectile/Projectile.tscn")

@export var Base_Projetile_Damage: float = 10.0

@onready var projectile_generation_point: Projectile_Generator = $"Projectile Generation Point"



func _ready() -> void:
	#Por enquanto estamos inicialiando manualmente o projetil
	projectile_generation_point.Tower_Index = 1
	projectile_generation_point.Tower_Damage = 20.0



@rpc("any_peer","call_local","reliable")
func Take_Damage(Amount:float):
	Base_Health_Points -= Amount
	#O codigo abaixo atualiza a UI de Vida
	progress_bar.get_node("Base_Progress_Bar").Update_Base_Health(Base_Health_Points)





func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		#Seta o alvo da tropa, para que assim a tropa possa acessa - lo e dar dano
		body.Base_Target = self
		Base_Possible_Targets.append(body)


func _on_base_buller_spawner_timer_timeout() -> void:
	if Base_Possible_Targets.size() > 0:
			projectile_generation_point.Spawn_a_Prjectile(Base_Possible_Targets)
			
			
			Base_Possible_Targets = Base_Possible_Targets.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null
			
	if projectile_generation_point.List_of_Projectiles.size() > 16:
		projectile_generation_point.Clean_Up_Projectile_Array()
