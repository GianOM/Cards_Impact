extends Label


@onready var one_second_timer: Timer = $"../One Second Timer"

@export var Total_Timer_in_Seconds: int = 0


func One_Second_Timer_Timeout():
	Total_Timer_in_Seconds += 1
	
	var minutes = Total_Timer_in_Seconds / 60
	var seconds = Total_Timer_in_Seconds % 60
	
	self.text = "%02d:%02d" % [minutes, seconds]
