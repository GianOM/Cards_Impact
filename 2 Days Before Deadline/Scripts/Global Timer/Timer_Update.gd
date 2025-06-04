extends Label


@onready var one_second_timer: Timer = $"../One Second Timer"

@export var Total_Timer_in_Seconds: int = 0

#Ambos sao numeros primos
var Round_Time: int = 127
var Shop_Time: int = 31

func Reset_my_Timer():
	Total_Timer_in_Seconds = 0
	CollisionCheck.is_Shop_Time = false
	one_second_timer.start()#Resets the Timer
	
func _process(_delta: float) -> void:
	var minutes: int = Total_Timer_in_Seconds / 60
	var seconds = Total_Timer_in_Seconds % 60
	
	self.text = "%02d:%02d" % [minutes, seconds]
	
func One_Second_Timer_Timeout():
	Total_Timer_in_Seconds += 1
	
	if Total_Timer_in_Seconds % Round_Time == 0:
		CollisionCheck.is_Shop_Time = true
		CollisionCheck.start_shop_sequence.emit()
		print("It's Shop time for %d" % multiplayer.get_unique_id())
	elif Total_Timer_in_Seconds % Shop_Time == 0:
		CollisionCheck.is_Shop_Time = false
		print("Shop time is over for %d" % multiplayer.get_unique_id())
