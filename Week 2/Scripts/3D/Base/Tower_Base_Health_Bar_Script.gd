extends ProgressBar

@onready var base_progress_bar: ProgressBar = $"."

func Update_Base_Health(New_Vida: float):
	set_value(New_Vida)#Seta o valor do Range
	#get_value() pega este valor
	
