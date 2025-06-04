extends Area3D

const TROOPS = preload("res://Scenes/3D/Troops/Troops.tscn")

@export var Number_of_Troops_to_Spawn: int = 0
@export var Path_Team: int 

#Contador pra Debugar
@onready var enemy_spawner_counter: Control = $"Enemy Spawner/SubViewport/EnemySpawnerCounter"
@onready var enemy_spawner: Enemy_Spawner = $"Enemy Spawner"




var troop_types: Array[Moving_Units_Data] = []

var Lista_de_Tropas: Array[PathFollow3D]#Array contendo todas as tropas a serem spawnadas



func _ready() -> void:
	enemy_spawner.Troop_Spawner_Team = Path_Team
	Load_Moving_Units_Resource_from_Path("res://Scripts/3D/Troops/Data/")
	
func Load_Moving_Units_Resource_from_Path(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
				#print("Found directory: " + file_name)
			else:
				#O CODIGO ABAIXO E PARA CONSEGUIR RODAR QUANDO EXPORTED:
				#https://github.com/godotengine/godot/issues/66014
				if '.tres.remap' in file_name: # <---- NEW
					file_name = file_name.trim_suffix('.remap') # <---- NEW
				
				var file_path = path.path_join(file_name)
				var resource = load(file_path)
				#print("Found file: " + file_name)
				troop_types.append(resource)
			file_name = dir.get_next()

@rpc("any_peer","call_local","reliable")
func Adcionar_Tropa_Ao_Enemy_Spawner(idx:int, Number_of_Troops:int):#Quem chama esta funcao e somente o EnemySpawner
	var troop_data_resource: Moving_Units_Data = troop_types[idx]
	
	var troop_scene = load(troop_data_resource.troop_scene_path)#Carrega a PackedScene contendo a malha 3D
	var Correct_Troop_InstanceMesh3D = troop_scene.instantiate()#Ja que a Packed Scene so contem uma InstanceMesh3D, instancia-la carrega para uma variavel
	
	#Seta os parametros da tropa e guarda em um array de PathFollows
	var temp_troop = TROOPS.instantiate()
	temp_troop.get_node("Moving_Unit_CharacterBody3D").inicializar_Moving_Unit(troop_data_resource, Correct_Troop_InstanceMesh3D)
	
	for i in range(troop_data_resource.Troops_Quantity):
		
		#Usamos um duplicate ou entao ele nao consegue adcionar
		Lista_de_Tropas.append(temp_troop.duplicate())
		
		Number_of_Troops_to_Spawn += 1
		enemy_spawner_counter.get_node("Troops_Counter").text = str(Number_of_Troops_to_Spawn)

func _on_spawn_timer_cooldown_timeout() -> void:
	#ReadyButton.I_AM_READY é uma variavel global que indica que o player esta ready
	#print(ReadyButton.I_AM_READY)
	if Number_of_Troops_to_Spawn > 0:
		$Path3D.add_child(Lista_de_Tropas[-Number_of_Troops_to_Spawn])
		Lista_de_Tropas.remove_at(0)#Removemos o elemento do Array para evitar acessos incorretos
		
		Number_of_Troops_to_Spawn -= 1
		enemy_spawner_counter.get_node("Troops_Counter").text = str(Number_of_Troops_to_Spawn)
		
	Lista_de_Tropas = Lista_de_Tropas.filter(func(p): return p != null)#Limpa um array, removendo toda e qualquer elemento que seja null
