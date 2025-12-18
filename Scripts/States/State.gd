extends Node
class_name State

signal state_transition
var escalation : bool = false

func enter():
	pass

func exit():
	#if escalation: deescalate()
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func set_state(state_name):
	#base code - only works if this function is not declared elsewhere
	state_transition.emit(self, state_name)

func escalate():
	#make the debuff worse
	#escalation = true
	pass

func deescalate():
	#revert the debuff
	#escalation = false
	pass
