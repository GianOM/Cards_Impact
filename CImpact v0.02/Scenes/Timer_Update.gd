extends Label


@onready var one_second_timer: Timer = $"../One Second Timer"

@export var Total_Timer_in_Seconds: int = 0

func Reset_my_Timer():
	Total_Timer_in_Seconds = 0
	CollisionCheck.is_Shop_Time = false
	one_second_timer.start()#Resets the Timer
	
	
func One_Second_Timer_Timeout():
	Total_Timer_in_Seconds += 1
	
	var minutes: int = Total_Timer_in_Seconds / 60
	var seconds = Total_Timer_in_Seconds % 60
	
	self.text = "%02d:%02d" % [minutes, seconds]
	
	
	if Total_Timer_in_Seconds % 20 == 0:
		CollisionCheck.is_Shop_Time = true
		print("It's Shop time for %d" % multiplayer.get_unique_id())
	elif Total_Timer_in_Seconds % 45 == 0:
		CollisionCheck.is_Shop_Time = false
		print("Shop time is over for %d" % multiplayer.get_unique_id())
