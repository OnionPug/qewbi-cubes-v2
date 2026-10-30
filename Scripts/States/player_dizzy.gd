extends State

func enter():
	owner.can_attack = false
	

func exit():
	owner.can_attack = true
	#review this if it sucks
	#or make it equal to UI Healthbar's 100%
	
	$"../..".health = 5
