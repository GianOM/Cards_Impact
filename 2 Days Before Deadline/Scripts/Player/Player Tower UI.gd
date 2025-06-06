extends Control

var My_Hexagon: Hexagono
@onready var player: Node3D = $"../.."

func _on_close_button_clicked():
	hide()

func Initialize_Tower_Parameters(Clicked_Hexagon:Hexagono):
	show()
	
	#Registra o ultimo Hexagono clickado para futuras operacoes
	My_Hexagon = Clicked_Hexagon
	
	$Panel/Tower_Name.text = Clicked_Hexagon.Placed_Tower.Tower_Name
	$"Panel/Tower Stats Numbers/VBoxContainer/Range Number Text".text = str(Clicked_Hexagon.Placed_Tower.Tower_Range)
	$"Panel/Tower Stats Numbers/VBoxContainer/Damage Number Text".text = str(Clicked_Hexagon.Placed_Tower.Tower_Damage)
	$"Panel/Tower Stats Numbers/VBoxContainer/Atack Speed Number Text".text = str(Clicked_Hexagon.Placed_Tower.Tower_Shooting_Cooldown)
	
	if Clicked_Hexagon.Hexagon_Team == player.My_Team:
		#Mostra o Upgrade e Sell apenas se a torre for do seu time
		$"Panel/Upgrade and Sell/HBoxContainer".show()
	
	
	
	
func Upgrade_Selected_Tower():
	My_Hexagon.Placed_Tower.Upgrade_Tower()
	Initialize_Tower_Parameters(My_Hexagon)
	print("UPGRADED")
	
	
func Sell_Selected_Tower():
	player.Delete_Tower_at_Clicked.rpc(My_Hexagon.name)
	hide()
