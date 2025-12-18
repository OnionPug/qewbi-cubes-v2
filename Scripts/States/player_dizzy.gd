extends State

func enter():
	owner.can_attack = false
	

func exit():
	owner.can_attack = true
