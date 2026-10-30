extends State

func enter():
	$"../../Head".play("melt")
	owner.set_collision_mask_value(11, false)
	
func exit():
	$"../../Head".play("melt")
	owner.set_collision_mask_value(11, true)

func set_state(state_name):
	if state_name == "freeze":
		state_transition.emit(self, "normal")
	else:
		state_transition.emit(self, state_name)
