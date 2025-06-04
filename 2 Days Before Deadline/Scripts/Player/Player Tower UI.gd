extends Control


func _on_close_button_clicked():
	hide()

func Initialize_Tower_Parameters(Torre_Parametro:Torre):
	show()
	$Panel/Tower_Name.text = Torre_Parametro.Tower_Name
	$"Panel/Tower Stats Numbers/VBoxContainer/Range Number Text".text = str(Torre_Parametro.Tower_Range)
	$"Panel/Tower Stats Numbers/VBoxContainer/Damage Number Text".text = str(Torre_Parametro.Tower_Damage)
	$"Panel/Tower Stats Numbers/VBoxContainer/Atack Speed Number Text".text = str(Torre_Parametro.Tower_Shooting_Cooldown)
