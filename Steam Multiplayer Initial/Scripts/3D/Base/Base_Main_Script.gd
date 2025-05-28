class_name Tower_Base
extends Node3D

var Base_Possible_Targets:Array[Moving_Units]

#Usar Export para ser sincronizado
@export var Base_Health_Points : float = 5500.0

@onready var progress_bar: Control = $SubViewport/ProgressBar


@onready var base_node_3d: Node3D = $"."
@onready var base_projectile_origin_marker_3d: Marker3D = $Base_Projectile_Origin_Marker3D


const PROJECTILE = preload("res://Scenes/3D/Projectile/Projectile.tscn")

@export var Base_Projetile_Damage: float = 10.0


@rpc("any_peer","call_local","reliable")
func Take_Damage(Amount:float):
	Base_Health_Points -= Amount
	#O codigo abaixo atualiza a UI de Vida
	progress_bar.get_node("Base_Progress_Bar").Update_Base_Health(Base_Health_Points)



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		#Seta o alvo da tropa, para que assim a tropa possa acessa - lo e dar dano
		body.Base_Target = base_node_3d
		Base_Possible_Targets.append(body)


func _on_base_buller_spawner_timer_timeout() -> void:
	if Base_Possible_Targets.size() > 0:
			var temp_projectile : Projetil = PROJECTILE.instantiate()#Precisamos desta varial...PQ???
			$"Base Projectile Container".add_child(temp_projectile)
			temp_projectile.global_position = base_projectile_origin_marker_3d.global_position
			
			#Func nao existe mais
			temp_projectile.Inicializa_Projetil(1, Base_Projetile_Damage)
			
			for Base_Target in Base_Possible_Targets:
				if Base_Target != null:
					temp_projectile.set_projectile_target(Base_Target)
					break
			
			temp_projectile.is_Projectile_Flying = true
			
			Base_Possible_Targets = Base_Possible_Targets.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null
