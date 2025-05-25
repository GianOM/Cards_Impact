extends Area3D

const TROOPS = preload("res://Scenes/3D/Troops/Troops.tscn")

@export var Number_of_Troops_to_Spawn: int = 0

@onready var path_3d: Path3D = $Path3D
@onready var spawn_timer_cooldown: Timer = $"Spawn Timer Cooldown"

const TroopsData = preload("res://Scripts/3D/Troops/Troops_Data.gd")


@onready var enemy_spawner_counter: Control = $"Enemy Spawner/SubViewport/EnemySpawnerCounter"



@export var troop_types: Array[Moving_Units_Data] = []#Ainda to Usando Isso aq. Como automatizar?



var Lista_de_Tropas: Array[PathFollow3D]#Array contendo todas as tropas a serem spawnadas
var troops_data_instance: Resource

func _ready() -> void:
	troops_data_instance = TroopsData.new()#Cria um novo resource do tipo Troops_Data
	
@rpc("any_peer","call_local","reliable")
func Adcionar_Tropa_Ao_Enemy_Spawner(idx:int):#Quem chama esta funcao e somente o EnemySpawner
	var troop_data_resource: Moving_Units_Data = troop_types[idx]
	
	var troop_scene = load(troop_data_resource.troop_scene_path)#Carrega a PackedScene contendo a malha 3D
	var Correct_Troop_InstanceMesh3D = troop_scene.instantiate()#Ja que a Packed Scene so contem uma InstanceMesh3D, instancia-la carrega para uma variavel
	
	#Seta os parametros da tropa e guarda em um array de PathFollows
	var temp_troop = TROOPS.instantiate()
	temp_troop.get_node("Moving_Unit_CharacterBody3D").inicializar_Moving_Unit(troop_data_resource, Correct_Troop_InstanceMesh3D)
	
	Lista_de_Tropas.append(temp_troop)
	
	Number_of_Troops_to_Spawn += 1
	enemy_spawner_counter.get_node("Troops_Counter").text = str(Number_of_Troops_to_Spawn)

func _on_spawn_timer_cooldown_timeout() -> void:
	#ReadyButton.I_AM_READY é uma variavel global que indica que o player esta ready
	#print(ReadyButton.I_AM_READY)
	if Number_of_Troops_to_Spawn > 0 and is_everyone_ready():
		$Path3D.add_child(Lista_de_Tropas[Number_of_Troops_to_Spawn - 1])
		Number_of_Troops_to_Spawn -= 1
		enemy_spawner_counter.get_node("Troops_Counter").text = str(Number_of_Troops_to_Spawn)
	elif ReadyButton.I_AM_READY == false and Number_of_Troops_to_Spawn == 0:
		Lista_de_Tropas = Lista_de_Tropas.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null
		

func is_everyone_ready() -> bool:
	for player in LobbyMultiplayer.List_of_Players:
		if LobbyMultiplayer.List_of_Players[player].is_Player_Ready == false:
			return false
	return true
