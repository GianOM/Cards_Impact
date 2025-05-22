extends MeshInstance3D

const TowersResourceDatabase = preload("res://Scripts/3D/Tower/Towers_Resource_Database.gd")
@onready var Dados_do_Projetil: Projectile_Data = preload("res://Scripts/3D/Projectiles/Projectile_Resource_Example.tres")
@onready var projectile_body_3d: Projetil = $".."


func seleciona_mesh_do_projetil_pelo_indice(index:int):
	Dados_do_Projetil.Set_Projectile_Mesh_Based_on_ID(index)
	
	mesh = Dados_do_Projetil.Mesh_3D.mesh
	
	projectile_body_3d.Projectile_Speed = Dados_do_Projetil.Projectile_Speed
	projectile_body_3d.Projectile_Damage = Dados_do_Projetil.Projectile_Damage
	
