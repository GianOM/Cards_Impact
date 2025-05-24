class_name Tower_Base
extends Node3D

var Base_Possible_Targets:Array[Moving_Units]

#Usar Export para ser sincronizado
@export var Base_Health_Points : float = 5500.0

@onready var progress_bar: Control = $SubViewport/ProgressBar


@onready var base_node_3d: Node3D = $"."
@onready var base_projectile_origin_marker_3d: Marker3D = $Base_Projectile_Origin_Marker3D

var Base_Projectiles:Array[Projetil]

const PROJECTILE = preload("res://Scenes/3D/Projectile/Projectile.tscn")

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer



func _ready():
	# Ensure this node is configured for multiplayer
	# In a server-authoritative setup, the server should have authority over the base.
	# If the base is a scene spawned by the MultiplayerSpawner,
	# it will typically already have the server as its authority.
	#if multiplayer.is_server():
		#set_multiplayer_authority(1) # Server (peer ID 1) has authority
		#print("EU SOU A LEI")
	#else:
		# Clients don't have authority over the base, they just observe its state
		pass

@rpc("any_peer","call_local","reliable")
func Take_Damage(Amount:float):
	#if !is_multiplayer_authority():
		#return
		
		
	print("UI TOMEI")
	
	
	Base_Health_Points -= Amount
	#O codigo abaixo atualiza a UI de Vida
	progress_bar.get_node("Base_Progress_Bar").Update_Base_Health(Base_Health_Points)
	
	#multiplayer_synchronizer.set_rep


func _process(delta: float) -> void:
	#print(str(Base_Health_Points)+ " " + str(multiplayer.get_unique_id()))
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Moving_Units:
		#Seta o alvo da tropa, para que assim a tropa possa acessa - lo e dar dano
		body.Tower_Target = base_node_3d
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
			
	if Base_Projectiles.size() > 32:#Limpa o array com os projeteis da Base
		Base_Projectiles = Base_Projectiles.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null
