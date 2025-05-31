extends Label


@onready var one_second_timer: Timer = $"../One Second Timer"

@export var Total_Timer_in_Seconds: int = 0

func Reset_my_Timer():
	Total_Timer_in_Seconds = 0
	one_second_timer.start()#Resets the Timer
	
	
func One_Second_Timer_Timeout():
	Total_Timer_in_Seconds += 1
	
	var minutes: int = Total_Timer_in_Seconds / 60
	var seconds = Total_Timer_in_Seconds % 60
	
	self.text = "%02d:%02d" % [minutes, seconds]
